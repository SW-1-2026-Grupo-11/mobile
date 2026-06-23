import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'editar_perfil_screen.dart';
import 'notificaciones_screen.dart';
import 'seguridad_screen.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  Widget _buildSettingsTile(IconData icon, String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDestructive ? Colors.redAccent.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDestructive ? Colors.redAccent.withValues(alpha: 0.1) : Colors.blueAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDestructive ? Colors.redAccent : Colors.blueAccent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.redAccent : Colors.white,
              ),
            ),
          ),
          Icon(LucideIcons.chevronRight, color: isDestructive ? Colors.redAccent.withValues(alpha: 0.5) : const Color(0xFF64748B)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B101E), Color(0xFF131B2F), Color(0xFF0B101E)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Profile Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.camera, color: Colors.white, size: 16),
                        ),
                      ],
                    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 16),
                    Text(
                      '${ApiService.userFirstName ?? ''} ${ApiService.userLastName ?? ''}'.trim().isEmpty 
                          ? 'Usuario' 
                          : '${ApiService.userFirstName} ${ApiService.userLastName}',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 4),
                    Text(
                      ApiService.userEmail ?? 'Sin correo registrado',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF94A3B8), // Slate 400
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (ApiService.userRole ?? 'Usuario').toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Settings Options
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ajustes',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ),
              const SizedBox(height: 16),
              
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditarPerfilScreen())),
                child: _buildSettingsTile(LucideIcons.user, 'Editar Perfil'),
              ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificacionesScreen())),
                child: _buildSettingsTile(LucideIcons.bell, 'Notificaciones'),
              ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SeguridadScreen())),
                child: _buildSettingsTile(LucideIcons.shield, 'Seguridad y Privacidad'),
              ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
              
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  ApiService.token = null; // Limpiar token
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: _buildSettingsTile(LucideIcons.logOut, 'Cerrar Sesión', isDestructive: true),
              ).animate().fadeIn(delay: 900.ms).slideX(begin: 0.1),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
