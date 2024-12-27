import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:cronosalud/controllers/notificaciones_service.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class InterfazmedicamentoScreen extends StatefulWidget {
  final String documentId;

  const InterfazmedicamentoScreen({
    super.key,
    required this.documentId,
  });

  @override
  State<InterfazmedicamentoScreen> createState() =>
      InterfazmedicamentoScreenState();
}

class InterfazmedicamentoScreenState extends State<InterfazmedicamentoScreen> {
  String? userId;
  String? nombreTratamiento;

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

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener los datos del tratamiento
    getTreatmentDetails(widget.documentId); // Aquí pasas el ID del documento
    _initializeFCM();
  }

// Inicializar el servicio de notificaciones
  Future<void> _initializeFCM() async {
    if (userId != null) {
      await NotificationService()
          .init(userId!); // Inicializar el servicio de notificaciones
    }
  }

  Future<void> getTreatmentDetails(String documentId) async {
    try {
      developer.log('Intentando obtener el documento con ID: $documentId');
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('tratamientos')
          .doc(documentId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          developer.log('Datos obtenidos: $data');
          setState(() {
            userId = data['userId'] ?? 'No especificado';
            nombreTratamiento = data['nombre_tratamiento'] ?? 'Sin nombre';
          });

          // Obtener el token del dispositivo
          String? token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            developer.log('Token FCM obtenido: $token');

            // Guardar el token en Firestore
            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(userId)
                .update({'fcmToken': token});
          }
        } else {
          developer.log('El documento existe pero no contiene datos.');
        }
      } else {
        developer.log('No se encontró el documento con ID: $documentId');
      }
    } catch (e) {
      developer.log('Error al obtener los datos: $e');
    }
  }

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

  void _saveSchedule() async {
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
    Map<String, dynamic> scheduleData = {
      'dias': selectedDays.toList(),
      'hora_inicio': startTime?.format(context),
      'hora_fin': endTime?.format(context),
      'userId': userId,
      'nombre_tratamiento': nombreTratamiento,
    };
    try {
      // Guardar el horario en Firestore
      await FirebaseFirestore.instance
          .collection(
              'horarios') // Aquí defines la colección donde se almacenarán los horarios
          .add(scheduleData);
      // Programar notificaciones
      // ignore: unused_local_variable
      for (String day in selectedDays) {
        // Obtener la hora de inicio
        int hour = startTime!.hour;
        int minute = startTime!.minute;
        // Programar la notificación para ese día
        await NotificationService().scheduleRecurringNotification(
          'Hora de medicamento',
          'Es hora de tomar tu medicamento: $nombreTratamiento.',
          hour,
          minute,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Horario guardado con éxito')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el horario: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personalizar Horarios',
          style: TextStyle(fontWeight: FontWeight.bold), // Título en negrita
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Selecciona los días:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              spacing: 8.0,
              children: daysOfWeek.map((day) {
                return ChoiceChip(
                  label: Text(day),
                  selected: selectedDays.contains(day),
                  selectedColor: Colors.blue,
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
            Center(
              child: Text(
                'Selecciona las horas:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _selectTime(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    startTime == null
                        ? 'Hora de inicio'
                        : 'Inicio: ${startTime?.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 16), // Espaciado entre los botones
                TextButton(
                  onPressed: () => _selectTime(context, false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    endTime == null
                        ? 'Hora de fin'
                        : 'Fin: ${endTime?.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Center(
              child: MyLoginButton(
                text: TextApp.savedatossalud, // Texto del botón
                colortext: Colors.black, // Color del texto
                colorbuttonbackground: Colors.lightBlueAccent, // Color de fondo
                onPressed: () {
                  _showConfirmationDialog(
                      context); // Muestra el diálogo de confirmación
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// Función para mostrar el diálogo de confirmación
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar horario'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Días seleccionados: ${selectedDays.join(', ')}'),
                Text('Hora de inicio: ${startTime?.format(context)}'),
                Text('Hora de fin: ${endTime?.format(context)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin guardar
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _saveSchedule(); // Llamar a la función para guardar los horarios
                Navigator.of(context)
                    .pop(); // Cerrar el diálogo después de guardar
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
