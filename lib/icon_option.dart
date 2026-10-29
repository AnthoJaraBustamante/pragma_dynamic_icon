class IconOption {
  const IconOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  /// `null` restaura el icono por defecto del launcher.
  final String? id;
  final String title;
  final String subtitle;
  final String assetPath;

  static const List<IconOption> catalog = [
    IconOption(
      id: null,
      title: 'Predeterminado',
      subtitle: 'Identidad principal de la app',
      assetPath: 'assets/icons/default.png',
    ),
    IconOption(
      id: 'dark',
      title: 'Oscuro',
      subtitle: 'Variante para tema night / premium',
      assetPath: 'assets/icons/dark.png',
    ),
    IconOption(
      id: 'light',
      title: 'Claro',
      subtitle: 'Variante para campañas o temporada',
      assetPath: 'assets/icons/light.png',
    ),
  ];
}
