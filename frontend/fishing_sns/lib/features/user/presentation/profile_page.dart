import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../auth/data/auth_repository.dart';
import '../data/user_repository.dart';
import '../domain/user.dart';

class ProfilePage extends StatefulWidget {
  final bool requireNameOnOpen;

  const ProfilePage({
    super.key,
    this.requireNameOnOpen = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authRepository = AuthRepository();
  final userRepository = UserRepository();
  final nameController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final currentUser = authRepository.currentUser;
    if (currentUser == null) {
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    email = currentUser.email ?? '';
    final profile = await userRepository.fetchUser(currentUser.uid);
    if (profile != null) {
      nameController.text = profile.name;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final currentUser = authRepository.currentUser;
    if (currentUser == null) return;

    final name = nameController.text.trim();
    final nameError = Validators.validateName(name);
    if (nameError != null) {
      _showMessage(nameError);
      return;
    }

    setState(() => isSaving = true);
    try {
      await userRepository.upsertUser(
        AppUser(
          id: currentUser.uid,
          email: currentUser.email ?? email,
          name: name,
        ),
      );
      if (!mounted) return;
      _showMessage('プロフィールを保存しました');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showMessage('プロフィール保存に失敗しました: $e');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.requireNameOnOpen,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィール'),
          automaticallyImplyLeading: !widget.requireNameOnOpen,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.requireNameOnOpen)
                      const Text(
                        '名前が未設定です。入力してください。',
                        style: TextStyle(color: Colors.red),
                      ),
                    if (widget.requireNameOnOpen) const SizedBox(height: 12),
                    Text('メール: $email'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: '名前（1〜20文字）',
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isSaving) const CircularProgressIndicator(),
                    if (!isSaving)
                      ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('保存'),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
