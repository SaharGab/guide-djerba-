import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavesPage extends StatefulWidget {
  const SavesPage({super.key});

  @override
  State<SavesPage> createState() => __SavesPageState();
}

class __SavesPageState extends State<SavesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saves',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24.sp,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
