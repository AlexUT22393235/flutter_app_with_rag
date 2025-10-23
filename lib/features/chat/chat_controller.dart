import 'package:flutter/material.dart';
import '../../core/models.dart';
import 'chat_repository.dart';

class ChatController with ChangeNotifier {
  final ChatRepository _repository;

  ChatController(this._repository);

  // Historial de la conversación
  final List<Message> _messages = [
    Message(
      content: '¡Hola! Soy tu asistente RAG. ¿En qué puedo ayudarte hoy?',
      sender: SenderType.assistant,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  List<Message> get messages => _messages.reversed.toList();

  bool _isTyping = false;
  bool get isTyping => _isTyping;
  
  // No necesitamos implementar la lógica de "history" de la API por ahora,
  // ya que tu endpoint espera un array vacío ([]). 

  /// Envía el mensaje del usuario al backend RAG y añade la respuesta.
  void sendMessage(String text) async {
    if (text.trim().isEmpty || _isTyping) return;

    // 1. Añadir el mensaje del usuario
    final userMessage = Message(
      content: text,
      sender: SenderType.user,
      timestamp: DateTime.now(),
    );
    _messages.insert(0, userMessage);
    
    // 2. Indicar que el asistente está escribiendo
    _isTyping = true;
    notifyListeners();

    try {
      // 3. Llamada al ChatRepository para el endpoint FastAPI
      final assistantResponse = await _repository.getRAGResponse(text, []);

      // 4. Añadir la respuesta exitosa del asistente
      final assistantMessage = Message(
        content: assistantResponse,
        sender: SenderType.assistant,
        timestamp: DateTime.now(),
      );
      _messages.insert(0, assistantMessage);

    } catch (e) {
      // 4. Manejo de errores: añade un mensaje de error a la conversación
      final errorMessage = Message(
        content: 'Error de Conexión: ${e.toString().replaceAll('Exception: ', '')}',
        sender: SenderType.assistant,
        timestamp: DateTime.now(),
        isError: true, // Usa el flag isError para que la burbuja lo renderice distinto
      );
      _messages.insert(0, errorMessage);
      print('Error en la API: $e');
    } finally {
      // 5. Finalizar el estado de "escribiendo"
      _isTyping = false;
      notifyListeners();
    }
  }
}