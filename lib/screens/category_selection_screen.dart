import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/screens/event_list_screen.dart';
import 'event_details_screen.dart';
import 'settings.dart';

class CategorySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
        actions: [
          IconButton(
            icon: Icon(Icons.list_sharp),
            onPressed: () {
              // Assurez-vous que la page EventAddScreen est disponible dans votre projet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventListScreen()),
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
      body: Container(
        padding: EdgeInsets.only(top: 30.h),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.h.w),
          children: <Widget>[
            _buildCategoryCard(
                context, 'Accommodation', 'icons/accomodation.png'),
            _buildCategoryCard(context, 'Café & Restaurant', 'icons/bar.png'),
            _buildCategoryCard(context, 'Activities', 'icons/surfboard.png'),
            _buildCategoryCard(context, 'To Explore', 'icons/signpost.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String category, String iconPath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetailsScreen(category: category)),
        );
      },
      child: Card(
        color: Color.fromARGB(150, 18, 120, 171),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(iconPath, width: 80.w),
            Text(category,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
