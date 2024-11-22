import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final Map<String, dynamic> alignmentResult;

  HistoryPage({required this.alignmentResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alignment History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aligned Sequences:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Sequence 1: ${alignmentResult['alignedSeq1']}"),
            Text("Sequence 2: ${alignmentResult['alignedSeq2']}"),
            SizedBox(height: 20),
            Text(
              "Alignment Score: ${alignmentResult['alignmentScore']}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Score Matrix:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  children: alignmentResult['scoreMatrix']
                      .map<TableRow>((row) => TableRow(
                            children: row
                                .map<Widget>((cell) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(cell.toString(),
                                          textAlign: TextAlign.center),
                                    ))
                                .toList(),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
