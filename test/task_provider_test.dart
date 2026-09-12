import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nudge_app/providers/core_providers.dart';
import 'package:nudge_app/providers/task_provider.dart';

void main() {
  test('TaskNotifier loads, adds, and toggles tasks correctly', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    // Wait for the initial load to complete inside the notifier
    await container.read(tasksProvider.notifier).loadTasks();

    final initialState = container.read(tasksProvider);
    expect(initialState.value, isEmpty);

    // Add task
    await container.read(tasksProvider.notifier).addTask('New Task Test');
    final tasksAfterAdd = container.read(tasksProvider).value!;
    expect(tasksAfterAdd.length, 1);
    expect(tasksAfterAdd.first.title, 'New Task Test');
    expect(tasksAfterAdd.first.isCompleted, false);

    // Toggle completion
    final taskId = tasksAfterAdd.first.id;
    await container.read(tasksProvider.notifier).toggleTaskCompletion(taskId);
    final tasksAfterToggle = container.read(tasksProvider).value!;
    expect(tasksAfterToggle.first.isCompleted, true);
  });
}
