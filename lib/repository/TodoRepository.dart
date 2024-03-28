import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rest/model/todomodel.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart ' as http;

final repositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository();
});

class TodoRepository {
  Future<List<TodoItem>> fetch() async {
    const url = "https://api.nstack.in/v1/todos";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = convert.jsonDecode(response.body);
        List<dynamic> data = result['items'];
        return data.map((e) => TodoItem.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error fetching data: $e');
      return []; // Return an empty list or throw an error based on your requirements
    }
  }

  Future<void> postData(TextEditingController titleController,
      TextEditingController descriptionController) async {
    String url = 'https://api.nstack.in/v1/todos';
    print('${titleController.text}');

    Map<String, dynamic> postData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'is_completed': false,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    String jsonString = convert.jsonEncode(postData);

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonString,
      );

      if (response.statusCode == 201) {
        print('Todo created successfully!');
      } else {
        print('Failed to create todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /////todo delete
  Future<void> delete(id) async {
    String url = 'https://api.nstack.in/v1/todos/$id';

    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 204) {
        print('Todo deleted successfully!');
      } else {
        print('Failed to delete todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
