import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final_mobile/models/task.dart';
import 'package:app_final_mobile/providers/tasks_provider.dart';
import 'package:app_final_mobile/providers/tasks_state.dart';
import 'package:app_final_mobile/pages/task_edit.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocumentosView();
  }
}

class DocumentosView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: <Widget>[
          // desativar o botao de excluir todas as Tarefas se nao ha Tarefas
          state is TasksEmpty
              ? IconButton(
                  onPressed: null,
                  icon: Icon(Icons.clear_all),
                )
              : IconButton(
                  icon: Icon(Icons.clear_all),
                  onPressed: () {
                    // excluir todas as Tarefas
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Excluir todas as tarefas'),
                        content: const Text('Confirmar?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(tasksProvider.notifier).excluirTarefas();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                  content: Text('Tarefas excluídas com sucesso'),
                                ));
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
      body: _Content(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskEditPage(task: null)),
          );
        },
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);
    if (state is TasksInitial) {
      return SizedBox();
    } else if (state is TasksLoading) {
      return Center(child: const CircularProgressIndicator());
    } else if (state is TasksEmpty) {
      return const Center(
        child: Text('Não há tarefas. Clique no botão abaixo para cadastrar.'),
      );
    } else if (state is TasksLoaded) {
      return _TasksList(state.tasks);
    } else {
      return Text('Erro ao buscar tarefas.');
    }
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList(
    List<Task>? this.tasks, {
    Key? key,
  }) : super(key: key);
  final tasks;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final task in tasks) ...[
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(task.title),
              subtitle: Text(
                '${task.content}',
              ),
              trailing: Wrap(children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskEditPage(task: task)),
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // excluir Tarefa atraves do id
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Excluir tarefa'),
                          content: const Text('Confirmar?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            Consumer(builder: (context, ref, _) {
                              return TextButton(
                                onPressed: () {
                                  ref
                                      .read(tasksProvider.notifier)
                                      .excluirTarefa(task.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      content:
                                          Text('Tarefa excluída com sucesso'),
                                    ));
                                },
                                child: const Text('OK'),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}