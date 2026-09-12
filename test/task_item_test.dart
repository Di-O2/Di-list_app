import 'package:flutter_test/flutter_test.dart';
import 'package:nudge_app/models/task_item.dart';

void main() {
  group('TaskItem Tests', () {
    test('toJson and fromJson work correctly', () {
      final date = DateTime(2026, 9, 12);
      final task = TaskItem(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: true,
        createdAt: date,
        dueDate: date,
      );

      final json = task.toJson();
      final newTask = TaskItem.fromJson(json);

      expect(newTask.id, '1');
      expect(newTask.title, 'Test Task');
      expect(newTask.description, 'Test Description');
      expect(newTask.isCompleted, true);
      expect(newTask.createdAt, date);
      expect(newTask.dueDate, date);
    });

    test('copyWith updates fields correctly', () {
      final task = TaskItem(
        id: '1',
        title: 'Old Title',
        createdAt: DateTime.now(),
      );

      final updatedTask = task.copyWith(title: 'New Title', isCompleted: true);

      expect(updatedTask.id, '1');
      expect(updatedTask.title, 'New Title');
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.createdAt, task.createdAt);
    });
  });
}
