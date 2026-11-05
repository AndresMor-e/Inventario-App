import 'package:flutter/material.dart';
import '../presentation/screen/dashboard.dart';
import '../presentation/screen/producto_form.dart';
import '../presentation/screen/productos_list.dart';
import '../presentation/screen/proveedores.dart';

Map<String, WidgetBuilder> obtenerRutas() {
  return {
    '/': (context) => const DashboardScreen(),
    '/productos': (context) => const ProductosListScreen(),
    '/producto-form': (context) => const ProductoFormScreen(),
    '/proveedores': (context) => const ProveedoresScreen(),
  };
}