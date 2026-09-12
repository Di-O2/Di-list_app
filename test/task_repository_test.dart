import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nudge_app/models/task_item.dart';
import 'package:nudge_app/repositories/task_repository.dart';

void main() {
  group('TaskRepository Tests', () {
    test('getTasks returns empty list when no data is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = TaskRepository(prefs);

      final tasks = await repository.getTasks();
      expect(tasks, isEmpty);
    });

    test('saveTasks and getTasks work correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = TaskRepository(prefs);

      final task = TaskItem(
        id: '1',
        title: 'Test Storage',
        createdAt: DateTime(2026, 9, 12),
      );

      await repository.saveTasks([task]);
      final fetchedTasks = await repository.getTasks();

      expect(fetchedTasks.length, 1);
      expect(fetchedTasks.first.id, '1');
      expect(fetchedTasks.first.title, 'Test Storage');
    });

    test('getTasks handles corrupted data gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'di_list_tasks': 'invalid_json_string_that_causes_error',
      });
      final prefs = await SharedPreferences.getInstance();
      final repository = TaskRepository(prefs);

      final tasks = await repository.getTasks();
      expect(tasks, isEmpty); // Should catch the error and return []
    });
  });
}
