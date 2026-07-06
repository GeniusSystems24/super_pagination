import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain and application layers keep inward dependencies', () {
    final violations = <String>[];

    _dartFiles(Directory('lib/shared/domain')).forEach((file) {
      final source = file.readAsStringSync();
      if (source.contains("package:flutter/") ||
          source.contains('/infrastructure/') ||
          source.contains('/presentation/')) {
        violations.add(file.path);
      }
    });

    _dartFiles(Directory('lib/shared/application')).forEach((file) {
      final source = file.readAsStringSync();
      if (source.contains("package:flutter/") ||
          source.contains('/infrastructure/') ||
          source.contains('/presentation/')) {
        violations.add(file.path);
      }
    });

    expect(violations, isEmpty, reason: 'Layer violations: $violations');
  });

  test('non-Firebase presentation does not import infrastructure directly', () {
    final violations = <String>[];

    for (final directory in [
      Directory('lib/features/home/presentation'),
      Directory('lib/features/pagination_examples/presentation'),
      Directory('lib/features/stream_examples/presentation'),
      Directory('lib/features/search_examples/presentation'),
      Directory('lib/features/error_examples/presentation'),
      Directory('lib/shared/presentation'),
    ]) {
      for (final file in _dartFiles(directory)) {
        final source = file.readAsStringSync();
        if (source.contains('/infrastructure/')) {
          violations.add(file.path);
        }
      }
    }

    expect(violations, isEmpty, reason: 'Direct infrastructure imports: $violations');
  });
}

Iterable<File> _dartFiles(Directory directory) sync* {
  if (!directory.existsSync()) return;
  yield* directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
}
