import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_social_app/main.dart';

void main() {
  testWidgets('Weather Social app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherSocialApp());

    expect(find.text('Погода'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
