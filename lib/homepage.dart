import 'package:flutter/material.dart';
import 'needle_alignment_page.dart';  // Import your NeedleAlignmentPage
import 'waterman_smith_page.dart';  // Import your WatermanSmithPage

void main() => runApp(SeqAlignApp());

class SeqAlignApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketSeq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/needle': (context) => NeedleAlignmentPage(),  // Navigate to Needleman-Wunsch
        '/waterman': (context) => WatermanSmithPage(),  // Navigate to Smith-Waterman
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to PocketSeq')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to PocketSeq',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/needle'); // Navigate to Needleman-Wunsch
              },
              child: Text('Needle Sequence Alignment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/waterman'); // Navigate to Smith-Waterman
              },
              child: Text('Smith-Waterman Alignment'),
            ),
          ],
        ),
      ),
    );
  }
}