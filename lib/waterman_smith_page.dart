import 'package:flutter/material.dart';

class WatermanSmithPage extends StatefulWidget {
  @override
  _WatermanSmithPageState createState() => _WatermanSmithPageState();
}

class _WatermanSmithPageState extends State<WatermanSmithPage> {
  TextEditingController seq1Controller = TextEditingController();
  TextEditingController seq2Controller = TextEditingController();
  String alignmentResult = '';

  // Scoring system
  final matchScore = 3;
  final mismatchPenalty = -1;
  final gapPenalty = -2;

  // Smith-Waterman algorithm function
  String smithWaterman(String seq1, String seq2) {
    int n = seq1.length + 1;
    int m = seq2.length + 1;
    List<List<int>> scoreMatrix = List.generate(n, (i) => List.filled(m, 0));
    int maxScore = 0;
    int maxI = 0, maxJ = 0;

    // Fill the score matrix
    for (int i = 1; i < n; i++) {
      for (int j = 1; j < m; j++) {
        int match = scoreMatrix[i - 1][j - 1] + (seq1[i - 1] == seq2[j - 1] ? matchScore : mismatchPenalty);
        int delete = scoreMatrix[i - 1][j] + gapPenalty;
        int insert = scoreMatrix[i][j - 1] + gapPenalty;
        scoreMatrix[i][j] = [0, match, delete, insert].reduce((a, b) => a > b ? a : b);

        if (scoreMatrix[i][j] > maxScore) {
          maxScore = scoreMatrix[i][j];
          maxI = i;
          maxJ = j;
        }
      }
    }

    // Traceback to find the best alignment
    String align1 = '';
    String align2 = '';
    int i = maxI, j = maxJ;
    while (scoreMatrix[i][j] > 0) {
      if (scoreMatrix[i][j] == scoreMatrix[i - 1][j - 1] + (seq1[i - 1] == seq2[j - 1] ? matchScore : mismatchPenalty)) {
        align1 = seq1[i - 1] + align1;
        align2 = seq2[j - 1] + align2;
        i--;
        j--;
      } else if (scoreMatrix[i][j] == scoreMatrix[i - 1][j] + gapPenalty) {
        align1 = seq1[i - 1] + align1;
        align2 = '-' + align2;
        i--;
      } else {
        align1 = '-' + align1;
        align2 = seq2[j - 1] + align2;
        j--;
      }
    }

    return 'Alignment 1: $align1\nAlignment 2: $align2\nMax Score: $maxScore';
  }

  void _calculateAlignment() {
    setState(() {
      alignmentResult = smithWaterman(seq1Controller.text, seq2Controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smith-Waterman Alignment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Sequence 1:', style: TextStyle(fontSize: 16)),
            TextField(controller: seq1Controller),
            SizedBox(height: 10),
            Text('Enter Sequence 2:', style: TextStyle(fontSize: 16)),
            TextField(controller: seq2Controller),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAlignment,
              child: Text('Calculate Alignment'),
            ),
            SizedBox(height: 20),
            Text(
              alignmentResult,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
