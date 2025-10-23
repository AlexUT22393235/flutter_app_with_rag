import 'package:flutter/material.dart';
import '../../../core/models.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Determina si el mensaje es del usuario para la alineación y el color
    final isUser = message.sender == SenderType.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Row(
        // Alinea a la derecha si es usuario, a la izquierda si es asistente
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75, // Limita el ancho
            ),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              // Color de fondo
              color: isUser
                  ? Theme.of(context).colorScheme.primary
                  : (message.isError ? Colors.red.shade600 : Theme.of(context).colorScheme.surfaceVariant),
              // Bordes redondeados
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: isUser 
                        ? Theme.of(context).colorScheme.onPrimary // Texto blanco/claro
                        : Theme.of(context).colorScheme.onSurfaceVariant, // Texto oscuro
                  ),
                ),
                const SizedBox(height: 4),
                // Opcional: Mostrar la hora
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser 
                        ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                        : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}