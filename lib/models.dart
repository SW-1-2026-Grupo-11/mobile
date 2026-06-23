class Entrevista {
  final int id;
  final String titulo;
  final String fecha;
  final String candidato;
  final String avatarUrl;

  Entrevista({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.candidato,
    required this.avatarUrl,
  });

  factory Entrevista.fromJson(Map<String, dynamic> json) {
    return Entrevista(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? json['nombre'] ?? 'Entrevista Genérica',
      fecha: json['fecha_programada'] ?? json['fecha'] ?? 'Desconocida',
      candidato: (json['candidato'] is Map ? json['candidato']['nombre'] : json['candidato_nombre']) ?? 'Candidato',
      avatarUrl: "https://i.pravatar.cc/150?u=${json['id'] ?? 'default'}",
    );
  }
}

class Reporte {
  final int id;
  final int entrevistaId;
  final String nivelRiesgo;
  final int puntajeAtencion;
  final int puntajeSospecha;
  final String resumenGeneral;
  final List<String> recomendaciones;

  Reporte({
    required this.id,
    required this.entrevistaId,
    required this.nivelRiesgo,
    required this.puntajeAtencion,
    required this.puntajeSospecha,
    required this.resumenGeneral,
    required this.recomendaciones,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['id'] ?? 0,
      entrevistaId: (json['entrevista'] is Map ? json['entrevista']['id'] : json['entrevista']) ?? 0,
      nivelRiesgo: json['nivel_riesgo']?.toString().toLowerCase() ?? 'bajo',
      puntajeAtencion: json['puntaje_atencion'] ?? 100,
      puntajeSospecha: json['puntaje_sospecha'] ?? 0,
      resumenGeneral: json['resumen_general'] ?? 'Sin detalles',
      recomendaciones: (json['recomendaciones'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

// Mock Data
final List<Entrevista> mockEntrevistas = [
  Entrevista(
      id: 1,
      titulo: "Entrevista Frontend Sr.",
      fecha: "20 Oct 2026",
      candidato: "Carlos Ruiz",
      avatarUrl: "https://i.pravatar.cc/150?u=carlos"),
  Entrevista(
      id: 2,
      titulo: "Examen de Admisión",
      fecha: "19 Oct 2026",
      candidato: "Ana Gómez",
      avatarUrl: "https://i.pravatar.cc/150?u=ana"),
  Entrevista(
      id: 3,
      titulo: "Evaluación Técnica",
      fecha: "18 Oct 2026",
      candidato: "Luis Pérez",
      avatarUrl: "https://i.pravatar.cc/150?u=luis"),
];

final List<Reporte> mockReportes = [
  Reporte(
    id: 101,
    entrevistaId: 1,
    nivelRiesgo: "alto",
    puntajeAtencion: 45,
    puntajeSospecha: 85,
    resumenGeneral:
        "El candidato desvió la mirada de la pantalla en repetidas ocasiones (más de 15 veces por minuto). Se detectaron voces de fondo no identificadas.",
    recomendaciones: [
      "Revisar el fragmento de video entre 10:00 y 12:30.",
      "Programar una entrevista de seguimiento."
    ],
  ),
  Reporte(
    id: 102,
    entrevistaId: 2,
    nivelRiesgo: "bajo",
    puntajeAtencion: 95,
    puntajeSospecha: 5,
    resumenGeneral:
        "Sesión normal. El usuario mantuvo contacto visual con la prueba durante todo el tiempo. No se detectaron anomalías sonoras o visuales.",
    recomendaciones: ["Aprobar resultados de la evaluación."],
  ),
  Reporte(
    id: 103,
    entrevistaId: 3,
    nivelRiesgo: "medio",
    puntajeAtencion: 70,
    puntajeSospecha: 35,
    resumenGeneral:
        "Se detectó el uso de un teléfono celular de reojo en el minuto 45. La atención fluctuó durante la última media hora.",
    recomendaciones: [
      "Verificar la grabación al minuto 45.",
      "Preguntar al candidato sobre el uso de dispositivos adicionales."
    ],
  ),
];

class Prueba {
  final int id;
  final String titulo;
  final String descripcion;
  final String tipo;
  final String area;
  final String nivel;
  final int duracionMinutos;
  final int puntajeMaximo;
  final String estado;

  Prueba({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.area,
    required this.nivel,
    required this.duracionMinutos,
    required this.puntajeMaximo,
    required this.estado,
  });

  factory Prueba.fromJson(Map<String, dynamic> json) {
    return Prueba(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Prueba sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      tipo: json['tipo'] ?? 'desconocido',
      area: json['area'] ?? 'desconocida',
      nivel: json['nivel'] ?? 'basico',
      duracionMinutos: json['duracion_minutos'] ?? 60,
      puntajeMaximo: json['puntaje_maximo'] ?? 100,
      estado: json['estado'] ?? 'borrador',
    );
  }
}
