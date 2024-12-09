import 'package:flutter/material.dart';

class InterfazcitasScreen extends StatefulWidget {
  const InterfazcitasScreen({super.key});

  @override
  State<InterfazcitasScreen> createState() => _InterfazcitasScreenState();
}

class _InterfazcitasScreenState extends State<InterfazcitasScreen> {
  // Datos simulados de la cita actual
  DateTime currentAppointmentDate =
      DateTime(2024, 12, 10, 14, 30); // Fecha y hora actuales
  String doctorName = "Dr. Ana Pérez";
  String appointmentReason = "Consulta general";

  // Nuevas fechas y horas seleccionadas
  DateTime? newAppointmentDate;
  TimeOfDay? newAppointmentTime;

  // Función para seleccionar una nueva fecha
  Future<void> _selectNewDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentAppointmentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        newAppointmentDate = pickedDate;
      });
    }
  }

  // Función para seleccionar una nueva hora
  Future<void> _selectNewTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentAppointmentDate),
    );

    if (pickedTime != null) {
      setState(() {
        newAppointmentTime = pickedTime;
      });
    }
  }

  // Guardar la nueva fecha y hora
  void _saveReschedule() {
    if (newAppointmentDate != null && newAppointmentTime != null) {
      DateTime newDateTime = DateTime(
        newAppointmentDate!.year,
        newAppointmentDate!.month,
        newAppointmentDate!.day,
        newAppointmentTime!.hour,
        newAppointmentTime!.minute,
      );

      setState(() {
        currentAppointmentDate = newDateTime;
        newAppointmentDate = null;
        newAppointmentTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cita reprogramada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona nueva fecha y hora')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles de la Cita:',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(
                'Fecha: ${currentAppointmentDate.toLocal().toString().split(' ')[0]}'),
            Text(
                'Hora: ${TimeOfDay.fromDateTime(currentAppointmentDate).format(context)}'),
            Text('Médico: $doctorName'),
            Text('Motivo: $appointmentReason'),
            const SizedBox(height: 20),
            Text('Reprogramar Cita:',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectNewDate(context),
                  child: Text(
                    newAppointmentDate == null
                        ? 'Seleccionar Fecha'
                        : 'Fecha: ${newAppointmentDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectNewTime(context),
                  child: Text(
                    newAppointmentTime == null
                        ? 'Seleccionar Hora'
                        : 'Hora: ${newAppointmentTime!.format(context)}',
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveReschedule,
                  child: const Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      newAppointmentDate = null;
                      newAppointmentTime = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
