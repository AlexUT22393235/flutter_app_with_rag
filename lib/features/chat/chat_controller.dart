import 'package:flutter/material.dart';
import '../../core/models.dart';
import 'chat_repository.dart';

class ChatController with ChangeNotifier {
  final ChatRepository _repository;

  ChatController(this._repository);

  // Historial de la conversación
  // Mantenemos el orden: el mensaje más viejo primero.
  final List<Message> _messages = [
    Message(
      content: '¡Hola! Soy tu asistente RAG. ¿En qué puedo ayudarte hoy?',
      sender: SenderType.assistant,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  // Eliminamos el .reversed.toList()
  List<Message> get messages => _messages; 

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  /// Envía el mensaje del usuario al backend RAG y añade la respuesta.
  void sendMessage(String text) async {
    if (text.trim().isEmpty || _isTyping) return;

    // 1. Añadir el mensaje del usuario al FINAL de la lista
    final userMessage = Message(
      content: text,
      sender: SenderType.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage); // <--- CAMBIO CLAVE
    
    // 2. Indicar que el asistente está escribiendo
    _isTyping = true;
    notifyListeners();

    try {
      // 3. Llamada al ChatRepository
      final assistantResponse = await _repository.getRAGResponse(text, []);

      // 4. Añadir la respuesta exitosa del asistente al FINAL de la lista
      final assistantMessage = Message(
        content: assistantResponse,
        sender: SenderType.assistant,
        timestamp: DateTime.now(),
      );
      _messages.add(assistantMessage); // <--- CAMBIO CLAVE

    } catch (e) {
      // 4. Manejo de errores: añadir al FINAL de la lista
      const String friendlyErrorMessage = 
        "El sistema no está disponible. Por favor, asegúrate de que el servidor FastAPI esté corriendo e inténtalo más tarde.";

      final errorMessage = Message(
        content: friendlyErrorMessage,
        sender: SenderType.assistant,
        timestamp: DateTime.now(),
        isError: true,
      );
      _messages.add(errorMessage); // <--- CAMBIO CLAVE
      print('Error al llamar a la API RAG: $e');
    } finally {
      // 5. Finalizar el estado de "escribiendo"
      _isTyping = false;
      notifyListeners();
    }
  }
}