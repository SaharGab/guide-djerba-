import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:projet_pfe/screens/category_selection_screen.dart';
import 'package:projet_pfe/screens/event_edit_screen.dart';
import 'package:projet_pfe/screens/settings.dart';
import 'package:projet_pfe/screens/signin.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Event Management"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Assurez-vous que la page EventAddScreen est disponible dans votre projet
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategorySelectionScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Assurez-vous que la page EventAddScreen est disponible dans votre projet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPg()),
              );
            },
          ),
        ],
      ),
      body: userId == null
          ? Center(child: Text("Please log in"))
          : buildEventList(userId),
    );
  }

  Widget buildEventList(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text("No events found."));
        }
        var data = snapshot.data!.docs;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Actions')),
            ],
            rows: data.map((document) => buildDataRow(document)).toList(),
          ),
        );
      },
    );
  }

  DataRow buildDataRow(QueryDocumentSnapshot document) {
    return DataRow(cells: [
      DataCell(Text(document['title'])),
      DataCell(Text(DateFormat('yyyy-MM-dd – HH:mm')
          .format(document['startDate'].toDate()))),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editEvent(document.id),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(document.id),
            ),
          ],
        ),
      ),
    ]);
  }

  void _showDeleteDialog(String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteEvent(eventId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Signin()));
  }

  void _editEvent(String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EventEditScreen(eventId: eventId)),
    );
  }

  void _deleteEvent(String eventId) {
    FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .delete()
        .then((_) {
      setState(() {
        // Refresh the state of your Widget
      });
    });
  }
}
