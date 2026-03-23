# Aplicación de Registro de Correspondencia Certificada

Esta aplicación Flutter permite gestionar el registro de correspondencia certificada en una oficina administrativa.

## Características

- Formulario para ingresar nuevos registros con validaciones
- Tabla dinámica para listar registros
- Funciones CRUD: Crear, Leer, Actualizar, Eliminar
- Búsqueda y filtrado por múltiples criterios
- Exportación de datos a CSV
- Ordenamiento automático por fecha y hora
- Interfaz completamente en español
- Diseño tipo panel administrativo

## Instalación y Ejecución

1. Asegúrate de tener Flutter instalado: https://flutter.dev/docs/get-started/install
2. Clona o descarga el proyecto
3. Ejecuta `flutter pub get` para instalar dependencias
4. Para ejecutar en web: `flutter run -d chrome`
5. Para construir para producción web: `flutter build web`

## Tecnologías Utilizadas

- Flutter para el frontend
- Provider para gestión de estado
- CSV para exportación
- Universal HTML para descarga en web

## Notas sobre Persistencia

Actualmente, los datos se almacenan en memoria local. Para persistencia real, conecta Supabase siguiendo las instrucciones en el panel de configuración del proyecto.

## Estructura de Carpetas

```
lib/
├── models/
│   └── correspondence.dart
├── providers/
│   └── correspondence_provider.dart
├── screens/
│   └── home_screen.dart
├── utils/
│   └── csv_exporter.dart
└── widgets/
    ├── form_widget.dart
    └── table_widget.dart
```

## Funcionalidades Adicionales

- Validación de unicidad del Código de Guía
- Mensajes de confirmación para eliminación
- Filtros por rango de fechas
- Exportación a CSV con descarga automática