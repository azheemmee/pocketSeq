import 'package:flutter/material.dart';
import 'needle_alignment_page.dart'; // Import your NeedleAlignmentPage
import 'waterman_smith_page.dart';  // Import your WatermanSmithPage
import 'feedbackpage.dart'; // Import your FeedbackPage
import 'alignment_history_page.dart'; // Import your AlignmentHistoryPage

class SeqAlignApp extends StatelessWidget {
  final String? loggedInUser; // Accept loggedInUser as a named parameter

  const SeqAlignApp({super.key, this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketSeq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(loggedInUser: loggedInUser), // Pass loggedInUser to HomePage
        '/waterman': (context) => WatermanSmithPage(),
        '/feedback': (context) => FeedbackPage(),
        '/history': (context) => AlignmentHistoryPage(
              username: loggedInUser ?? "Guest", // Pass loggedInUser to AlignmentHistoryPage
            ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final String? loggedInUser; // Accept loggedInUser as a parameter

  const HomePage({super.key, this.loggedInUser});

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
                // Navigate to NeedleAlignmentPage, passing the login status dynamically
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NeedleAlignmentPage(isLoggedIn: loggedInUser != null),
                  ),
                );
              },
              child: Text('Needle Sequence Alignment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Smith-Waterman page
                Navigator.pushNamed(context, '/waterman');
              },
              child: Text('Smith-Waterman Alignment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Feedback only accessible for logged-in users
                if (loggedInUser != null) {
                  Navigator.pushNamed(context, '/feedback');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please log in to provide feedback'),
                    ),
                  );
                }
              },
              child: Text('Provide Feedback'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Alignment History page if user is logged in
                if (loggedInUser != null) {
                  Navigator.pushNamed(context, '/history');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please log in to view history.'),
                    ),
                  );
                }
              },
              child: Text('View Alignment History'),
            ),
            SizedBox(height: 20),
            if (loggedInUser != null)
              Text(
                "Logged in as: $loggedInUser",
                style: TextStyle(color: Colors.green),
              )
            else
              Text(
                "You are currently logged in as a guest",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
