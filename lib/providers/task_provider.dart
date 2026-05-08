import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_flutter/api_service.dart';
import 'package:project_flutter/models/task_model.dart';

final tasksProvider = StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  TaskNotifier() : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final List<dynamic> data = await ApiService.getTasks();
      final tasks = data.map((item) => Task.fromJson(item)).toList();
      state = AsyncValue.data(tasks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTask(String title, String priority, DateTime? dueDate) async {
    try {
      await ApiService.createTask(title, priority, dueDate?.toIso8601String());
      await loadTasks();
    } catch (e, stack) {
      // Potentially log error or notify UI
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleTask(String id) async {
    try {
      await ApiService.toggleTask(id);
      await loadTasks();
    } catch (e) {
      // Silently fail or handle error
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await ApiService.deleteTask(id);
      await loadTasks();
    } catch (e) {
      // Handle error
    }
  }

  // Statistics
  double getCompletionPercentage(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.isDone).length;
    return (completed / tasks.length) * 100;
  }

  int getCompletedCount(List<Task> tasks) {
    return tasks.where((t) => t.isDone).length;
  }

  int getDailyStreak(List<Task> tasks) {
    // Placeholder for streak logic
    return 5;
  }
}

final searchQueryProvider = StateProvider<String>((ref) => "");
final filterPriorityProvider = StateProvider<String?>((ref) => null);

final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(tasksProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final priority = ref.watch(filterPriorityProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where((task) {
      final matchesQuery = task.title.toLowerCase().contains(query);
      final matchesPriority = priority == null || task.priority == priority;
      return matchesQuery && matchesPriority;
    }).toList();
  });
});
