import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About WanderMate',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        backgroundColor:
            Color.fromARGB(255, 18, 120, 171), // Feel free to change the color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to WanderMate!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              "WanderMate is your essential travel companion, designed to unveil the hidden wonders of Djerba Island in a unique and personalized way. Our mission is to transform every trip to Djerba into an unforgettable adventure by guiding you through the hidden treasures and authentic experiences that only this magical island can offer.\n\n"
              "With WanderMate, embark on a journey that defies the conventional tourist paths. Explore the rich tapestry of Djerba's history, culture, and natural beauty at your own pace. From the mesmerizing beaches and captivating landscapes to the ancient sites whispering tales of yore, WanderMate brings Djerba's story to life, right at your fingertips.\n\n"
              "Whether you're a history enthusiast, a nature lover, or someone seeking to immerse in local traditions and cuisine, WanderMate tailors your journey to match your interests. Our app not only recommends personalized itineraries but also provides insights and tips to enhance your experience, ensuring that each moment in Djerba is as enriching as it is exhilarating.\n\n"
              "Join us on WanderMate to discover Djerba like never before. Your adventure begins here.",
            ),
            const SizedBox(height: 20),
            // Add more sections here as needed, such as version info, contact info, etc.
          ],
        ),
      ),
    );
  }
}
