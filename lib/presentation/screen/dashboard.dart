import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';
import '../../data/services/producto_service.dart';
import '../../data/services/proveedor_service.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProductoService _productoService = ProductoService();
  final ProveedorService _proveedorService = ProveedorService();

  int _totalProductos = 0;
  int _totalProveedores = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarMetricas();
  }

  Future<void> _cargarMetricas() async {
    setState(() => _cargando = true);
    final productos = await _productoService.obtenerTotal();
    final proveedores = await _proveedorService.obtenerTotal();
    setState(() {
      _totalProductos = productos;
      _totalProveedores = proveedores;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorPrincipal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: colorPrincipal, size: 24),
            ),
            const SizedBox(width: 10),
            const Text(
              appNombre,
              style: TextStyle(
                color: colorSecundario,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _cargarMetricas,
          color: colorPrincipal,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Resumen General',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorSecundario,
                  ),
                ),

                const SizedBox(height: 12),

                // Tarjetas de Resumen
                _cargando
                    ? const Center(child: CircularProgressIndicator(color: colorPrincipal))
                    : Row(
                        children: [
                          SummaryCard(
                            titulo: 'Productos',
                            valor: '$_totalProductos',
                            icono: Icons.shopping_bag_outlined,
                            colorIcono: Colors.blueAccent,
                            onTap: () {
                              Navigator.pushNamed(context, '/productos').then((_) => _cargarMetricas());
                            },
                          ),
                          const SizedBox(width: 12),
                          SummaryCard(
                            titulo: 'Proveedores',
                            valor: '$_totalProveedores',
                            icono: Icons.local_shipping_outlined,
                            colorIcono: Colors.orangeAccent,
                            onTap: () {
                              Navigator.pushNamed(context, '/proveedores').then((_) => _cargarMetricas());
                            },
                          ),
                        ],
                      ),

                const SizedBox(height: 24),

                const Text(
                  'Acceso Rápido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorSecundario,
                  ),
                ),

                const SizedBox(height: 12),

                _buildOptionTile(
                  context,
                  titulo: 'Ver Productos',
                  subtitulo: 'Consultar listado, precio y stock disponible',
                  icono: Icons.list_alt_rounded,
                  colorIcono: Colors.blueAccent,
                  onTap: () {
                    Navigator.pushNamed(context, '/productos').then((_) => _cargarMetricas());
                  },
                ),

                const SizedBox(height: 10),

                _buildOptionTile(
                  context,
                  titulo: 'Nuevo Producto',
                  subtitulo: 'Registrar un producto asociado a un proveedor',
                  icono: Icons.add_box_outlined,
                  colorIcono: colorPrincipal,
                  onTap: () {
                    Navigator.pushNamed(context, '/producto-form').then((_) => _cargarMetricas());
                  },
                ),

                const SizedBox(height: 10),

                _buildOptionTile(
                  context,
                  titulo: 'Gestión de Proveedores',
                  subtitulo: 'Registrar, editar y consultar contacto',
                  icono: Icons.people_outline_rounded,
                  colorIcono: Colors.orangeAccent,
                  onTap: () {
                    Navigator.pushNamed(context, '/proveedores').then((_) => _cargarMetricas());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color colorIcono,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorIcono.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: colorIcono, size: 24),
          ),
          title: Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colorSecundario,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            subtitulo,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}