import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class InterfazmedicamentoScreen extends StatefulWidget {
  const InterfazmedicamentoScreen({super.key});

  @override
  State<InterfazmedicamentoScreen> createState() =>
      InterfazmedicamentoScreenState();
}

class InterfazmedicamentoScreenState extends State<InterfazmedicamentoScreen> {
  List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];
  Set<String> selectedDays = {}; // Días seleccionados
  TimeOfDay? startTime; // Hora de inicio
  TimeOfDay? endTime; // Hora de fin

  // Función para abrir el TimePicker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  void _saveSchedule() {
    if (selectedDays.isEmpty || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Validar que la hora de inicio sea anterior a la hora de fin
    if (startTime!.hour > endTime!.hour ||
        (startTime!.hour == endTime!.hour &&
            startTime!.minute >= endTime!.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('La hora de inicio debe ser anterior a la hora de fin')),
      );
      return;
    }

    // Lógica para guardar los horarios
    developer.log('Días seleccionados: $selectedDays');
    developer.log('Hora de inicio: ${startTime?.format(context)}');
    developer.log('Hora de fin: ${endTime?.format(context)}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Horario guardado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalizar Horarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona los días:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: daysOfWeek.map((day) {
                return ChoiceChip(
                  label: Text(day),
                  selected: selectedDays.contains(day),
                  onSelected: (isSelected) {
                    setState(() {
                      isSelected
                          ? selectedDays.add(day)
                          : selectedDays.remove(day);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Selecciona las horas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _selectTime(context, true),
                  child: Text(
                    startTime == null
                        ? 'Hora de inicio'
                        : 'Inicio: ${startTime?.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectTime(context, false),
                  child: Text(
                    endTime == null
                        ? 'Hora de fin'
                        : 'Fin: ${endTime?.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveSchedule,
                child: Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
