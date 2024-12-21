import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cronosalud/models/mensajes_models.dart';
import 'package:cronosalud/controllers/mensaje_controlador.dart';

class EnviarMensajeScreen extends StatefulWidget {
  const EnviarMensajeScreen({super.key});

  @override
  State<EnviarMensajeScreen> createState() => _EnviarMensajeScreenState();
}

class _EnviarMensajeScreenState extends State<EnviarMensajeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mensajeController = TextEditingController();
  final MensajeController _mensajeControllerApi = MensajeController();
  String? _userId;
  bool _isSending = false; // Estado del botón enviar

  @override
  void initState() {
    super.initState();
    _obtenerUserId();
  }

  // Obtener ID del usuario autenticado
  void _obtenerUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No estás autenticado')),
      );
    }
  }

  // Función para enviar el mensaje
  Future<void> _enviarMensaje() async {
    if (_formKey.currentState!.validate() && _userId != null) {
      setState(() {
        _isSending = true; // Bloquea el botón mientras se envía
      });

      final mensaje = Mensaje(
        id: '',
        mensaje: _mensajeController.text.trim(),
        idPaciente: _userId!,
        idMedico: "medico123", // Reemplazar con el ID real del médico
        estado: "pendiente",
        fecha: DateTime.now(),
      );

      try {
        await _mensajeControllerApi.enviarMensaje(mensaje);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mensaje enviado con éxito')),
          );
          _mensajeController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar el mensaje: $e')),
          );
        }
      } finally {
        setState(() {
          _isSending = false; // Reactiva el botón
        });
      }
    }
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Mensaje al Médico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Escribe tu mensaje para el médico:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mensajeController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Describe tu mensaje...",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Por favor, escribe tu mensaje.";
                  }
                  if (value.length < 10) {
                    return "El mensaje debe tener al menos 10 caracteres.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isSending ? null : _enviarMensaje,
                  child: _isSending
                      ? const CircularProgressIndicator()
                      : const Text("Enviar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
