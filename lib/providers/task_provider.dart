import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_item.dart';
import '../repositories/task_repository.dart';
import 'core_providers.dart';

class TaskNotifier extends StateNotifier<AsyncValue<List<TaskItem>>> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      state = const AsyncValue.loading();
      final tasks = await _repository.getTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask(String title,
      {String? description, DateTime? dueDate}) async {
    final currentState = state.value ?? [];
    final newTask = TaskItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );

    final updatedTasks = [newTask, ...currentState];
    state = AsyncValue.data(updatedTasks);
    await _repository.saveTasks(updatedTasks);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final currentState = state.value ?? [];
    final updatedTasks = currentState.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();

    state = AsyncValue.data(updatedTasks);
    await _repository.saveTasks(updatedTasks);
  }
}

final tasksProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<List<TaskItem>>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});
