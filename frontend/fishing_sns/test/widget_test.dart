// Basic tests for fishing_sns (template counter test removed — app uses FishingSnsApp + Firebase).

import 'package:flutter_test/flutter_test.dart';

import 'package:fishing_sns/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateEmail rejects empty', () {
      expect(Validators.validateEmail(''), isNotNull);
    });

    test('validateEmail accepts simple email', () {
      expect(Validators.validateEmail('a@b.com'), isNull);
    });

    test('validatePassword enforces min length', () {
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('123456'), isNull);
    });

    test('validateName enforces 1 to 20 chars', () {
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName('a'), isNull);
      expect(Validators.validateName('abcdefghijklmnopqrstu'), isNotNull);
    });
  });
}
