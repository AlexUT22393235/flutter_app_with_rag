// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_rag_app/main.dart';
import 'package:flutter_rag_app/core/api_client.dart';
import 'package:flutter_rag_app/features/chat/chat_repository.dart';

void main() {
  testWidgets('App builds and shows MaterialApp', (WidgetTester tester) async {
    // Build the app with required dependencies and trigger a frame.
    await tester.pumpWidget(
      RAGChatApp(chatRepository: ChatRepository(ApiClient())),
    );

    // Allow any pending frames to settle.
    await tester.pumpAndSettle();

    // Verify that a MaterialApp is present in the widget tree.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
