import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_item.dart';

class TaskRepository {
  static const String _tasksKey = 'di_list_tasks';
  final SharedPreferences _prefs;

  TaskRepository(this._prefs);

  Future<List<TaskItem>> getTasks() async {
    try {
      final String? tasksJson = _prefs.getString(_tasksKey);
      if (tasksJson == null) return [];

      final List<dynamic> decodedList = jsonDecode(tasksJson);
      return decodedList
          .map((item) => TaskItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return empty list if data is corrupted to prevent app crash
      return [];
    }
  }

  Future<void> saveTasks(List<TaskItem> tasks) async {
    final List<Map<String, dynamic>> tasksMapList =
        tasks.map((task) => task.toJson()).toList();
    final String tasksJson = jsonEncode(tasksMapList);
    await _prefs.setString(_tasksKey, tasksJson);
  }
}
