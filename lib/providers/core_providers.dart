import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/task_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TaskRepository(prefs);
});
