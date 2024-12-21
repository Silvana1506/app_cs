import 'package:flutter/material.dart';
import 'package:cronosalud/controllers/mensaje_controlador.dart';
import 'package:cronosalud/models/mensajes_models.dart';
import 'package:cronosalud/views/dashboard/respondermensajes.dart';

//Muestra la lista de mensajes pendientes y permite responder a cada uno
class BandejaEntradaScreen extends StatefulWidget {
  final String medicoId;

  const BandejaEntradaScreen({super.key, required this.medicoId});

  @override
  State<BandejaEntradaScreen> createState() => _BandejaEntradaScreenState();
}

class _BandejaEntradaScreenState extends State<BandejaEntradaScreen> {
  final MensajeController _controller = MensajeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bandeja de Entrada")),
      body: StreamBuilder<List<Mensaje>>(
        stream: _controller.obtenerMensajesPendientes(widget.medicoId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mensajes = snapshot.data!;
          if (mensajes.isEmpty) {
            return const Center(child: Text("No hay mensajes pendientes"));
          }

          return ListView.builder(
            itemCount: mensajes.length,
            itemBuilder: (context, index) {
              final mensaje = mensajes[index];
              return ListTile(
                title: Text(mensaje.mensaje),
                subtitle: Text("Paciente ID: ${mensaje.idPaciente}"),
                trailing: IconButton(
                  icon: const Icon(Icons.reply),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResponderMensajeScreen(
                          mensaje: mensaje,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
