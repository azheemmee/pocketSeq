import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  String _email = '';
  String _feedback = '';

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _feedback = _feedbackController.text;
      });

      // Perform additional actions here (e.g., send feedback to a server)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thank You!'),
          content: Text('Your feedback has been submitted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );

      _formKey.currentState!.reset();
      _feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We value your feedback!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _email = value;
                },
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Feedback cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  child: Text('Submit Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
