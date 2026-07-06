import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('architecture boundaries', () {
    test('domain is framework independent', () {
      final files = Directory('lib/src/domain')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));

      for (final file in files) {
        final source = file.readAsStringSync();
        expect(source, isNot(contains('package:flutter')),
            reason: '${file.path} must not depend on Flutter');
        expect(source, isNot(contains('/presentation/')),
            reason: '${file.path} must not depend on Presentation');
      }
    });

    test('application does not depend on presentation or Flutter', () {
      final files = Directory('lib/src/application')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));

      for (final file in files) {
        final source = file.readAsStringSync();
        expect(source, isNot(contains('package:flutter')),
            reason: '${file.path} must not depend on Flutter');
        expect(source, isNot(contains('/presentation/')),
            reason: '${file.path} must not depend on Presentation');
      }
    });

    test('public entry points expose both new and compatibility APIs', () {
      final canonical = File('lib/super_pagination.dart').readAsStringSync();
      final compatibility = File('lib/pagination.dart').readAsStringSync();
      final aliases = File('lib/src/public/super_pagination_aliases.dart')
          .readAsStringSync();

      expect(canonical, contains("export 'src/public/super_pagination_aliases.dart';"));
      expect(compatibility, contains("export 'super_pagination.dart';"));
      expect(aliases, contains('typedef SuperPagination<'));
      expect(aliases, contains('= SuperPagination<T, R>;'));
    });
  });
}
