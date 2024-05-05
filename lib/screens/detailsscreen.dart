import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/models/models.dart';
import 'package:intl/intl.dart'; // Pour formatter les dates

class DetailScreen extends StatelessWidget {
  final DataModel dataModel;

  DetailScreen({Key? key, required this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convertissez les Timestamp en String pour l'affichage
    final startDateStr =
        DateFormat('EEEE, MMM d, y').format(dataModel.startDate);
    final endDateStr = DateFormat('EEEE, MMM d, y').format(dataModel.endDate);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                dataModel.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(47, 255, 255, 255),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0.h.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataModel.title,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Start Date: $startDateStr',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'End Date: $endDateStr',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Location: ${dataModel.location}',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Details:",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dataModel.description,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Implémentez la navigation vers la carte ou les détails de l'emplacement
                      },
                      icon: Icon(Icons.map),
                      label: Text(
                        'View map',
                        selectionColor: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50.h.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
