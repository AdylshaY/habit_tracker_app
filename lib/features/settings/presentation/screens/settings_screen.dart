import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker_app/core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Appearance'),
          _ThemeSelectionTile(
            title: 'System Theme',
            subtitle: 'Follow system theme settings',
            isSelected: currentThemeMode == ThemeMode.system,
            onTap: () => _updateThemeMode(ref, ThemeMode.system),
            icon: Icons.brightness_auto,
          ),
          _ThemeSelectionTile(
            title: 'Light Theme',
            subtitle: 'Use light theme',
            isSelected: currentThemeMode == ThemeMode.light,
            onTap: () => _updateThemeMode(ref, ThemeMode.light),
            icon: Icons.brightness_5,
          ),
          _ThemeSelectionTile(
            title: 'Dark Theme',
            subtitle: 'Use dark theme',
            isSelected: currentThemeMode == ThemeMode.dark,
            onTap: () => _updateThemeMode(ref, ThemeMode.dark),
            icon: Icons.brightness_4,
          ),
          const Divider(),
          const _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  void _updateThemeMode(WidgetRef ref, ThemeMode mode) {
    ref.read(themeModeProvider.notifier).setThemeMode(mode);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ThemeSelectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const _ThemeSelectionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}
