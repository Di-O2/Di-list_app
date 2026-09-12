import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('ar'));
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NudgeApp()));
}

class NudgeApp extends ConsumerWidget {
  const NudgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Nudge',
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تطبيق Nudge' : 'Nudge App'),
        actions: [
          IconButton(
            tooltip: isArabic ? 'تغيير اللغة' : 'Change Language',
            icon: const Icon(Icons.language),
            onPressed: () {
              ref.read(localeProvider.notifier).state = isArabic
                  ? const Locale('en')
                  : const Locale('ar');
            },
          ),
          IconButton(
            tooltip: isArabic ? 'تغيير المظهر' : 'Toggle Theme',
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final currentMode = ref.read(themeModeProvider);
              ref
                  .read(themeModeProvider.notifier)
                  .state = currentMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'أهلاً بك في Nudge!' : 'Welcome to Nudge!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'تم بناء وتجميع التطبيق بنجاح'
                  : 'App built successfully',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
