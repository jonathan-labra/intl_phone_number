# 🚀 Guía para subir tu paquete Flutter a GitHub

## Paso 1 — Prepara tu paquete localmente

```bash
# Entra a la carpeta del paquete
cd mi_phone_input

# Verifica que no hay errores de análisis
flutter analyze

# Corre los tests
flutter test

# Formatea el código
dart format .
```

---

## Paso 2 — Inicializa Git y sube a GitHub

```bash
# Inicializa el repositorio
git init

# Agrega todos los archivos
git add .

# Primer commit
git commit -m "feat: primer versión del paquete mi_phone_input"

# Conecta con tu repositorio de GitHub
# (primero créalo en github.com vacío, sin README ni .gitignore)
git remote add origin https://github.com/TU_USUARIO/mi_phone_input.git

# Sube el código
git push -u origin main
```

---

## Paso 3 — Crea un tag de versión (opcional pero recomendado)

```bash
# Crea un tag con la versión
git tag v0.1.0

# Sube el tag a GitHub
git push origin v0.1.0
```

---

## Paso 4 — Úsalo en tus proyectos Flutter

En el `pubspec.yaml` del proyecto que quiera usar tu paquete:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Opción A: desde GitHub usando main
  mi_phone_input:
    git:
      url: https://github.com/TU_USUARIO/mi_phone_input.git
      ref: main

  # Opción B: desde GitHub usando un tag específico (más estable)
  mi_phone_input:
    git:
      url: https://github.com/TU_USUARIO/mi_phone_input.git
      ref: v0.1.0

  # Opción C: ruta local para desarrollo
  mi_phone_input:
    path: ../mi_phone_input
```

Luego ejecuta:

```bash
flutter pub get
```

---

## Paso 5 — Cómo publicar una nueva versión

1. Haz tus cambios en el código
2. Actualiza la versión en `pubspec.yaml` (ej: `0.1.0` → `0.2.0`)
3. Documenta los cambios en `CHANGELOG.md`
4. Commit y tag:

```bash
git add .
git commit -m "feat: nuevas funcionalidades"
git tag v0.2.0
git push origin main
git push origin v0.2.0
```

5. En los proyectos que usen tu paquete, actualiza el `ref` en `pubspec.yaml`

---

## Estructura del paquete

```
mi_phone_input/
├── lib/
│   ├── mi_phone_input.dart          ← Exportaciones públicas
│   └── src/
│       ├── mi_phone_input.dart      ← Widget principal
│       ├── models/
│       │   ├── phone_number.dart    ← Modelo PhoneNumber
│       │   └── country.dart         ← Modelo Country + lista
│       └── widgets/
│           └── country_picker_dialog.dart  ← Diálogo picker
├── test/
│   └── mi_phone_input_test.dart     ← Tests unitarios
├── example/
│   ├── lib/main.dart                ← App de demostración
│   └── pubspec.yaml
├── .github/
│   └── workflows/ci.yml             ← CI automático
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
├── LICENSE
└── .gitignore
```

---

## Personalización avanzada

### Agregar más países

Edita `lib/src/models/country.dart` y agrega a la lista `all`:

```dart
Country(isoCode: 'XX', name: 'Mi País', dialCode: '+999', flag: '🏳️'),
```

### Agregar validación por país

En `PhoneNumber`, modifica el getter `isValid`:

```dart
bool get isValid {
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
  // Reglas por país:
  switch (isoCode) {
    case 'MX': return digits.length == 10;
    case 'US': return digits.length == 10;
    case 'AR': return digits.length >= 10;
    default:   return digits.length >= 6;
  }
}
```

### Cambiar el tema del diálogo

Usa el parámetro `selectorBuilder` para reemplazar el botón del selector, o personaliza el `CountryPickerDialog` directamente modificando `country_picker_dialog.dart`.
