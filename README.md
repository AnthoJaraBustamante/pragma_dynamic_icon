# pragma_dynamic_icon

Ejemplo en Flutter para cambiar el icono del home **sin un release por cada temporada**, usando [dynamic_app_icon_flutter_plus](https://pub.dev/packages/dynamic_app_icon_flutter_plus) `2.2.1`.

Probado con Flutter 3.44.

## Qué hace

La app lista las variantes empaquetadas y te deja elegir una:

| Variante | Id | Android | iOS |
|---|---|---|---|
| Predeterminado | `null` | `ic_launcher` | `default` |
| Oscuro | `dark` | `ic_launcher_dark` | `dark` |
| Claro | `light` | `ic_launcher_light` | `light` |

El icono no se descarga en runtime. Tiene que ir en el binario. Después lo enciendes o lo apagas desde Dart.

## Cómo correrlo

```bash
flutter pub get
flutter run
```

Para ver el overlay de producción (un solo icono en el cajón, launcher = alias `.default`):

```bash
flutter build apk --release
```

## Android

En `main` `MainActivity` conserva `MAIN` / `LAUNCHER`. Si no, `flutter run` falla con *package identifier or launch activity not found*.

Los aliases viven en `android/app/src/main/AndroidManifest.xml`. Encima hay overlays:

- **debug / profile:** apagan el alias `.default` para no tener dos iconos mientras desarrollas.
- **release:** quitan el launcher de `MainActivity`. En el APK de tienda la puerta del home es el alias.

Si usas `deferUntilBackground: true`, el cambio se aplica al salir de la app (`applyPendingIcon` en `paused`).

## iOS

Las variantes están en `ios/Runner/Info.plist` (`CFBundleAlternateIcons`) y los PNG en `ios/Runner/App Icon/` como *folder reference*.

Pruébalo en un iPhone. En el Simulator suele fallar con *Resource temporarily unavailable*. En App Store deja `showAlert: true`.

## API que usa el ejemplo

```dart
await DynamicAppIconFlutterPlus.supportsAlternateIcons;
await DynamicAppIconFlutterPlus.getAvailableIcons();
await DynamicAppIconFlutterPlus.getAlternateIconName();
await DynamicAppIconFlutterPlus.setAlternateIconName('dark');
await DynamicAppIconFlutterPlus.setAlternateIconName(null);
await DynamicAppIconFlutterPlus.applyPendingIcon();
```

## Fuentes

- Paquete: https://pub.dev/packages/dynamic_app_icon_flutter_plus

