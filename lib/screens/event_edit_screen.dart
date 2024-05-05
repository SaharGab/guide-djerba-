import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class EventEditScreen extends StatefulWidget {
  final String eventId;

  EventEditScreen({required this.eventId});

  @override
  _EventEditScreenState createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  File? _image;
  final picker = ImagePicker();

  late TextEditingController startDateController;
  late TextEditingController endDateController;
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    loadEventData();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  void loadEventData() async {
    var document = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get();
    Map<String, dynamic> data = document.data()!;
    setState(() {
      titleController.text = data['title'];
      descriptionController.text = data['description'];
      locationController.text = data['location'];
      startDate = (data['startDate'] as Timestamp).toDate();
      endDate = (data['endDate'] as Timestamp).toDate();
      startDateController.text =
          DateFormat('yyyy-MM-dd – HH:mm').format(startDate!);
      endDateController.text =
          DateFormat('yyyy-MM-dd – HH:mm').format(endDate!);
      imageUrl =
          data['imageUrl']; // Assurez-vous que cette ligne est dans setState
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Event"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.h.w),
          children: [
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
                  ? (imageUrl == null
                      ? Container(
                          height: 150.h,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.camera_alt,
                              color: Colors.white70, size: 50.h.w),
                        )
                      : Image.network(imageUrl!,
                          height: 200.h,
                          fit: BoxFit.cover)) // Affiche l'image à partir d'URL
                  : Image.file(_image!,
                      height: 200.h,
                      fit: BoxFit.cover), // Affiche l'image locale
            ),

            // Repeat similar text fields for other event attributes
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveEvent();
                  Navigator.pop(context);
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
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
        initialTime: TimeOfDay.fromDateTime(
            (isStart ? startDate : endDate) ?? DateTime.now()),
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
          } else {
            endDate = fullDateTime;
            endDateController.text =
                DateFormat('yyyy-MM-dd – HH:mm').format(endDate!);
          }
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File tempImage = File(pickedFile.path);
      setState(() {
        _image = tempImage; // Met à jour l'image locale
        imageUrl = null; // Efface l'URL précédente
      });
    } else {
      print('No image selected.');
    }
  }

  void saveEvent() {
    if (_formKey.currentState!.validate()) {
      String? uploadImageUrl = imageUrl; // Utilise l'URL existante par défaut
      if (_image != null && imageUrl == null) {
        // Si une nouvelle image est sélectionnée
        uploadImage(_image!).then((newUrl) {
          uploadImageUrl = newUrl;
          performUpdate(uploadImageUrl);
        });
      } else {
        performUpdate(
            uploadImageUrl); // Pas de nouvelle image, mettre à jour avec l'URL existante ou null
      }
    }
  }

  void performUpdate(String? imageUrl) {
    FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
      'title': titleController.text,
      'description': descriptionController.text,
      'location': locationController.text,
      'startDate': startDate,
      'endDate': endDate,
      'imageUrl': imageUrl,
    });
  }

  Future<String> uploadImage(File image) async {
    String fileName = basename(image.path);
    Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = ref.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
