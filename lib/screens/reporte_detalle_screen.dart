import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models.dart';

class ReporteDetalleScreen extends StatelessWidget {
  final Reporte reporte;
  final Entrevista entrevista;

  const ReporteDetalleScreen({
    super.key,
    required this.reporte,
    required this.entrevista,
  });

  Color _getRiskColor(String risk) {
    if (risk == 'alto') return const Color(0xFFFF4D4D);
    if (risk == 'medio') return const Color(0xFFFFB020);
    return const Color(0xFF00E676);
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor(reporte.nivelRiesgo);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: const Color(0xFF0F172A).withValues(alpha: 0.6),
            ),
          ),
        ),
        title: Text(
          'Detalle del Reporte',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B101E),
              Color(0xFF131B2F),
              Color(0xFF0B101E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(entrevista.avatarUrl),
                                backgroundColor: const Color(0xFF334155),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entrevista.candidato,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: riskColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: riskColor.withValues(alpha: 0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: riskColor.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.alertTriangle,
                              color: riskColor, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            reporte.nivelRiesgo.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: riskColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
                  ],
                ),
                const SizedBox(height: 40),

                // Gráficos de Puntaje
                Text(
                  'Análisis de Rendimiento',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 20),
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05)),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.round()}%',
                              GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final style = GoogleFonts.outfit(
                                color: const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              );
                              String text;
                              switch (value.toInt()) {
                                case 0:
                                  text = 'Atención';
                                  break;
                                case 1:
                                  text = 'Sospecha';
                                  break;
                                default:
                                  text = '';
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(text, style: style),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white.withValues(alpha: 0.05),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: reporte.puntajeAtencion.toDouble(),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF00E676),
                                  const Color(0xFF00E676).withValues(alpha: 0.5)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              width: 35,
                              borderRadius: BorderRadius.circular(8),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 100,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: reporte.puntajeSospecha.toDouble(),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF4D4D),
                                  const Color(0xFFFF4D4D).withValues(alpha: 0.5)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              width: 35,
                              borderRadius: BorderRadius.circular(8),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 100,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                ),
                const SizedBox(height: 40),

                // Resumen de IA
                Row(
                  children: [
                    const Icon(LucideIcons.bot, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Resumen General',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.blueAccent.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.05),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Text(
                    reporte.resumenGeneral,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFE2E8F0),
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),
                const SizedBox(height: 40),

                // Recomendaciones
                Row(
                  children: [
                    const Icon(LucideIcons.checkCircle,
                        color: Color(0xFF00E676)),
                    const SizedBox(width: 8),
                    Text(
                      'Acciones Recomendadas',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 16),
                ...List.generate(reporte.recomendaciones.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4, right: 12),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.arrowRight,
                              size: 12, color: Color(0xFF00E676)),
                        ),
                        Expanded(
                          child: Text(
                            reporte.recomendaciones[index],
                            style: GoogleFonts.inter(
                              color: const Color(0xFFCBD5E1),
                              height: 1.5,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (900 + index * 150).ms).slideX(begin: 0.1);
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
