import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';

class CustomCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String? etiquetaAdicional;
  final String? badgeTexto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    this.etiquetaAdicional,
    this.badgeTexto,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Barra de color lateral
              Container(width: 6, color: colorPrincipal),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: colorSecundario,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitulo,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                            if (etiquetaAdicional != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                etiquetaAdicional!,
                                style: const TextStyle(
                                  color: colorPrincipal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (badgeTexto != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeTexto!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: colorSecundario,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 22),
                        onPressed: onEdit,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: colorError, size: 22),
                        onPressed: onDelete,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}