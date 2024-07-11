import 'package:flutter/material.dart';

void main() => runApp(const TemperatureConverterApp());

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TemperatureConverterScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
      ),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  String _selectedConversion = 'F to C';
  TextEditingController _controller = TextEditingController();
  String _result = '';
  List<String> _history = [];
  bool _showHistory = false;
  IconData? _temperatureIcon;
  Color? _temperatureColor;

  void _convert() {
    double inputTemp = double.tryParse(_controller.text) ?? 0.0;
    double convertedTemp;
    String conversionText;

    // To make it more interesting, I used conditional statements to show whether the entered value is either cold, moderate, hot, or blazing hot.
    if (_selectedConversion == 'C to F') {
      if (inputTemp <= 7) {
        _temperatureIcon = Icons.ac_unit;
        _temperatureColor = Colors.blue;
      } else if (inputTemp > 7 && inputTemp <= 37) {
        _temperatureIcon = Icons.thermostat;
        _temperatureColor = Colors.grey;
      } else if (inputTemp > 37 && inputTemp <= 70) {
        _temperatureIcon = Icons.whatshot;
        _temperatureColor = Colors.red;
      } else {
        _temperatureIcon = Icons.whatshot;
        _temperatureColor = Colors.redAccent;
      }

      convertedTemp = inputTemp * 9 / 5 + 32;
      conversionText =
      'C to F: $inputTemp°C → ${convertedTemp.toStringAsFixed(2)}°F';
    } else {
      if (inputTemp <= 45) {
        _temperatureIcon = Icons.ac_unit;
        _temperatureColor = Colors.blue;
      } else if (inputTemp > 45 && inputTemp <= 99) {
        _temperatureIcon = Icons.thermostat;
        _temperatureColor = Colors.grey;
      } else if (inputTemp > 99 && inputTemp <= 158) {
        _temperatureIcon = Icons.whatshot;
        _temperatureColor = Colors.red;
      } else {
        _temperatureIcon = Icons.whatshot;
        _temperatureColor = Colors.redAccent;
      }

      convertedTemp = (inputTemp - 32) * 5 / 9;
      conversionText =
      'F to C: $inputTemp°F → ${convertedTemp.toStringAsFixed(2)}°C';
    }

    setState(() {
      _result = conversionText;
      _history.insert(0, conversionText); // To add every new conversion at the top
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Sadick's Tempo Converter",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedConversion,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedConversion = newValue!;
                    _temperatureIcon = null; // This will reset temperature icon on conversion change
                    _temperatureColor = null; // While this will reset temperature color on conversion change
                  });
                },
                items: <String>['F to C', 'C to F']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Conversion Type',
                  prefixIcon: Icon(Icons.swap_horiz),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Temperature',
                  prefixIcon: Icon(Icons.thermostat),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _convert,
                child: const Text('Convert'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Result: $_result',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16.0),
              if (_temperatureIcon != null && _temperatureColor != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _temperatureIcon,
                      color: _temperatureColor,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Temperature Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _temperatureColor,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  value: _showHistory ? 'Hide History' : 'Show History',
                  onChanged: (String? newValue) {
                    setState(() {
                      _showHistory = !_showHistory;
                    });
                  },
                  items: <String>['Show History', 'Hide History']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.history, color: Colors.white),
                  dropdownColor: Colors.blue,
                ),
              ),
              if (_showHistory) ...[
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.circle, size: 10),
                      title: Text(_history[index]),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
