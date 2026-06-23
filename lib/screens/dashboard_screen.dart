import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import '../services/api_service.dart';
import 'reporte_detalle_screen.dart';
import 'notificaciones_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Color _getRiskColor(String risk) {
    if (risk == 'alto') return const Color(0xFFFF4D4D); // Vibrant Red
    if (risk == 'medio') return const Color(0xFFFFB020); // Vibrant Orange
    return const Color(0xFF00E676); // Vibrant Green
  }

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
          'Proctoring',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bellRing, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificacionesScreen()),
              );
            },
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, color: Colors.white54),
          const SizedBox(width: 8),
        ],
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
                          'Hola, Supervisor',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                        const SizedBox(height: 4),
                        Text(
                          'Bienvenido al panel de control.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8), // Slate 400
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                    ).animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Sesiones Recientes',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder(
                    future: Future.wait([
                      ApiService().getReportes(),
                      ApiService().getEntrevistas()
                    ]),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.blueAccent),
                        );
                      }
                      
                      final reportes = (snapshot.data?[0] as List<Reporte>?) ?? [];
                      final entrevistas = (snapshot.data?[1] as List<Entrevista>?) ?? [];

                      if (reportes.isEmpty) {
                        return const Center(
                          child: Text('No hay sesiones recientes', style: TextStyle(color: Colors.white70)),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: reportes.length,
                        itemBuilder: (context, index) {
                          final reporte = reportes[index];
                          final entrevista = entrevistas.firstWhere(
                            (e) => e.id == reporte.entrevistaId,
                            orElse: () => Entrevista(id: 0, titulo: 'Sesión', fecha: '-', candidato: 'Desconocido', avatarUrl: 'https://i.pravatar.cc/150'),
                          );

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 500),
                                    pageBuilder: (context, animation, secondaryAnimation) => 
                                        ReporteDetalleScreen(reporte: reporte, entrevista: entrevista),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF1E293B),
                                      Color(0xFF151E2E),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getRiskColor(reporte.nivelRiesgo).withValues(alpha: 0.1),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundImage: NetworkImage(entrevista.avatarUrl),
                                            backgroundColor: const Color(0xFF334155),
                                          ),
                                          Positioned(
                                            bottom: -2,
                                            right: -2,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _getRiskColor(reporte.nivelRiesgo),
                                                border: Border.all(color: const Color(0xFF1E293B), width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: _getRiskColor(reporte.nivelRiesgo).withValues(alpha: 0.5),
                                                    blurRadius: 8,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                                             .scaleXY(begin: 1.0, end: 1.2, duration: 1.seconds),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Hero(
                                              tag: 'title_${entrevista.id}',
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  entrevista.titulo,
                                                  style: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '${entrevista.candidato} • ${entrevista.fecha}',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF94A3B8), // Slate 400
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(LucideIcons.arrowRight, color: Colors.white70, size: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: (200 + index * 100).ms).slideY(begin: 0.2),
                          );
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
