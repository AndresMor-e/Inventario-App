import 'package:flutter/material.dart';
import '../../core/services/notificacion_services.dart';
import '../../core/utils/constants.dart';
import '../../data/models/producto_model.dart';
import '../../data/services/producto_service.dart';
import '../widgets/custom_card.dart';

class ProductosListScreen extends StatefulWidget {
  const ProductosListScreen({super.key});

  @override
  State<ProductosListScreen> createState() => _ProductosListScreenState();
}

class _ProductosListScreenState extends State<ProductosListScreen> {
  final ProductoService _productoService = ProductoService();
  final TextEditingController _busquedaController = TextEditingController();

  List<ProductoModel> _productos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    setState(() => _cargando = true);
    final lista = await _productoService.obtenerTodos();
    setState(() {
      _productos = lista;
      _cargando = false;
    });
  }

  Future<void> _buscarProductos(String query) async {
    if (query.trim().isEmpty) {
      _cargarProductos();
      return;
    }
    final lista = await _productoService.buscarPorNombre(query.trim());
    setState(() {
      _productos = lista;
    });
  }

  Future<void> _eliminarProducto(ProductoModel producto) async {
    final confirmar = await NotificacionesService.confirmarEliminacion(
      context,
      titulo: 'Eliminar Producto',
      mensaje: '¿Estás seguro de eliminar',
    );

    if (confirmar) {
      await _productoService.eliminar(producto.id!);
      NotificacionesService.mostrarExito(context, 'Producto eliminado');
      _cargarProductos();
    }
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: colorSecundario),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Productos en Inventario',
          style: TextStyle(color: colorSecundario, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Buscador de productos
              TextField(
                controller: _busquedaController,
                onChanged: _buscarProductos,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre...',
                  prefixIcon: const Icon(Icons.search, color: colorPrincipal),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: _cargando
                    ? const Center(child: CircularProgressIndicator(color: colorPrincipal))
                    : _productos.isEmpty
                        ? const Center(
                            child: Text(
                              'No se encontraron productos',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _productos.length,
                            itemBuilder: (context, index) {
                              final p = _productos[index];
                              return CustomCard(
                                titulo: p.nombre,
                                subtitulo: '\$ ${p.precio.toStringAsFixed(0)} | Stock: ${p.stock} unidades',
                                etiquetaAdicional: 'Proveedor: ${p.nombreProveedor ?? "No asignado"}',
                                onEdit: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/producto-form',
                                    arguments: p,
                                  ).then((_) => _cargarProductos());
                                },
                                onDelete: () => _eliminarProducto(p),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrincipal,
        onPressed: () {
          Navigator.pushNamed(context, '/producto-form').then((_) => _cargarProductos());
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}