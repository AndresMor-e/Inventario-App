import 'package:flutter/material.dart';
import '../../core/services/notificacion_services.dart';
import '../../core/utils/constants.dart';
import '../../data/models/producto_model.dart';
import '../../data/models/proveedor_model.dart';
import '../../data/services/producto_service.dart';
import '../../data/services/proveedor_service.dart';
import '../widgets/custom_text_field.dart';

class ProductoFormScreen extends StatefulWidget {
  const ProductoFormScreen({super.key});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService _productoService = ProductoService();
  final ProveedorService _proveedorService = ProveedorService();

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();

  List<ProveedorModel> _proveedores = [];
  int? _proveedorSeleccionadoId;
  ProductoModel? _productoEditar;
  bool _cargandoProveedores = true;

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is ProductoModel && _productoEditar == null) {
      _productoEditar = args;
      _nombreCtrl.text = _productoEditar!.nombre;
      _precioCtrl.text = _productoEditar!.precio.toStringAsFixed(0);
      _stockCtrl.text = _productoEditar!.stock.toString();
      _proveedorSeleccionadoId = _productoEditar!.proveedorId;
    }
  }

  Future<void> _cargarProveedores() async {
    final lista = await _proveedorService.obtenerTodos();
    setState(() {
      _proveedores = lista;
      _cargandoProveedores = false;
    });
  }

  void _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    if (_proveedorSeleccionadoId == null) {
      NotificacionesService.mostrarError(context, 'Por favor selecciona un proveedor');
      return;
    }

    final double? precio = double.tryParse(_precioCtrl.text.trim());
    final int? stock = int.tryParse(_stockCtrl.text.trim());

    if (precio == null || precio <= 0) {
      NotificacionesService.mostrarError(context, 'Ingresa un precio válido mayor a 0');
      return;
    }

    if (stock == null || stock < 0) {
      NotificacionesService.mostrarError(context, 'Ingresa una cantidad de stock válida');
      return;
    }

    final producto = ProductoModel(
      id: _productoEditar?.id,
      nombre: _nombreCtrl.text.trim(),
      precio: precio,
      stock: stock,
      proveedorId: _proveedorSeleccionadoId!,
    );

    if (_productoEditar == null) {
      await _productoService.insertar(producto);
      NotificacionesService.mostrarExito(context, 'Producto guardado exitosamente');
    } else {
      await _productoService.actualizar(producto);
      NotificacionesService.mostrarExito(context, 'Producto actualizado exitosamente');
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = _productoEditar != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: colorSecundario),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          esEdicion ? 'Editar Producto' : 'Nuevo Producto',
          style: const TextStyle(color: colorSecundario, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: 'Nombre del producto *',
                  placeholder: 'Ej. Teclado Mecánico',
                  cnt: _nombreCtrl,
                  icon: Icons.inventory,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Precio por unidad (\$) *',
                  placeholder: 'Ej. 150000',
                  cnt: _precioCtrl,
                  typeKB: TextInputType.number,
                  icon: Icons.attach_money,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'El precio es obligatorio';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Cantidad en stock *',
                  placeholder: 'Ej. 25',
                  cnt: _stockCtrl,
                  typeKB: TextInputType.number,
                  icon: Icons.format_list_numbered,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'El stock es obligatorio';
                    }
                    return null;
                  },
                ),
                const Text(
                  'Proveedor *',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colorSecundario),
                ),
                const SizedBox(height: 6),

                // Selector Dropdown de Proveedores
                _cargandoProveedores
                    ? const Center(child: CircularProgressIndicator(color: colorPrincipal))
                    : _proveedores.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.warning_amber_rounded, color: colorError),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'No hay proveedores disponibles. Registra uno primero.',
                                    style: TextStyle(color: colorError, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey.shade50,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _proveedorSeleccionadoId,
                                isExpanded: true,
                                hint: const Text('Selecciona un proveedor'),
                                items: _proveedores
                                    .map(
                                      (prov) => DropdownMenuItem<int>(
                                        value: prov.id,
                                        child: Text('${prov.nombre}'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (nuevoId) {
                                  setState(() => _proveedorSeleccionadoId = nuevoId);
                                },
                              ),
                            ),
                          ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrincipal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _guardarProducto,
                    child: Text(
                      esEdicion ? 'Actualizar Producto' : 'Guardar Producto',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}