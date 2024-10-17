import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'avatar_select_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if user is signed in
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateUI(currentUser);
      });
    }
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Sign in success, update UI with the signed-in user's information
      User? user = userCredential.user;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateUI(user);
      });
    } catch (e) {
      // If sign in fails, display a message to the user.
      print('signInWithEmail:failure: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed.')),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateUI(null);
      });
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signed out successfully.')),
    );
  }

  void _updateUI(User? user) {
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AvatarSelectPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In with Email/Password'),
            ),
          ],
        ),
      ),
    );
  }
}
