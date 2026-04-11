import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  bool isLoading = false;

  // 🔐 ログイン
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // バリデーション
    if (email.isEmpty || password.isEmpty) {
      showMessage('メールとパスワードを入力してください');
      return;
    }

    if (!email.contains('@')) {
      showMessage('正しいメールアドレスを入力してください');
      return;
    }

    setState(() => isLoading = true);

    try {
      await auth.signIn(email, password);
    } catch (e) {
      if (!mounted) return;
      showMessage('ログイン失敗: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // 🆕 新規登録
  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // バリデーション
    if (email.isEmpty || password.isEmpty) {
      showMessage('メールとパスワードを入力してください');
      return;
    }

    if (!email.contains('@')) {
      showMessage('正しいメールアドレスを入力してください');
      return;
    }

    if (password.length < 6) {
      showMessage('パスワードは6文字以上にしてください');
      return;
    }

    setState(() => isLoading = true);

    try {
      await auth.signUp(email, password);
    } catch (e) {
      if (!mounted) return;
      showMessage('登録失敗: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // 🔔 メッセージ表示
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