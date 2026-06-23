import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Almacenamiento en memoria de notificaciones recibidas durante la sesión
class NotificationStore {
  static final NotificationStore _instance = NotificationStore._internal();
  factory NotificationStore() => _instance;
  NotificationStore._internal();

  final List<AppNotification> notifications = [];
  final List<VoidCallback> _listeners = [];

  void addNotification(String title, String body) {
    notifications.insert(0, AppNotification(
      title: title,
      body: body,
      receivedAt: DateTime.now(),
    ));
    for (final listener in _listeners) {
      listener();
    }
  }

  void addListener(VoidCallback callback) => _listeners.add(callback);
  void removeListener(VoidCallback callback) => _listeners.remove(callback);
  void clearAll() => notifications.clear();
}

class AppNotification {
  final String title;
  final String body;
  final DateTime receivedAt;

  AppNotification({required this.title, required this.body, required this.receivedAt});
}

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  final NotificationStore _store = NotificationStore();

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Ahora mismo';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return 'Hace ${diff.inDays} días';
  }

  @override
  Widget build(BuildContext context) {
    final notifs = _store.notifications;

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
          'Notificaciones',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          if (notifs.isNotEmpty)
            TextButton.icon(
              icon: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFF94A3B8)),
              label: Text('Limpiar', style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13)),
              onPressed: () {
                setState(() => _store.clearAll());
              },
            ),
        ],
      ),
      body: notifs.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifs.length,
              itemBuilder: (context, index) {
                final n = notifs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(LucideIcons.bell, color: Colors.blueAccent, size: 20),
                      ),
                      title: Text(
                        n.title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            n.body,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _timeAgo(n.receivedAt),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.blueAccent.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1),
                );
              },
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(LucideIcons.bellOff, color: Color(0xFF475569), size: 36),
          ),
          const SizedBox(height: 20),
          Text(
            'Sin notificaciones',
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Las notificaciones que recibas\naparecerán aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}
