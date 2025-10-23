import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  // Función para desplazar la lista hacia el FINAL (abajo)
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // <--- CAMBIO CLAVE: Ir al final
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
      // El scroll se activa al cambiar el estado (notifyListeners)
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatController = context.watch<ChatController>();

    // Vuelve a desplazar cada vez que la lista de mensajes cambia
    _scrollToBottom();

    // Calculamos el número total de elementos a mostrar
    int itemCount = chatController.messages.length + (chatController.isTyping ? 1 : 0);

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
              // ELIMINAMOS reverse: true <--- CAMBIO CLAVE
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Si el controlador está escribiendo, el ÚLTIMO elemento es el indicador
                if (chatController.isTyping && index == itemCount - 1) { // <--- CAMBIO CLAVE
                  return const TypingIndicator();
                }
                
                // Si hay un TypingIndicator, el índice del mensaje debe ser ajustado
                if (chatController.isTyping && index >= itemCount - 1) {
                    return Container(); // No renderizar nada si el índice es para el indicador
                }
                
                // Muestra el mensaje
                return MessageBubble(message: chatController.messages[index]);
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