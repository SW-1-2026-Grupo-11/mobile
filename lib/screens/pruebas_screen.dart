import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import '../services/api_service.dart';
import 'prueba_detalle_screen.dart';

class PruebasScreen extends StatelessWidget {
  const PruebasScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B101E), Color(0xFF131B2F), Color(0xFF0B101E)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Catálogo de Pruebas',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().slideX(begin: -0.1),
              const SizedBox(height: 8),
              Text(
                'Gestiona tus exámenes y evaluaciones.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF94A3B8),
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
              const SizedBox(height: 24),

              Expanded(
                child: FutureBuilder<List<Prueba>>(
                  future: ApiService().getPruebas(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                    }

                    final pruebas = snapshot.data ?? [];

                    if (pruebas.isEmpty) {
                      return const Center(
                        child: Text('No hay pruebas registradas', style: TextStyle(color: Colors.white70)),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: pruebas.length,
                      itemBuilder: (context, index) {
                        final prueba = pruebas[index];
                        final colorNivel = _getNivelColor(prueba.nivel);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PruebaDetalleScreen(prueba: prueba),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colorNivel.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(LucideIcons.fileText, color: colorNivel),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        prueba.titulo,
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(LucideIcons.clock, size: 14, color: const Color(0xFF64748B)),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${prueba.duracionMinutos} min',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(LucideIcons.tag, size: 14, color: const Color(0xFF64748B)),
                                          const SizedBox(width: 4),
                                          Text(
                                            prueba.area.toUpperCase(),
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(LucideIcons.chevronRight, color: const Color(0xFF64748B)),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: (400 + index * 100).ms).slideY(begin: 0.1);
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
