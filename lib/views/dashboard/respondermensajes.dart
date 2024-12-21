import 'package:flutter/material.dart';
import 'package:cronosalud/controllers/mensaje_controlador.dart';
import 'package:cronosalud/models/mensajes_models.dart';

class ResponderMensajeScreen extends StatefulWidget {
  final Mensaje mensaje;

  const ResponderMensajeScreen({super.key, required this.mensaje});

  @override
  State<ResponderMensajeScreen> createState() => _ResponderMensajeScreenState();
}

class _ResponderMensajeScreenState extends State<ResponderMensajeScreen> {
  final _respuestaController = TextEditingController();
  final MensajeController _controller = MensajeController();

  @override
  void dispose() {
    _respuestaController.dispose();
    super.dispose();
  }

  Future<void> _enviarRespuesta() async {
    if (_respuestaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La respuesta no puede estar vacía")),
      );
      return;
    }

    try {
      await _controller.enviarRespuesta(
        widget.mensaje.id,
        _respuestaController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Respuesta enviada correctamente")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al enviar respuesta: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Responder Mensaje")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Consulta del paciente:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(widget.mensaje.mensaje),
            const SizedBox(height: 20),
            TextFormField(
              controller: _respuestaController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Escribe tu respuesta...",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _enviarRespuesta,
                child: const Text("Enviar Respuesta"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
