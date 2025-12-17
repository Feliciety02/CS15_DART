import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'logic/parking_service.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


final ParkingService parkingService = ParkingService();

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const ParkingApp());
}


class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const DashboardScreen(),
    );
  }
}
