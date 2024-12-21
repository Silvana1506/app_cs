import 'package:cronosalud/controllers/citas_medicas_controlador.dart';
import 'package:cronosalud/models/citas_medicas_models.dart';
import 'package:cronosalud/models/reprogramarcitascreen.dart';
import 'package:flutter/material.dart';

class CitasMedicasScreen extends StatelessWidget {
  final String userId;
  final CitasMedicasController _controller = CitasMedicasController();

  CitasMedicasScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas Médicas'),
      ),
      body: FutureBuilder<List<CitasMedicas>>(
        future: _controller.fetchAppointments(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes citas programadas.'));
          }

          final appointments = snapshot.data!;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Icon(
                    appointment.isPast
                        ? Icons.history // Icono para citas pasadas
                        : Icons.upcoming, // Icono para próximas citas
                    color: appointment.isPast ? Colors.red : Colors.green,
                  ),
                  title: Text('Dr. ${appointment.medico}'),
                  subtitle: Text('${appointment.date} - ${appointment.time}'),
                  trailing: appointment.isPast
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReprogramarCitaScreen(
                                  appointment: appointment,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
