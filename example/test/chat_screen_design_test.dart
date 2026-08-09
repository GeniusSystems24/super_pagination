import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final sourceFile = File(
    'lib/features/pagination_examples/presentation/pages/chat_screen.dart',
  );

  test('chat example is backed by the shared design system', () {
    final source = sourceFile.readAsStringSync();

    expect(source, contains("package:super_core/super_core.dart"));
    expect(source, contains('SuperThemeData.of(context)'));
    expect(source, contains('context.superTextTheme.heading'));
    expect(source, contains('SuperSectionCard('));
    expect(source, contains('t.tintFill('));
  });

  test('chat example no longer uses the previous WhatsApp palette', () {
    final source = sourceFile.readAsStringSync();

    expect(source, isNot(contains('0xFF0B141A')));
    expect(source, isNot(contains('0xFFECE5DD')));
    expect(source, isNot(contains('0xFF005C4B')));
    expect(source, isNot(contains('0xFFD9FDD3')));
    expect(source, isNot(contains('0xFF202C33')));
    expect(source, isNot(contains('Colors.teal')));
    expect(source, isNot(contains('Colors.grey')));
  });

  test('chat controller cancels simulated activity timers on dispose', () {
    final source = sourceFile.readAsStringSync();

    expect(source, contains('final Set<Timer> _timers'));
    expect(source, contains('timer.cancel()'));
    expect(source, contains('_timers.clear()'));
  });
}
