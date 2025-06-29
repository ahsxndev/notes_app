import 'package:flutter/material.dart';
import 'package:notes_app/screens/notes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black87,
          selectionColor: Color(0xFFB2DFDB),         // Soft teal selection
          selectionHandleColor: Colors.black87,
        ),
      ),
      home: const NotesScreen(),
    );
  }
}

