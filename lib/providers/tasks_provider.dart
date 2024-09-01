import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final_mobile/database/database_provider.dart';
import 'package:app_final_mobile/models/task.dart';
import 'package:app_final_mobile/providers/tasks_state.dart';

final databaseProvider = Provider((ref) => DatabaseProvider.instance);

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
    (ref) => TasksNotifier(ref));

class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier(this.ref)
      : _databaseProvider = ref.watch(databaseProvider),
        super(TasksInitial()) {
    buscarTarefas();
  }
  final Ref ref;
  final DatabaseProvider _databaseProvider;

  Future<void> buscarTarefas() async {
    state = TasksLoading();
    try {
      // a linha abaixo simula tempo de processamento no servidor e
      // serve para testar o circular indicator
      await Future.delayed(const Duration(seconds: 2));

      final tasks = await _databaseProvider.buscarTarefas();
      if (tasks.isEmpty) {
        state = TasksEmpty();
      } else {
        state = TasksLoaded(
          tasks: tasks,
        );
      }
    } catch (e) {
      state = TasksFailure();
      throw Exception();
    }
  }

  Future<void> salvarTarefa(int? id, String titulo, String conteudo) async {
    Task editTask = Task(id: id, title: titulo, content: conteudo);
    state = TasksLoading();
    try {
      // a linha abaixo simula tempo de processamento no servidor e
      // serve para testar o circular indicator
      await Future.delayed(const Duration(seconds: 2));
      if (id == null) {
        editTask = await _databaseProvider.save(editTask);
      } else {
        editTask = await _databaseProvider.update(editTask);
      }
      state = TasksSuccess();
    } on Exception {
      state = TasksFailure();
    }
  }

  //excluir tarefa atraves um id
  Future<void> excluirTarefa(id) async {
    state = TasksLoading();
    // a linha abaixo simula tempo de processamento no servidor e
    // serve para testar o circular indicator
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.delete(id);
      buscarTarefas();
    } on Exception {
      state = TasksFailure();
    }
  }

  //excluir todas as Tarefas
  Future<void> excluirTarefas() async {
    state = TasksLoading();
    // a linha abaixo simula tempo de processamento no servidor e
    // serve para testar o circular indicator
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.deleteAll();
      state = TasksEmpty();
    } on Exception {
      state = TasksFailure();
    }
  }
}