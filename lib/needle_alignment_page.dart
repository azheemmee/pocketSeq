import 'package:flutter/material.dart';

class NeedleAlignmentPage extends StatefulWidget {
  @override
  _NeedleAlignmentPageState createState() => _NeedleAlignmentPageState();
}

//input seq
class _NeedleAlignmentPageState extends State<NeedleAlignmentPage> {
  final TextEditingController _seq1Controller = TextEditingController();
  final TextEditingController _seq2Controller = TextEditingController();
  String _alignmentResult = "";

  // check input
  void calculateAlignment() {
    String seq1 = _seq1Controller.text;
    String seq2 = _seq2Controller.text;

    // Validate input sequences
    if (seq1.isEmpty || seq2.isEmpty) {
      setState(() {
        _alignmentResult = "Please enter both sequences.";
      });
      return;
    }

    List<String> aligned = needlemanWunsch(seq1, seq2);

    setState(() {
      _alignmentResult = "Alignment Result:\n${aligned[0]}\n${aligned[1]}";
    });
  }

  // Needleman func
  List<String> needlemanWunsch(String seq1, String seq2) {
    int matchScore = 1;
    int mismatchPenalty = -1;
    int gapPenalty = -2;

    int n = seq1.length + 1;
    int m = seq2.length + 1;

    List<List<int>> scoreMatrix = List.generate(n, (_) => List.filled(m, 0));

    // Initialize score matrix
    for (int i = 0; i < n; i++) {
      scoreMatrix[i][0] = i * gapPenalty;
    }
    for (int j = 0; j < m; j++) {
      scoreMatrix[0][j] = j * gapPenalty;
    }

    // Fill the score matrix
    for (int i = 1; i < n; i++) {
      for (int j = 1; j < m; j++) {
        int match = scoreMatrix[i - 1][j - 1] +
            (seq1[i - 1] == seq2[j - 1] ? matchScore : mismatchPenalty);
        int delete = scoreMatrix[i - 1][j] + gapPenalty;
        int insert = scoreMatrix[i][j - 1] + gapPenalty;
        scoreMatrix[i][j] = [match, delete, insert].reduce((a, b) => a > b ? a : b);
      }
    }

    // Traceback to get the aligned sequences
    String alignedSeq1 = "";
    String alignedSeq2 = "";
    int i = n - 1;
    int j = m - 1;

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

    // Add remaining gaps
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

    return [alignedSeq1, alignedSeq2];
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
            // First sequence input field
            TextField(
              controller: _seq1Controller,
              decoration: InputDecoration(labelText: 'Enter first sequence'),
            ),
            SizedBox(height: 10),
            // Second sequence input field
            TextField(
              controller: _seq2Controller,
              decoration: InputDecoration(labelText: 'Enter second sequence'),
            ),
            SizedBox(height: 20),
            // Button to trigger the alignment calculation
            ElevatedButton(
              onPressed: calculateAlignment,
              child: Text("Calculate Alignment"),
            ),
            SizedBox(height: 20),
            // Display the result of the alignment
            Text(
              _alignmentResult,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Button to go back to the home page
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
