import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/health_provider.dart';
import 'features/welcome/animated_welcome_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/health_records/add_record_screen.dart';
import 'features/health_records/record_list_screen.dart';
import 'features/health_records/search_records_screen.dart';

void main() {
  runApp(const HealthMateApp());
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HealthProvider(),
      child: MaterialApp(
        title: 'HealthMate',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const AnimatedWelcomeScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/records': (context) => const RecordListScreen(),
          '/add-record': (context) => const AddRecordScreen(),
          '/search': (context) => const SearchRecordsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}