import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import '../services/api_service.dart';

class DashboardReclutadorScreen extends StatelessWidget {
  const DashboardReclutadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: const Color(0xFF0F172A).withValues(alpha: 0.6),
            ),
          ),
        ),
        title: Text(
          'Reclutamiento',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B101E),
              Color(0xFF131B2F),
              Color(0xFF0B101E),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, Reclutador',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                        const SizedBox(height: 4),
                        Text(
                          'Sesiones a futuro y convocatorias.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8), // Slate 400
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                    ).animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Próximas Sesiones',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Entrevista>>(
                    future: ApiService().getEntrevistas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                      }
                      
                      final entrevistas = snapshot.data ?? [];

                      if (entrevistas.isEmpty) {
                        return const Center(
                          child: Text('No hay convocatorias a futuro', style: TextStyle(color: Colors.white70)),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: entrevistas.length,
                        itemBuilder: (context, index) {
                          final entrevista = entrevistas[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF1E293B), Color(0xFF151E2E)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(LucideIcons.calendar, color: Colors.blueAccent),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entrevista.titulo,
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${entrevista.candidato} • ${entrevista.fecha}',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF94A3B8),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(LucideIcons.moreVertical, color: Colors.white70, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: (200 + index * 100).ms).slideY(begin: 0.2);
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
