import 'package:app_final_mobile/models/task.dart';

abstract class TasksState {
  TasksState();
}

class TasksInitial extends TasksState {
  TasksInitial();
}

class TasksLoading extends TasksState {
  TasksLoading();
}

class TasksLoaded extends TasksState {
  TasksLoaded({
    this.tasks,
  });

  final List<Task>? tasks;
}

class TasksEmpty extends TasksState {
  TasksEmpty();
}

class TasksFailure extends TasksState {
  TasksFailure();
}

class TasksSuccess extends TasksState {
  TasksSuccess();
}