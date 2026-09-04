import 'package:flutter_test/flutter_test.dart';
import 'package:app_flutter_supabase/data/models/app_user.dart';

void main() {
  group('roleFromString', () {
    test('reconnaît "admin"', () {
      expect(roleFromString('admin'), AppRole.admin);
    });

    test('reconnaît "member"', () {
      expect(roleFromString('member'), AppRole.member);
    });

    test('retombe sur "member" pour une valeur inconnue', () {
      expect(roleFromString('inconnu'), AppRole.member);
    });
  });

  group('AppUser.fromMap / toMap', () {
    test('round-trip conserve les champs', () {
      final map = {
        'id': 'abc-123',
        'email': 'test@example.com',
        'full_name': 'Jean Test',
        'role': 'admin',
        'created_at': '2026-01-01T00:00:00.000Z',
      };

      final user = AppUser.fromMap(map);
      expect(user.id, 'abc-123');
      expect(user.role, AppRole.admin);

      final backToMap = user.toMap();
      expect(backToMap['email'], 'test@example.com');
      expect(backToMap['role'], 'admin');
    });
  });
}
