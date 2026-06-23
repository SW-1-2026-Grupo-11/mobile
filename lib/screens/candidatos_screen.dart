import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import '../services/api_service.dart';

class CandidatosScreen extends StatelessWidget {
  const CandidatosScreen({super.key});

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
                'Directorio de Candidatos',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().slideX(begin: -0.1),
              const SizedBox(height: 8),
              Text(
                'Gestiona a los postulantes y su historial.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF94A3B8),
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
              const SizedBox(height: 24),
              
              // Barra de Búsqueda
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: TextField(
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    icon: const Icon(LucideIcons.search, color: Color(0xFF94A3B8)),
                    hintText: 'Buscar candidato...',
                    hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                    border: InputBorder.none,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
              const SizedBox(height: 24),

              Expanded(
                child: FutureBuilder<List<Entrevista>>(
                  future: ApiService().getEntrevistas(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                    }

                    final candidatos = snapshot.data ?? [];

                    if (candidatos.isEmpty) {
                      return const Center(
                        child: Text('No hay candidatos registrados', style: TextStyle(color: Colors.white70)),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: candidatos.length,
                      itemBuilder: (context, index) {
                        final candidato = candidatos[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundImage: NetworkImage(candidato.avatarUrl),
                                backgroundColor: const Color(0xFF334155),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      candidato.candidato,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(LucideIcons.briefcase, size: 14, color: Color(0xFF64748B)),
                                        const SizedBox(width: 6),
                                        Text(
                                          candidato.titulo,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: const Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(LucideIcons.moreVertical, color: Color(0xFF64748B)),
                                onPressed: () {},
                              ),
                            ],
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
