import 'package:flutter/material.dart';
import 'screens/homework_solver_screen.dart';

void main() {
  runApp(const HomeworkSolverApp());
}

class HomeworkSolverApp extends StatelessWidget {
  const HomeworkSolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework Solver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeworkSolverScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
