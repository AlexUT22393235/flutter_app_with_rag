import '../../core/api_client.dart';
import '../../core/models.dart';

class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository(this._apiClient);

  /// Envía la pregunta al backend RAG y retorna la respuesta generada.
  Future<String> getRAGResponse(String message, List<List<String>> history) async {
    try {
      final request = RAGRequest(message: message, history: history);
      final response = await _apiClient.sendRAGQuery(request);
      
      return response.answer;
    } catch (e) {
      // Propaga el error para que el Controller lo maneje
      rethrow;
    }
  }
}