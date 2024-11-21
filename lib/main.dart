import 'package:flutter/material.dart';
import 'homepage.dart'; // Assuming you have the SeqAlignApp defined in homepage.dart
import 'feedbackpage.dart'; // Import your FeedbackPage

String? loggedInUser; // Null means no user is logged in

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Sign Up',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

// A global map to store user credentials temporarily (for demonstration purposes)
Map<String, String> users = {};

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (users.containsKey(email) && users[email] == password) {
      loggedInUser = email; // Set the logged-in user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SeqAlignApp()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid credentials'),
      ));
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  void _guestLogin() {
    loggedInUser = null; // No user is logged in as a guest
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SeqAlignApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: _navigateToSignUp,
              child: const Text("Don't have an account? Sign Up"),
            ),
            TextButton(
              onPressed: _guestLogin,
              child: const Text('Continue as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (users.containsKey(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email already registered'),
      ));
    } else {
      users[email] = password; // Store the new user credentials
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Account created for $email'),
      ));
      Navigator.pop(context); // Go back to the login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
