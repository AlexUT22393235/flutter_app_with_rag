import 'package:dio/dio.dart';
import 'models.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8000'; 
  
  // ... (código anterior)

  /// Llama al endpoint RAG para obtener una respuesta.
  Future<RAGResponse> sendRAGQuery(RAGRequest request) async {
    const String endpoint = '/chat';
    
    try {
      final response = await _dio.post(
        '$_baseUrl$endpoint',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return RAGResponse.fromJson(response.data);
      } else {
        // En lugar de lanzar DioException, lanzamos una excepción genérica
        throw Exception('El servidor respondió con código ${response.statusCode}.');
      }
    } on DioException {
       // Esto atrapa problemas de red, timeouts, y fallas de DNS/conexión.
       // Lanzamos una excepción simple para un manejo uniforme en el controlador.
       throw Exception('Fallo en la conexión de red. Verifica la URL y el servidor.');
    } catch (e) {
      // Atrapa cualquier otro error, como un error en el mapeo JSON.
      throw Exception('Ocurrió un error inesperado al procesar la respuesta.');
    }
  }
}