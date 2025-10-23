// --- Modelos de la Aplicación ---

enum SenderType { user, assistant }

class Message {
  final String content;
  final SenderType sender;
  final DateTime timestamp;
  final bool isError;

  Message({
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isError = false,
  });
}

// --- Modelos para la API RAG (Request y Response) ---

/// Estructura de la solicitud enviada a la API (Ej: {"message": "...", "history": []})
class RAGRequest {
  final String message;
  final List<List<String>> history; // El history vacío es un List<List<String>>

  RAGRequest({required this.message, this.history = const []});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'history': history,
    };
  }
}

/// Estructura de la respuesta recibida de la API (Ej: {"answer": "..."})
class RAGResponse {
  final String answer;

  RAGResponse({required this.answer});

  factory RAGResponse.fromJson(Map<String, dynamic> json) {
    return RAGResponse(
      answer: json['answer'] as String? ?? 'Error: Respuesta inesperada del servidor.',
    );
  }
}