import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '130288048694-j4bh8dbirlc7eo5hb9q81kg4l5a5hbvd.apps.googleusercontent.com' : null,
  );
  
  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool get loading => _loading;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.email == 'menhyajoshua@gmail.com';

  AuthProvider() {
    _auth.authStateChanges().listen((fb.User? fbUser) {
      if (fbUser != null) {
        _user = User(
          id: fbUser.uid,
          name: fbUser.displayName ?? 'User',
          email: fbUser.email ?? '',
          phoneNumber: fbUser.phoneNumber, // phoneNumber is now optional
          photoUrl: fbUser.photoURL,
        );
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String name, String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      fb.UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.updateDisplayName(name);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _loading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await _auth.signInWithCredential(credential);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();
  }
}
