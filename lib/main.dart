import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'providers/theme_provider.dart';
import 'providers/teacher_provider.dart';
import 'providers/classroom_provider.dart';
import 'providers/timetable_provider.dart';
import 'screens/admin/student_management_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => ClassroomProvider()),
        ChangeNotifierProvider(create: (_) => TimeTableProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'College ERP',
          theme: themeProvider.theme,
          home: const RoleSelectionScreen(),
          routes: {
            ManageTeachersScreen.routeName: (ctx) => const ManageTeachersScreen(),
            ManageClassroomsScreen.routeName: (ctx) => const ManageClassroomsScreen(),
            ManageTimeTablesScreen.routeName: (ctx) => const ManageTimeTablesScreen(),
            '/student-management': (ctx) => const StudentManagementScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}