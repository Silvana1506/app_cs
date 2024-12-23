import 'package:cronosalud/controllers/datos_historicos_controlador.dart';
import 'package:cronosalud/models/modelo_datos_salud.dart';
import 'package:cronosalud/widgets/buttons/my_back_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class HistoricalDataScreen extends StatefulWidget {
  final String userId;

  const HistoricalDataScreen({super.key, required this.userId});

  @override
  State<HistoricalDataScreen> createState() => _HistoricalDataScreenState();
}

class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
  final HealthDataController _controller = HealthDataController();
  List<HealthData> _historicalData = [];
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchHistoricalData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imagen4.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContainerShape01(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.15),
                    const Text(
                      "Datos Históricos",
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Date filter
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'Desde: ${_startDate.toLocal()}'.split(' ')[0],
                            style: TextStyle(fontSize: 28),
                          ),
                          IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _startDate = selectedDate;
                                });
                                _fetchHistoricalData();
                              }
                            },
                          ),
                          Text(
                            'Hasta: ${_endDate.toLocal()}'.split(' ')[0],
                            style: TextStyle(fontSize: 28),
                          ),
                          IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _endDate = selectedDate;
                                });
                                _fetchHistoricalData();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Show table of historical data if available
                    if (_historicalData.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: {
                            0: FixedColumnWidth(100),
                            1: FixedColumnWidth(80),
                            2: FixedColumnWidth(80),
                            3: FixedColumnWidth(80),
                          },
                          children: [
                            // Table header
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Fecha',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Glucosa',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Peso',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Presión',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Data rows
                            ..._historicalData.map((data) {
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Set background color to white
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data.fecha
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data.glucosa.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data.peso.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data.presion.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            }), //toList(),
                          ],
                        ),
                      ),
                    if (_historicalData.isEmpty)
                      const Center(child: Text('No hay datos para mostrar')),
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.01,
              left: 0.01,
              child: MyBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  // Fetch historical data based on selected date range
  Future<void> _fetchHistoricalData() async {
    if (_startDate.isAfter(_endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'La fecha de inicio no puede ser posterior a la fecha de fin.')),
      );
      return;
    }
    try {
      developer.log(
          'Fetching data from ${_startDate.toLocal()} to ${_endDate.toLocal()}');
      List<HealthData> data = await _controller.getHistoricalData(
        widget.userId,
        _startDate,
        _endDate,
      );
      developer.log('Fetched ${data.length} records');
      setState(() {
        _historicalData = data;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
