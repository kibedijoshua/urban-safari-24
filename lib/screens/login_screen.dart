import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed('home');
                  }
                },
              ),
              const SizedBox(height: 32),
              const Text('Welcome Back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Login to access your Aura account', style: TextStyle(color: Color(0xFF94A3B8))),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF94A3B8))),
                  TextButton(
                    onPressed: () => context.pushNamed('signup'),
                    child: const Text('Sign Up', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: const Color(0xFF334155))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR CONTINUE WITH', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                  Expanded(child: Container(height: 1, color: const Color(0xFF334155))),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: Image.network('https://lh3.googleusercontent.com/y1vE1A6rN9A3_s9H67Fm4YcQf2A6M4k8E_C2tXZ2nQp-_kY0XQ6u042g09H4BvY02iX4RzQJ4G7r8Q8r2t0Z8_9r', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, color: Colors.white)),
                  label: const Text('Google', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF334155)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().login(_emailController.text, _passwordController.text);
      if (mounted) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed('home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getFriendlyErrorMessage(e)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().signInWithGoogle();
      if (mounted) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed('home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getFriendlyErrorMessage(e)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getFriendlyErrorMessage(dynamic e) {
    if (e is fb.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found': return 'No user found with this email.';
        case 'wrong-password': return 'Incorrect password. Please try again.';
        case 'invalid-email': return 'The email address is not valid.';
        case 'user-disabled': return 'This account has been disabled.';
        default: return e.message ?? 'An unknown error occurred.';
      }
    }
    return e.toString();
  }
}
