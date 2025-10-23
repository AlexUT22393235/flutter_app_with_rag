import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Usamos Provider para la gestión de estado
import '../chat/chat_controller.dart';
import './widgets/message_bubble.dart';
import './widgets/input_bar.dart';
import './widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Función para desplazar la lista hacia abajo
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // Cero para el historial invertido (el más reciente está arriba)
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    final controller = context.read<ChatController>();
    if (_textController.text.isNotEmpty) {
      controller.sendMessage(_textController.text);
      _textController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en el controlador
    final chatController = context.watch<ChatController>();

    // Vuelve a desplazar cada vez que la lista de mensajes cambia (para asegurar que se vea el nuevo mensaje)
    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente RAG'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: <Widget>[
          // 1. Historial de Conversación
          Expanded(
            child: ListView.builder(
              reverse: true, // Esto hace que el mensaje más reciente aparezca en la parte inferior de la pantalla.
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: chatController.messages.length + (chatController.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // Si el controlador está escribiendo, el primer elemento (index 0) es el indicador
                if (chatController.isTyping && index == 0) {
                  return const TypingIndicator();
                }
                
                // Muestra el mensaje
                final message = chatController.messages[index - (chatController.isTyping ? 1 : 0)];
                return MessageBubble(message: message);
              },
            ),
          ),
          // 2. Barra de Entrada
          InputBar(
            controller: _textController,
            onSend: _handleSend,
            isLoading: chatController.isTyping,
          ),
        ],
      ),
    );
  }
}