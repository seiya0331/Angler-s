import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../data/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authRepository = AuthRepository();

  bool isLoading = false;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      showMessage(emailError);
      return;
    }

    final passwordError = Validators.validatePassword(password, minLength: 1);
    if (passwordError != null) {
      showMessage(passwordError);
      return;
    }

    setState(() => isLoading = true);

    try {
      await authRepository.signIn(email, password);
    } catch (e) {
      if (!mounted) return;
      showMessage('ログイン失敗: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      showMessage(emailError);
      return;
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      showMessage(passwordError);
      return;
    }

    setState(() => isLoading = true);

    try {
      await authRepository.signUp(email, password);
    } catch (e) {
      if (!mounted) return;
      showMessage('登録失敗: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'メール'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading) ...[
              ElevatedButton(
                onPressed: login,
                child: const Text('ログイン'),
              ),
              ElevatedButton(
                onPressed: register,
                child: const Text('新規登録'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
