import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dashboard_screen.dart';
import 'dashboard_reclutador_screen.dart';
import 'candidatos_screen.dart';
import 'pruebas_screen.dart';
import 'perfil_screen.dart';
import '../services/api_service.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens {
    if (ApiService.userRole == 'reclutador') {
      return const [
        DashboardReclutadorScreen(),
        PruebasScreen(),
        PerfilScreen(),
      ];
    } else {
      return const [
        DashboardScreen(),
        CandidatosScreen(),
        PerfilScreen(),
      ];
    }
  }

  List<BottomNavigationBarItem> get _navItems {
    if (ApiService.userRole == 'reclutador') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.layoutDashboard),
          label: 'Convocatorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.library),
          label: 'Pruebas',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.userCircle),
          label: 'Perfil',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.layoutDashboard),
          label: 'Sesiones',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.users),
          label: 'Directorio',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.userCircle),
          label: 'Perfil',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: const Color(0xFF64748B),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: _navItems,
        ),
      ),
    );
  }
}
