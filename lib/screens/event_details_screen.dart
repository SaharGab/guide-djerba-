import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:io';

import 'package:projet_pfe/screens/event_list_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final String category;

  EventDetailsScreen({required this.category});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final List<String> categories = [
    'Cultural Events - Music Festivals',
    'Cultural Events - Theater Productions',
    'Sporting Events - Tournaments',
    'Nightlife and Entertainment - DJ Nights',
    'Nightlife and Entertainment - Themed Parties',
    'Food and Beverage Events - Wine Tastings',
    'Food and Beverage Events - Food Festivals',
    'Educational and Environmental Activities - Wildlife Tours',
    'Family-Friendly Events - Carnivals',
    'Fairs - Craft Fairs',
    'Fairs - Trade Fairs',
  ];
  String? _selectedCategory;

  DateTime? startDate;
  DateTime? endDate;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    deleteExpiredEvents(); // Nettoie les événements expirés à chaque démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.h.w),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value:
                    _selectedCategory, // Variable pour stocker la catégorie sélectionnée
                decoration: InputDecoration(
                  labelText: 'Select Event Category',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
            ),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a title' : null,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
            ),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a location' : null,
            ),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'Start Date and Time',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(context, true),
            ),
            TextField(
              controller: endDateController,
              decoration: InputDecoration(
                labelText: 'End Date and Time',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(context, false),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                      height: 150.h,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.cloud_download,
                        color: const Color.fromARGB(230, 255, 255, 255),
                        size: 50.h.w,
                      ),
                    )
                  : Image.file(_image!, height: 200.h),
            ),
            ElevatedButton(
              onPressed: _submitEvent,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteExpiredEvents() async {
    final now = Timestamp.now();
    final eventsRef = FirebaseFirestore.instance.collection('events');
    print('Running deleteExpiredEvents...'); // Log pour suivre le processus
    final querySnapshot =
        await eventsRef.where('endDate', isLessThanOrEqualTo: now).get();
    print(
        'Found ${querySnapshot.docs.length} expired events'); // Nombre d'événements expirés

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
      print('Deleted event with ID: ${doc.id}'); // Log pour chaque suppression
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isStart) {
            startDate = fullDateTime;
            startDateController.text =
                DateFormat('yyyy-MM-dd – HH:mm').format(startDate!);
            if (endDate != null && endDate!.isBefore(startDate!)) {
              endDate = startDate;
              endDateController.text = startDateController.text;
            }
          } else {
            if (startDate != null && pickedDate.isBefore(startDate!)) {
              endDate = startDate;
              endDateController.text = startDateController.text;
            } else {
              endDate = fullDateTime;
              endDateController.text =
                  DateFormat('yyyy-MM-dd – HH:mm').format(endDate!);
            }
          }
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate() &&
        startDate != null &&
        endDate != null) {
      if (_image != null) {
        try {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          FirebaseStorage storage = FirebaseStorage.instance;
          Reference ref = storage.ref().child('images');
          Reference referenceImageToUpload = ref.child(fileName);
          UploadTask uploadTask = referenceImageToUpload.putFile(_image!);
          String imageUrl = await (await uploadTask).ref.getDownloadURL();
          _saveEventToFirebase(imageUrl);
        } catch (e) {
          print(e);
        }
      } else {
        _saveEventToFirebase(null);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Please fill out all fields and select dates properly.')));
    }
  }

  void _saveEventToFirebase(String? imageUrl) {
    String? userId = FirebaseAuth
        .instance.currentUser?.uid; // Obtenir l'ID de l'utilisateur actuel
    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User not logged in!")));
      return;
    }
    FirebaseFirestore.instance.collection('events').add({
      'title': titleController.text,
      'description': descriptionController.text,
      'location': locationController.text,
      'startDate': startDate,
      'endDate': endDate,
      'categorySites': widget.category,
      'categoryEvent': _selectedCategory,
      'imageUrl': imageUrl ?? '',
      'userId': userId,
    }).then((result) {
      print('Event Added');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Event Successfully Added!'),
        duration: Duration(seconds: 2),
      ));
      // Utiliser un délai pour permettre à l'utilisateur de voir le message.
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventListScreen()));
      });
    }).catchError((error) {
      print('Failed to add event: $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add event: $error')));
    });
  }
}
