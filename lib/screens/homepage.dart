import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/models/models.dart';
import 'package:projet_pfe/screens/data_base_service.dart';
import 'package:projet_pfe/screens/storyscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 18, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Events",
                style: GoogleFonts.montserrat(
                    fontSize: 17, fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  // Here you can add functionality to navigate to a screen that shows all events
                  print('See all clicked');
                },
                child: Text(
                  'See all',
                  style: GoogleFonts.montserrat(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<List<DataModel>>(
            stream: _databaseService.getEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return storyCard(snapshot.data!, index);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        SizedBox(height: 100),
      ]),
    );
  }

  Widget storyCard(List<DataModel> allStories, int index) {
    DataModel data = allStories[index];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              StoryScreen(stories: allStories, initialStoryIndex: index),
        ));
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  16.0), // Pour obtenir des coins arrondis
              child: Image.network(
                data.imageUrl,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
