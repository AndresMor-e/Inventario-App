class ProveedorModel {
  final int? id;
  final String nombre;
  final String? telefono;
  final String? correo;

  ProveedorModel({
    this.id,
    required this.nombre,
    this.telefono,
    this.correo,
  });

  // Convertir objeto Dart a Mapa para insertar/actualizar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'correo': correo,
    };
  }

  // Convertir Mapa de SQLite a objeto Dart
  factory ProveedorModel.fromMap(Map<String, dynamic> map) {
    return ProveedorModel(
      id: map['id'],
      nombre: map['nombre'],
      telefono: map['telefono'],
      correo: map['correo'],
    );
  }
}