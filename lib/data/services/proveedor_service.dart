import '../../db/db.dart';
import '../models/proveedor_model.dart';

class ProveedorService {
  final DB _dbHelper = DB();

  // 1. Obtener todos los proveedores
  Future<List<ProveedorModel>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('proveedores', orderBy: 'nombre ASC');
    return List.generate(maps.length, (i) => ProveedorModel.fromMap(maps[i]));
  }

  // 2. Insertar proveedor
  Future<int> insertar(ProveedorModel proveedor) async {
    final db = await _dbHelper.database;
    return await db.insert('proveedores', proveedor.toMap());
  }

  // 3. Actualizar proveedor
  Future<int> actualizar(ProveedorModel proveedor) async {
    final db = await _dbHelper.database;
    return await db.update(
      'proveedores',
      proveedor.toMap(),
      where: 'id = ?',
      whereArgs: [proveedor.id],
    );
  }

  // 4. Validar si el proveedor tiene productos asociados antes de eliminar
  Future<bool> tieneProductosAsociados(int proveedorId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM productos WHERE proveedor_id = ?',
      [proveedorId],
    );
    int total = (result.first['total'] as int?) ?? 0;
    return total > 0;
  }

  // 5. Eliminar proveedor (Retorna false si tiene productos asociados)
  Future<bool> eliminar(int proveedorId) async {
    bool asociado = await tieneProductosAsociados(proveedorId);
    if (asociado) {
      return false;
    }

    final db = await _dbHelper.database;
    await db.delete(
      'proveedores',
      where: 'id = ?',
      whereArgs: [proveedorId],
    );
    return true;
  }

  // 6. Obtener total de proveedores
  Future<int> obtenerTotal() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM proveedores');
    return (result.first['total'] as int?) ?? 0;
  }
}