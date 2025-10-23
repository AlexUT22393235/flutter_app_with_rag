import 'package:dio/dio.dart';
import 'models.dart';

class ApiClient {
  final Dio _dio = Dio();
  // URL base de tu API FastAPI
  final String _baseUrl = 'http://localhost:8000'; 
  
  // Puedes cambiar el localhost por tu IP si estás probando en un dispositivo físico
  // Por ejemplo: final String _baseUrl = 'http://192.168.1.10:8000';

  /// Llama al endpoint RAG para obtener una respuesta.
  Future<RAGResponse> sendRAGQuery(RAGRequest request) async {
    const String endpoint = '/chat';
    
    try {
      final response = await _dio.post(
        '$_baseUrl$endpoint',
        data: request.toJson(),
        options: Options(
          // Establece el tipo de contenido como JSON
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // La API debe retornar un código 200 (OK)
      if (response.statusCode == 200) {
        // Mapea la respuesta JSON a nuestro modelo RAGResponse
        return RAGResponse.fromJson(response.data);
      } else {
        // Manejo de códigos de estado HTTP no exitosos
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Error de servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Manejo de errores de red, timeouts, etc.
      String errorMessage = 'Fallo en la conexión: ';
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        errorMessage += 'Tiempo de espera agotado. Asegúrate de que FastAPI esté corriendo.';
      } else if (e.type == DioExceptionType.badResponse && e.response != null) {
         errorMessage += 'Código de estado: ${e.response?.statusCode}.';
      } else {
         errorMessage += 'Asegúrate de que la URL es accesible. Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }
}