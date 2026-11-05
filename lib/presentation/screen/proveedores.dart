import 'package:flutter/material.dart';
import '../../core/services/notificacion_services.dart';
import '../../core/utils/constants.dart';
import '../../data/models/proveedor_model.dart';
import '../../data/services/proveedor_service.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_text_field.dart';

class ProveedoresScreen extends StatefulWidget {
  const ProveedoresScreen({super.key});

  @override
  State<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends State<ProveedoresScreen> {
  final ProveedorService _proveedorService = ProveedorService();
  List<ProveedorModel> _proveedores = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    setState(() => _cargando = true);
    final lista = await _proveedorService.obtenerTodos();
    setState(() {
      _proveedores = lista;
      _cargando = false;
    });
  }

  void _abrirFormulario({ProveedorModel? proveedor}) {
    final nombreCtrl = TextEditingController(text: proveedor?.nombre ?? '');
    final telefonoCtrl = TextEditingController(text: proveedor?.telefono ?? '');
    final correoCtrl = TextEditingController(text: proveedor?.correo ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proveedor == null ? 'Nuevo Proveedor' : 'Editar Proveedor',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorSecundario,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Nombre*',
                  placeholder: 'Ej. Distribuidora Central',
                  cnt: nombreCtrl,
                  icon: Icons.business,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Teléfono',
                  placeholder: 'Ej. 3001234567',
                  cnt: telefonoCtrl,
                  typeKB: TextInputType.phone,
                  icon: Icons.phone,
                ),
                CustomTextField(
                  label: 'Correo Electrónico',
                  placeholder: 'Ej. contacto@proveedor.com',
                  cnt: correoCtrl,
                  typeKB: TextInputType.emailAddress,
                  icon: Icons.email,
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      if (!val.contains('@') || !val.contains('.')) {
                        return 'Ingresa un correo electrónico válido';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrincipal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final nuevo = ProveedorModel(
                          id: proveedor?.id,
                          nombre: nombreCtrl.text.trim(),
                          telefono: telefonoCtrl.text.trim().isEmpty ? null : telefonoCtrl.text.trim(),
                          correo: correoCtrl.text.trim().isEmpty ? null : correoCtrl.text.trim(),
                        );

                        if (proveedor == null) {
                          await _proveedorService.insertar(nuevo);
                          NotificacionesService.mostrarExito(context, 'Proveedor guardado correctamente');
                        } else {
                          await _proveedorService.actualizar(nuevo);
                          NotificacionesService.mostrarExito(context, 'Proveedor actualizado correctamente');
                        }

                        Navigator.pop(context);
                        _cargarProveedores();
                      }
                    },
                    child: Text(
                      proveedor == null ? 'Guardar Proveedor' : 'Actualizar Proveedor',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _eliminarProveedor(ProveedorModel proveedor) async {
    final confirmar = await NotificacionesService.confirmarEliminacion(
      context,
      titulo: 'Eliminar Proveedor',
      mensaje: '¿Estás seguro de eliminar a "${proveedor.nombre}"?',
    );

    if (confirmar) {
      final eliminado = await _proveedorService.eliminar(proveedor.id!);
      if (eliminado) {
        NotificacionesService.mostrarExito(context, 'Proveedor eliminado');
        _cargarProveedores();
      } else {
        // Alerta requerida de integridad referencial
        NotificacionesService.mostrarError(
          context,
          'No se puede eliminar: El proveedor tiene productos asociados.',
        );
      }
    }
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
          'Gestión de Proveedores',
          style: TextStyle(color: colorSecundario, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _cargando
              ? const Center(child: CircularProgressIndicator(color: colorPrincipal))
              : _proveedores.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay proveedores registrados',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _proveedores.length,
                      itemBuilder: (context, index) {
                        final p = _proveedores[index];
                        String infoContacto = '';
                        if (p.telefono != null) infoContacto += 'Tel: ${p.telefono}  ';
                        if (p.correo != null) infoContacto += 'Email: ${p.correo}';
                        if (infoContacto.isEmpty) infoContacto = 'Sin datos de contacto';

                        return CustomCard(
                          titulo: p.nombre,
                          subtitulo: infoContacto,
                          onEdit: () => _abrirFormulario(proveedor: p),
                          onDelete: () => _eliminarProveedor(p),
                        );
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrincipal,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}