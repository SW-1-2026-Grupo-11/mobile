import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import 'crear_convocatoria_screen.dart';

class PruebaDetalleScreen extends StatelessWidget {
  final Prueba prueba;

  const PruebaDetalleScreen({super.key, required this.prueba});

  Color _getNivelColor(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'basico':
        return const Color(0xFF00E676);
      case 'intermedio':
        return const Color(0xFFFFB020);
      case 'avanzado':
        return const Color(0xFFFF4D4D);
      default:
        return Colors.blueAccent;
    }
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorNivel = _getNivelColor(prueba.nivel);

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
          'Detalle de Prueba',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorNivel.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorNivel.withValues(alpha: 0.3)),
              ),
              child: Text(
                prueba.nivel.toUpperCase(),
                style: GoogleFonts.inter(
                  color: colorNivel,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 16),
            Text(
              prueba.titulo,
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard('ÁREA', prueba.area.toUpperCase(), LucideIcons.layers, Colors.blueAccent),
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard('DURACIÓN', '${prueba.duracionMinutos} min', LucideIcons.clock, Colors.orangeAccent),
                ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard('FORMATO', prueba.tipo.toUpperCase(), LucideIcons.fileCode, Colors.purpleAccent),
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard('PUNTAJE', '${prueba.puntajeMaximo} pts', LucideIcons.award, Colors.greenAccent),
                ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Descripción',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 12),
            Text(
              prueba.descripcion.isNotEmpty ? prueba.descripcion : 'Esta prueba no tiene una descripción detallada.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFF94A3B8),
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 700.ms),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CrearConvocatoriaScreen(prueba: prueba),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.plus, color: Colors.white),
                label: Text(
                  'Crear Convocatoria',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }
}
