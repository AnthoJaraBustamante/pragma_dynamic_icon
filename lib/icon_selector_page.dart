import 'package:dynamic_app_icon_flutter_plus/dynamic_app_icon_flutter_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'icon_option.dart';

class IconSelectorPage extends StatefulWidget {
  const IconSelectorPage({super.key});

  @override
  State<IconSelectorPage> createState() => _IconSelectorPageState();
}

class _IconSelectorPageState extends State<IconSelectorPage> {
  bool _loading = true;
  bool _supported = false;
  bool _busy = false;
  bool _deferUntilBackground =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  String? _currentIcon;
  List<String> _availableIcons = const [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final supported = await DynamicAppIconFlutterPlus.supportsAlternateIcons;
      final icons = supported
          ? await DynamicAppIconFlutterPlus.getAvailableIcons()
          : <String>[];
      final current = supported
          ? await DynamicAppIconFlutterPlus.getAlternateIconName()
          : null;

      if (!mounted) {
        return;
      }

      setState(() {
        _supported = supported;
        _availableIcons = icons;
        _currentIcon = current;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _supported = false;
        _loading = false;
        _error = '$error';
      });
    }
  }

  Future<void> _setIcon(String? iconName) async {
    setState(() => _busy = true);

    try {
      await DynamicAppIconFlutterPlus.setAlternateIconName(
        iconName,
        deferUntilBackground: _deferUntilBackground,
      );
      await _loadState();
      if (!mounted) {
        return;
      }
      final label = iconName ?? 'predeterminado';
      final deferredNote = _deferUntilBackground
          ? ' En Android el cambio se aplica al salir de la app.'
          : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Icono "$label" seleccionado.$deferredNote')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cambiar el icono: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: const Text('Icono dinámico')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cambia el icono del launcher en tiempo de ejecución con '
                    'dynamic_app_icon_flutter_plus, sin republicar la app.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_loading) const LinearProgressIndicator(),
                  if (!_loading) ...[
                    _StatusCard(
                      supported: _supported,
                      currentIcon: _currentIcon,
                      availableIcons: _availableIcons,
                      error: _error,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Variantes', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...IconOption.catalog.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _IconCard(
                        option: option,
                        selected: _currentIcon == option.id,
                        enabled: _supported && !_busy && !_loading,
                        onTap: () => _setIcon(option.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.supported,
    required this.currentIcon,
    required this.availableIcons,
    required this.error,
  });

  final bool supported;
  final String? currentIcon;
  final List<String> availableIcons;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLabel = currentIcon ?? 'default';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  supported ? Icons.verified_outlined : Icons.info_outline,
                  color: supported
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Text(
                  supported
                      ? 'Plataforma compatible'
                      : 'Iconos dinámicos no disponibles aquí',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Icono activo: $currentLabel'),
            if (availableIcons.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Descubiertos: ${availableIcons.join(', ')}'),
            ],
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconCard extends StatelessWidget {
  const _IconCard({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final IconOption option;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(option.assetPath, width: 64, height: 64),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      option.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
