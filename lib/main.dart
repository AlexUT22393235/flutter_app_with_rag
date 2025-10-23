import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_client.dart';
import 'features/chat/chat_controller.dart';
import 'features/chat/chat_repository.dart';
import 'features/chat/chat_screen.dart';

void main() {
  // Inicialización de las dependencias
  final ApiClient apiClient = ApiClient();
  final ChatRepository chatRepository = ChatRepository(apiClient);

  runApp(RAGChatApp(chatRepository: chatRepository));
}

class RAGChatApp extends StatelessWidget {
  final ChatRepository chatRepository;

  const RAGChatApp({super.key, required this.chatRepository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Proporciona el ChatController con su dependencia (el Repository)
      create: (context) => ChatController(chatRepository),
      child: MaterialApp(
        title: 'RAG Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Use a blue seed color for the app and rely on Material 3 color scheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue.shade700,
            onPrimary: Colors.white,
            error: Colors.red.shade600,
            surface: Colors.grey.shade100,
          ),
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
