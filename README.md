# mi_phone_input

Un widget Flutter totalmente personalizable para ingresar números de teléfono con selector de país, banderas emoji y validación integrada.

> Inspirado en `intl_phone_number_input` pero 100% tuyo — sin dependencias externas pesadas.

---

## Características

- 🌎 **70+ países** con banderas emoji y códigos de marcado
- 🔍 **Búsqueda de países** en tiempo real dentro del diálogo
- 🎨 **100% personalizable** — selector, decoración, lista de países
- ✅ **Validación integrada** con callback `onInputValidated`
- 📦 **Sin dependencias** externas innecesarias
- 🧪 **Tests unitarios** incluidos

---

## Instalación

### Desde GitHub (recomendado para uso privado)

En tu `pubspec.yaml`:

```yaml
dependencies:
  mi_phone_input:
    git:
      url: https://github.com/TU_USUARIO/mi_phone_input.git
      ref: main  # o un tag: v0.1.0
```

Luego ejecuta:

```bash
flutter pub get
```

---

## Uso básico

```dart
import 'package:mi_phone_input/mi_phone_input.dart';

MiPhoneInput(
  initialCountry: 'MX',
  onInputChanged: (PhoneNumber phone) {
    print(phone.completeNumber); // +525512345678
    print(phone.isoCode);        // MX
    print(phone.isValid);        // true/false
  },
)
```

---

## Parámetros disponibles

### Callbacks

| Parámetro | Tipo | Descripción |
|---|---|---|
| `onInputChanged` | `ValueChanged<PhoneNumber>?` | Se llama al cambiar número o país |
| `onInputValidated` | `ValueChanged<bool>?` | Se llama con `true` si el número es válido |

### Configuración inicial

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `initialCountry` | `String` | `'MX'` | Código ISO del país inicial |
| `initialValue` | `String?` | `null` | Número inicial sin código de país |
| `countries` | `List<Country>?` | todos | Lista restringida de países |

### TextField

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `inputDecoration` | `InputDecoration?` | - | Decoración del campo de texto |
| `textStyle` | `TextStyle?` | - | Estilo del número escrito |
| `hintText` | `String` | `'Número de teléfono'` | Hint text del campo |
| `readOnly` | `bool` | `false` | Campo de solo lectura |
| `controller` | `TextEditingController?` | - | Controller externo |
| `focusNode` | `FocusNode?` | - | FocusNode externo |

### Selector de país

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `selectorBuilder` | `Widget Function(Country)?` | - | Builder personalizado del selector |
| `showFlag` | `bool` | `true` | Mostrar bandera emoji |
| `showDialCode` | `bool` | `true` | Mostrar código (+52) |
| `showCountryCode` | `bool` | `false` | Mostrar ISO (MX) |
| `selectorEnabled` | `bool` | `true` | Permitir cambiar país |
| `searchHint` | `String` | `'Buscar país...'` | Hint del buscador |
| `showSeparator` | `bool` | `true` | Línea divisoria |
| `separatorColor` | `Color?` | - | Color del separador |

---

## Ejemplos

### Solo países de LATAM

```dart
MiPhoneInput(
  initialCountry: 'MX',
  countries: [
    Country.findByIso('MX')!,
    Country.findByIso('CO')!,
    Country.findByIso('AR')!,
    Country.findByIso('CL')!,
    Country.findByIso('BR')!,
  ],
)
```

### Selector completamente personalizado

```dart
MiPhoneInput(
  initialCountry: 'MX',
  selectorBuilder: (country) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text('${country.flag} ${country.dialCode}'),
  ),
)
```

### Sin selector (país fijo)

```dart
MiPhoneInput(
  initialCountry: 'MX',
  selectorEnabled: false,
)
```

---

## Modelo PhoneNumber

```dart
class PhoneNumber {
  final String phoneNumber;  // "5512345678"
  final String isoCode;      // "MX"
  final String dialCode;     // "+52"

  String get completeNumber; // "+525512345678"
  bool get isValid;          // true si >= 6 dígitos

  Map<String, dynamic> toMap();
  factory PhoneNumber.fromMap(Map<String, dynamic>);
}
```

---

## Cómo actualizar el paquete en tus proyectos

Cuando publiques una nueva versión en GitHub, actualiza el `ref` en tu `pubspec.yaml`:

```yaml
mi_phone_input:
  git:
    url: https://github.com/TU_USUARIO/mi_phone_input.git
    ref: v0.2.0  # cambia al nuevo tag
```

Luego ejecuta `flutter pub get`.

---

## Desarrollo local

Si quieres modificar el paquete y probarlo en un proyecto local sin subirlo a GitHub:

```yaml
mi_phone_input:
  path: ../ruta/a/mi_phone_input
```

---

## Licencia

MIT © TU_NOMBRE
