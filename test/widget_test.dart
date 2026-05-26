import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libri_stack/main.dart';
import 'package:libri_stack/core/providers/core_providers.dart';

void main() {
  testWidgets('LibriStack smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const LibriStackApp(),
      ),
    );

    // Verify login screen/title is found
    expect(find.text('LibriStack'), findsOneWidget);
  });
}
