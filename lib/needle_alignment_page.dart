import 'package:flutter/material.dart';
import 'history.dart'; // Import the History Page

String? loggedInUser;

class NeedleAlignmentPage extends StatefulWidget {
  final bool isLoggedIn; // Determines if the user is logged in

  const NeedleAlignmentPage({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  _NeedleAlignmentPageState createState() => _NeedleAlignmentPageState();
}

class _NeedleAlignmentPageState extends State<NeedleAlignmentPage> {
  final TextEditingController _seq1Controller = TextEditingController();
  final TextEditingController _seq2Controller = TextEditingController();
  final TextEditingController _matchScoreController = TextEditingController();
  final TextEditingController _gapPenaltyController = TextEditingController();
  final TextEditingController _mismatchPenaltyController = TextEditingController();

  void calculateAlignment() {
    String seq1 = _seq1Controller.text.trim();
    String seq2 = _seq2Controller.text.trim();

    // Validate input sequences
    if (seq1.isEmpty || seq2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both sequences.')),
      );
      return;
    }

    // Parse scoring inputs or use default values
    int matchScore = int.tryParse(_matchScoreController.text) ?? 1;
    int mismatchPenalty = int.tryParse(_mismatchPenaltyController.text) ?? -2;
    int gapPenalty = int.tryParse(_gapPenaltyController.text) ?? -2;

    // Perform Needleman-Wunsch alignment
    var result =
        needlemanWunsch(seq1, seq2, matchScore, mismatchPenalty, gapPenalty);

    // Redirect for logged-in users or display result for guests
    if (widget.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(
            alignmentResult: result,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Aligned Sequences:\n${result['alignedSeq1']}\n${result['alignedSeq2']}"),
      ));
    }
  }

  Map<String, dynamic> needlemanWunsch(
      String seq1, String seq2, int matchScore, int mismatchPenalty, int gapPenalty) {
    int n = seq1.length + 1;
    int m = seq2.length + 1;

    List<List<int>> scoreMatrix = List.generate(n, (_) => List.filled(m, 0));
    for (int i = 0; i < n; i++) scoreMatrix[i][0] = i * gapPenalty;
    for (int j = 0; j < m; j++) scoreMatrix[0][j] = j * gapPenalty;

    for (int i = 1; i < n; i++) {
      for (int j = 1; j < m; j++) {
        int match = scoreMatrix[i - 1][j - 1] +
            (seq1[i - 1] == seq2[j - 1] ? matchScore : mismatchPenalty);
        int delete = scoreMatrix[i - 1][j] + gapPenalty;
        int insert = scoreMatrix[i][j - 1] + gapPenalty;
        scoreMatrix[i][j] = [match, delete, insert].reduce((a, b) => a > b ? a : b);
      }
    }

    String alignedSeq1 = "", alignedSeq2 = "";
    int i = n - 1, j = m - 1;
    int alignmentScore = scoreMatrix[i][j];

    while (i > 0 && j > 0) {
      int current = scoreMatrix[i][j];
      if (current == scoreMatrix[i - 1][j - 1] +
          (seq1[i - 1] == seq2[j - 1] ? matchScore : mismatchPenalty)) {
        alignedSeq1 = seq1[i - 1] + alignedSeq1;
        alignedSeq2 = seq2[j - 1] + alignedSeq2;
        i--;
        j--;
      } else if (current == scoreMatrix[i][j - 1] + gapPenalty) {
        alignedSeq1 = "-" + alignedSeq1;
        alignedSeq2 = seq2[j - 1] + alignedSeq2;
        j--;
      } else {
        alignedSeq1 = seq1[i - 1] + alignedSeq1;
        alignedSeq2 = "-" + alignedSeq2;
        i--;
      }
    }

    while (i > 0) {
      alignedSeq1 = seq1[i - 1] + alignedSeq1;
      alignedSeq2 = "-" + alignedSeq2;
      i--;
    }
    while (j > 0) {
      alignedSeq1 = "-" + alignedSeq1;
      alignedSeq2 = seq2[j - 1] + alignedSeq2;
      j--;
    }

    return {
      'alignedSeq1': alignedSeq1,
      'alignedSeq2': alignedSeq2,
      'scoreMatrix': scoreMatrix,
      'alignmentScore': alignmentScore
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Needle Sequence Alignment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _seq1Controller,
              decoration: InputDecoration(labelText: 'Enter first sequence'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _seq2Controller,
              decoration: InputDecoration(labelText: 'Enter second sequence'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _matchScoreController,
              decoration: InputDecoration(labelText: 'Match Score (default: 1)'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _gapPenaltyController,
              decoration: InputDecoration(labelText: 'Gap Penalty (default: -2)'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _mismatchPenaltyController,
              decoration:
                  InputDecoration(labelText: 'Mismatch Penalty (default: -2)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateAlignment,
              child: Text("Calculate Alignment"),
            ),
            SizedBox(height: 20),
            if (!widget.isLoggedIn)
              Text(
                "Note: Guests cannot save or view history. Please log in.",
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
