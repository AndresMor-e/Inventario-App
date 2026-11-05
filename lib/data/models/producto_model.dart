class ProductoModel {
  final int? id;
  final String nombre;
  final double precio;
  final int stock;
  final int proveedorId;
  final String? nombreProveedor; // Campo extra para el INNER JOIN

  ProductoModel({
    this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.proveedorId,
    this.nombreProveedor,
  });

  // Convertir a Mapa para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'proveedor_id': proveedorId,
    };
  }

  // Convertir desde Mapa de SQLite (soporta campos de INNER JOIN)
  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      id: map['id'],
      nombre: map['nombre'],
      precio: (map['precio'] as num).toDouble(),
      stock: map['stock'],
      proveedorId: map['proveedor_id'],
      nombreProveedor: map['nombre_proveedor'], // Viene de la consulta relacional
    );
  }
}