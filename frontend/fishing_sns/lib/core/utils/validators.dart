class Validators {
  const Validators._();

  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'メールアドレスを入力してください';
    }
    if (!value.contains('@')) {
      return '正しいメールアドレスを入力してください';
    }
    return null;
  }

  static String? validatePassword(String value, {int minLength = 6}) {
    if (value.isEmpty) {
      return 'パスワードを入力してください';
    }
    if (value.length < minLength) {
      return 'パスワードは$minLength文字以上にしてください';
    }
    return null;
  }
}
