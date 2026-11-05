import '../../db/db.dart';
import '../models/producto_model.dart';

class ProductoService {
  final DB _dbHelper = DB();

  // 1. Obtener todos los productos utilizando INNER JOIN
  Future<List<ProductoModel>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT 
        p.id,
        p.nombre,
        p.precio,
        p.stock,
        p.proveedor_id,
        pr.nombre AS nombre_proveedor
      FROM productos p
      INNER JOIN proveedores pr ON p.proveedor_id = pr.id
      ORDER BY p.id DESC
    ''');

    return List.generate(maps.length, (i) => ProductoModel.fromMap(maps[i]));
  }

  // 2. Buscar productos por nombre usando INNER JOIN y LIKE
  Future<List<ProductoModel>> buscarPorNombre(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT 
        p.id,
        p.nombre,
        p.precio,
        p.stock,
        p.proveedor_id,
        pr.nombre AS nombre_proveedor
      FROM productos p
      INNER JOIN proveedores pr ON p.proveedor_id = pr.id
      WHERE p.nombre LIKE ?
      ORDER BY p.id DESC
    ''', ['%$query%']);

    return List.generate(maps.length, (i) => ProductoModel.fromMap(maps[i]));
  }

  // 3. Insertar producto
  Future<int> insertar(ProductoModel producto) async {
    final db = await _dbHelper.database;
    return await db.insert('productos', producto.toMap());
  }

  // 4. Actualizar producto
  Future<int> actualizar(ProductoModel producto) async {
    final db = await _dbHelper.database;
    return await db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  // 5. Eliminar producto
  Future<int> eliminar(int productoId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [productoId],
    );
  }

  // 6. Obtener total de productos
  Future<int> obtenerTotal() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM productos');
    return (result.first['total'] as int?) ?? 0;
  }
}