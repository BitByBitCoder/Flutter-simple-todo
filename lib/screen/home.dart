import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rest/controller/todoController.dart';
import 'package:rest/model/todomodel.dart';
import 'package:rest/screen/submitForm.dart';

class Home extends ConsumerWidget {
  const Home({super.key});
//fff
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todoControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Simple Todo App'),
            Container(
              child: Text(
                'beta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: Colors.amber,
            )
          ],
        ),
      ),
      body: data.when(
          data: (data) => data.isEmpty
              ? Center(
                  child: Text(
                    'Task add rawh le a ruak talt mai \n A hnuai sir dinglam a + buttun khu hmet la add rawh le',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text('${index + 1}'),
                      title: Text('${data[index].title}'),
                      subtitle: Text('${data[index].description}'),
                      trailing: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                ref
                                    .read(todoControllerProvider.notifier)
                                    .delete(data[index].id, ref, context);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    );
                  }),
          error: ((error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$error'),
            ));
          }),
          loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text('load mek e ')],
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TodoForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
