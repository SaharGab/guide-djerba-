import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:projet_pfe/models/touristSites.dart';

class SeePlan extends StatelessWidget {
  final TouristSite activity;

  SeePlan({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'icons/heart 1.png',
              color: Colors.black,
              width: 25,
              height: 30,
            ),
            onPressed: () {
              // Implement favorite logic for 'activity'
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Images Carousel
            Container(
              height: 300,
              child: PageView.builder(
                itemCount: activity.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    activity.imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            // Description and Other Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // activity Name in Bold
                  Text(
                    activity.name,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Location with Icon
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          activity.location,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Description Paragraph
                  Text(
                    activity.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  // View Map Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement view map logic for 'activity'
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        'View map'.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
