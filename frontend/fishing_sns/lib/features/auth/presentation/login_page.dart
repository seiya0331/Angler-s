import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../user/presentation/profile_page.dart';
import '../data/auth_repository.dart';
import '../../user/data/user_repository.dart';
import '../../user/domain/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authRepository = AuthRepository();
  final userRepository = UserRepository();

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
      final user = authRepository.currentUser;
      if (user != null) {
        final profile = await userRepository.fetchUser(user.uid);
        final hasValidName = profile != null &&
            Validators.validateName(profile.name.trim()) == null;
        if (!hasValidName && mounted) {
          showMessage('名前が未設定です。入力してください。');
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(requireNameOnOpen: true),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      showMessage('ログイン失敗: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final nameError = Validators.validateName(name);
    if (nameError != null) {
      showMessage(nameError);
      return;
    }

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
      final user = authRepository.currentUser;
      if (user != null) {
        await userRepository.upsertUser(
          AppUser(id: user.uid, email: user.email ?? email, name: name),
        );
      }
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
    nameController.dispose();
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
              controller: nameController,
              decoration: const InputDecoration(labelText: '名前（1〜20文字）'),
              maxLength: 20,
            ),
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
