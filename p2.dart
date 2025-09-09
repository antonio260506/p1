import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FrmVehiculo(), // Aquí arranca nuestro formulario
    );
  }
}

class FrmVehiculo extends StatefulWidget {
  const FrmVehiculo({super.key});

  @override
  State<FrmVehiculo> createState() => _FrmVehiculoState();
}

class _FrmVehiculoState extends State<FrmVehiculo> {
  final _formKey = GlobalKey<FormState>();

  final _txtPlaca = TextEditingController();
  final _txtMarca = TextEditingController();
  final _txtModelo = TextEditingController();
  final _txtColor = TextEditingController();
  final _txtPropietario = TextEditingController();

  final _soloLetras = RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$');
  final _soloPlaca = RegExp(r'^[A-Z]{3}[0-9]{3}$'); // ej: ABC123

  String? _tipoSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Vehículos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Placa
                TextFormField(
                  controller: _txtPlaca,
                  decoration: const InputDecoration(
                    labelText: "Placa",
                    hintText: "Ej: ABC123",
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "La placa es obligatoria";
                    }
                    if (!_soloPlaca.hasMatch(value)) {
                      return "Formato de placa inválido (ABC123)";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Marca
                TextFormField(
                  controller: _txtMarca,
                  decoration: const InputDecoration(
                    labelText: "Marca",
                    prefixIcon: Icon(Icons.directions_car),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(_soloLetras),
                  ],
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "La marca es obligatoria"
                              : null,
                ),
                const SizedBox(height: 12),

                // Modelo
                TextFormField(
                  controller: _txtModelo,
                  decoration: const InputDecoration(
                    labelText: "Modelo (año)",
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "El modelo es obligatorio";
                    }
                    final anio = int.tryParse(value);
                    if (anio == null ||
                        anio < 1900 ||
                        anio > DateTime.now().year) {
                      return "Ingrese un año válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Color
                TextFormField(
                  controller: _txtColor,
                  decoration: const InputDecoration(
                    labelText: "Color",
                    prefixIcon: Icon(Icons.color_lens),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(_soloLetras),
                  ],
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "El color es obligatorio"
                              : null,
                ),
                const SizedBox(height: 12),

                // Tipo de vehículo
                DropdownButtonFormField<String>(
                  value: _tipoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de vehículo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Automóvil",
                      child: Text("Automóvil"),
                    ),
                    DropdownMenuItem(
                      value: "Motocicleta",
                      child: Text("Motocicleta"),
                    ),
                    DropdownMenuItem(
                      value: "Camioneta",
                      child: Text("Camioneta"),
                    ),
                    DropdownMenuItem(value: "Bus", child: Text("Bus")),
                  ],
                  onChanged:
                      (value) => setState(() => _tipoSeleccionado = value),
                  validator:
                      (value) =>
                          value == null
                              ? "Seleccione un tipo de vehículo"
                              : null,
                ),
                const SizedBox(height: 12),

                // Propietario
                TextFormField(
                  controller: _txtPropietario,
                  decoration: const InputDecoration(
                    labelText: "Propietario",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(_soloLetras),
                  ],
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "El propietario es obligatorio"
                              : null,
                ),
                const SizedBox(height: 20),

                // Botón Guardar
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    final esValido = _formKey.currentState!.validate();
                    if (!esValido) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vehículo registrado")),
                    );

                    _txtPlaca.clear();
                    _txtMarca.clear();
                    _txtModelo.clear();
                    _txtColor.clear();
                    _txtPropietario.clear();
                    setState(() => _tipoSeleccionado = null);
                  },
                  label: const Text("Guardar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
