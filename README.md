# Fake Store App

Una aplicación Flutter que consume el package [dart_package_fake_store](https://github.com/mmaurogg/dart_package_fake_store.git) para mostrar productos y gestionar la autenticación de usuarios.

Este proyecto sirve como un ejemplo práctico de cómo construir una aplicación de comercio electrónico utilizando Flutter, Riverpod y un package personalizado.

## Características

- **Autenticación de Usuario**:
  - Inicio de sesión con credenciales.
  - Opción de inicio de sesión rápido con un usuario de prueba.
- **Visualización de Productos**:
  - Carga y muestra una lista de productos desde la API.
  - Vista de detalle para cada producto.
- **Carrito de Compras**:
  - Carga y muestra una lista de productos del carrito del usuario desde la API.
  - Boton de pago para envio de carrito.

- **Arquitectura**: 
  - Arquitectura basada en Riverpod para manejo de estado con el uso de providers.

## Getting Started

### Prerrequisitos

Asegúrate de tener el SDK de Flutter instalado en tu máquina.

```shell
# Clona este repositorio
git clone https://github.com/mmaurogg/fake_store_app.git

cd fake_store_app

# Instala las dependencias
flutter pub get

# Ejecuta la aplicación
flutter run
```

## Requisitos

- Flutter SDK >= 3.9.2
- Dart >= 3.9.2

## Pila Tecnológica y Dependencias Clave

- **Framework**: [Flutter](https://flutter.dev/)
- **Lenguaje**: [Dart](https://dart.dev/)
- **Gestión de Estado**: [Flutter Riverpod](https://riverpod.dev/)
- **Capa de Data**: [Fake Store API](https://fakestoreapi.com/)

## Estructura del Proyecto

El proyecto sigue una estructura orientada a funcionalidades para mantener el código organizado y desacoplado.

```
lib/
├── config/           # Configuración de la app (tema, dependencias)
├── ui/
│   ├── pages/        # Pantallas principales de la app 
│   ├── providers/    # Providers de Riverpod para el estado de la UI
│   └── widgets/      # Widgets reutilizables
└── main.dart         # Punto de entrada de la aplicación
```

## Recursos útiles

- [dart_package_fake_store](https://github.com/mmaurogg/dart_package_fake_store.git)
- [Riverpod](https://riverpod.dev)


