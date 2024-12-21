import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/citas_medicas_models.dart';
import 'package:flutter/material.dart';

class ReprogramarCitaScreen extends StatefulWidget {
  final CitasMedicas appointment;

  const ReprogramarCitaScreen({super.key, required this.appointment});

  @override
  State<ReprogramarCitaScreen> createState() => _ReprogramarCitaScreenState();
}

class _ReprogramarCitaScreenState extends State<ReprogramarCitaScreen> {
  DateTime? newAppointmentDate;
  TimeOfDay? newAppointmentTime;

  Future<void> _selectNewDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.appointment.date),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        newAppointmentDate = pickedDate;
      });
    }
  }

  Future<void> _selectNewTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        newAppointmentTime = pickedTime;
      });
    }
  }

  Future<void> _saveReschedule() async {
    if (newAppointmentDate != null && newAppointmentTime != null) {
      final newDateTime = DateTime(
        newAppointmentDate!.year,
        newAppointmentDate!.month,
        newAppointmentDate!.day,
        newAppointmentTime!.hour,
        newAppointmentTime!.minute,
      );

      // Actualizar cita en Firestore
      await FirebaseFirestore.instance
          .collection('citasmedicas')
          .doc(widget.appointment.id)
          .update({
        'date': newDateTime.toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cita reprogramada con éxito')),
        );
        Navigator.pop(context);
      }
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
        title: const Text('Reprogramar Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selectNewDate(context),
              child: const Text('Seleccionar Nueva Fecha'),
            ),
            ElevatedButton(
              onPressed: () => _selectNewTime(context),
              child: const Text('Seleccionar Nueva Hora'),
            ),
            ElevatedButton(
              onPressed: _saveReschedule,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
