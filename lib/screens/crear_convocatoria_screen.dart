import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../services/api_service.dart';

class CrearConvocatoriaScreen extends StatefulWidget {
  final Prueba prueba;

  const CrearConvocatoriaScreen({super.key, required this.prueba});

  @override
  State<CrearConvocatoriaScreen> createState() => _CrearConvocatoriaScreenState();
}

class _CrearConvocatoriaScreenState extends State<CrearConvocatoriaScreen> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  DateTime? _fechaProgramada;
  final List<Map<String, TextEditingController>> _invitados = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController.text = 'Convocatoria: ${widget.prueba.titulo}';
    _agregarInvitado(); // Al menos un invitado por defecto
  }

  void _agregarInvitado() {
    setState(() {
      _invitados.add({
        'nombre': TextEditingController(),
        'email': TextEditingController(),
      });
    });
  }

  void _eliminarInvitado(int index) {
    setState(() {
      _invitados.removeAt(index);
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
                surface: Color(0xFF1E293B),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _fechaProgramada = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _programar() async {
    if (_tituloController.text.trim().isEmpty) {
      _mostrarError('El título es requerido.');
      return;
    }
    if (_fechaProgramada == null) {
      _mostrarError('Debe seleccionar una fecha y hora.');
      return;
    }

    List<Map<String, String>> invitadosData = [];
    for (var i in _invitados) {
      String nombre = i['nombre']!.text.trim();
      String email = i['email']!.text.trim();
      if (nombre.isEmpty || email.isEmpty) {
        _mostrarError('Todos los invitados deben tener nombre y correo.');
        return;
      }
      invitadosData.add({'nombre': nombre, 'email': email});
    }

    if (invitadosData.isEmpty) {
      _mostrarError('Debe agregar al menos un invitado.');
      return;
    }

    setState(() => _isLoading = true);

    final api = ApiService();
    bool exito = await api.programarEntrevista(
      titulo: _tituloController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      fechaProgramada: _fechaProgramada!.toUtc().toIso8601String(),
      pruebaId: widget.prueba.id,
      invitados: invitadosData,
    );

    setState(() => _isLoading = false);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Convocatoria programada exitosamente')),
      );
      Navigator.pop(context);
    } else {
      _mostrarError('Error al programar convocatoria. Verifique los datos.');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Crear Convocatoria',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Detalles de la Convocatoria'),
                  const SizedBox(height: 16),
                  _buildTextField('Título', _tituloController, LucideIcons.type),
                  const SizedBox(height: 16),
                  _buildTextField('Descripción (Opcional)', _descripcionController, LucideIcons.alignLeft, maxLines: 3),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _seleccionarFecha(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar, color: Color(0xFF64748B), size: 18),
                          const SizedBox(width: 16),
                          Text(
                            _fechaProgramada == null
                                ? 'Seleccionar Fecha y Hora'
                                : DateFormat('dd/MM/yyyy HH:mm').format(_fechaProgramada!),
                            style: GoogleFonts.inter(
                              color: _fechaProgramada == null ? const Color(0xFF94A3B8) : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Candidatos Invitados'),
                      IconButton(
                        onPressed: _agregarInvitado,
                        icon: const Icon(LucideIcons.plusCircle, color: Colors.blueAccent),
                        tooltip: 'Añadir Candidato',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._invitados.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var inv = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Candidato ${idx + 1}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                              if (_invitados.length > 1)
                                IconButton(
                                  icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 18),
                                  onPressed: () => _eliminarInvitado(idx),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildTextField('Nombre Completo', inv['nombre']!, LucideIcons.user),
                          const SizedBox(height: 12),
                          _buildTextField('Correo Electrónico', inv['email']!, LucideIcons.mail, keyboardType: TextInputType.emailAddress),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _programar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Programar Convocatoria',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(color: Colors.white),
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFF64748B)),
          prefixIcon: maxLines == 1 ? Icon(icon, color: const Color(0xFF64748B), size: 18) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
