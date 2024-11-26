import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history.dart'; // Import HistoryPage to navigate to detailed alignment

String? loggedInUser;

class AlignmentHistoryPage extends StatefulWidget {
  final String username;

  const AlignmentHistoryPage({Key? key, required this.username}) : super(key: key);

  @override
  _AlignmentHistoryPageState createState() => _AlignmentHistoryPageState();
}

class _AlignmentHistoryPageState extends State<AlignmentHistoryPage> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // Load alignment history from shared_preferences
  void loadHistory() async {
  // Load the alignment history
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = "alignment_history_${loggedInUser ?? 'guest'}";  // Same key used when saving the history
  setState(() {
    history = prefs.getStringList(key) ?? [];

  print('Loading history for user: ${loggedInUser ?? 'guest'}');  // Print key for debugging
  
});

}

  // Parse the history string to a Map
  Map<String, dynamic> parseHistoryResult(String historyEntry) {
    List<String> parts = historyEntry.split(' | ');
    String alignedSeq1 = parts[0];
    String alignedSeq2 = parts[1];
    int alignmentScore = int.tryParse(parts[2].split(": ")[1]) ?? 0;
    
    List<List<int>> scoreMatrix = []; // Placeholder, you might want to add real matrix data

    return {
      'alignedSeq1': alignedSeq1,
      'alignedSeq2': alignedSeq2,
      'alignmentScore': alignmentScore,
      'scoreMatrix': scoreMatrix,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.username}'s Alignment History")),
      body: history.isEmpty
          ? Center(child: Text("No alignment history found."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Alignment ${index + 1}"),
                  subtitle: Text(history[index]),
                  onTap: () {
                    // Navigate to the detailed HistoryPage with the selected alignment
                    Map<String, dynamic> alignmentResult = parseHistoryResult(history[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(alignmentResult: alignmentResult),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
