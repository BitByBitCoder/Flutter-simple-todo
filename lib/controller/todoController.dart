import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rest/model/todomodel.dart';
import 'package:rest/repository/TodoRepository.dart';

final todoControllerProvider =
    StateNotifierProvider<TodoController, AsyncValue<List<TodoItem>>>((ref) {
  final todorepo = ref.watch(repositoryProvider);
  return TodoController(todorepo);
});

class TodoController extends StateNotifier<AsyncValue<List<TodoItem>>> {
  TodoRepository todoRepository;

  TodoController(this.todoRepository) : super(AsyncValue.loading()) {
    fetch();
  }

  fetch() async {
    final result = await todoRepository.fetch();
    state = AsyncData(result);
  }

  post(titleController, descriptionController, WidgetRef ref,
      BuildContext context) async {
    final result =
        await todoRepository.postData(titleController, descriptionController);
    ref.watch(todoControllerProvider.notifier).fetch();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Todo submitted successfully!'),
      ),
    );
  }

  delete(id, WidgetRef ref, BuildContext context) async {
    final result = await todoRepository.delete(id);
    ref.watch(todoControllerProvider.notifier).fetch();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Todo delete successfully!'),
      ),
    );
  }
}
