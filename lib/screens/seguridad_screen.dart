import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SeguridadScreen extends StatelessWidget {
  const SeguridadScreen({super.key});

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
          'Seguridad y Privacidad',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildActionTile(context, 'Cambiar Contraseña', LucideIcons.key),
          const SizedBox(height: 16),
          _buildActionTile(context, 'Autenticación en Dos Pasos (2FA)', LucideIcons.smartphone),
          const SizedBox(height: 16),
          _buildActionTile(context, 'Dispositivos Conectados', LucideIcons.monitor),
          const SizedBox(height: 16),
          _buildActionTile(context, 'Política de Privacidad', LucideIcons.fileText),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Accediendo a $title...')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blueAccent, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
