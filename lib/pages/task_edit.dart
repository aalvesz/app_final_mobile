import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final_mobile/models/task.dart';
import 'package:app_final_mobile/providers/tasks_provider.dart';
import 'package:app_final_mobile/providers/tasks_state.dart';
import 'package:app_final_mobile/providers/validator_provider.dart';
import 'package:app_final_mobile/providers/validator_state.dart';

class TaskEditPage extends StatelessWidget {
  const TaskEditPage({Key? key, this.task}) : super(key: key);
  final Task? task;
  @override
  Widget build(BuildContext context) {
    return TasksEditView(task);
  }
}

class TasksEditView extends ConsumerWidget {
  TasksEditView(
    this.task, {
    Key? key,
  }) : super(key: key);
  final Task? task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<TasksState>(tasksProvider,
        (TasksState? previousState, TasksState state) {
      if (state is TasksLoading) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            });
      }
      if (state is TasksSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('Operação realizada com sucesso'),
          ));

        Navigator.pop(context);
        ref.read(tasksProvider.notifier).buscarTarefas();
        Navigator.pop(context);
      }
      if (state is TasksFailure) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('Erro ao atualizar tarefa'),
          ));
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Tarefa',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffB81736), Color(0xff281737)])),
        ),
      ),
      body: _Content(task),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.task, {Key? key}) : super(key: key);
  final Task? task;
  @override
  Widget build(BuildContext context) {
    return _TaskForm(task);
  }
}

class _TaskForm extends StatelessWidget {
  _TaskForm(this.task, {Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final Task? task;
  @override
  Widget build(BuildContext context) {
    if (task == null) {
      _titleController.text = '';
      _contentController.text = '';
    } else {
      _titleController.text = task!.title.toString();
      _contentController.text = task!.content.toString();
    }
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer(builder: (context, ref, child) {
              final state = ref.watch(validatorProvider);
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                controller: _titleController,
                focusNode: _titleFocusNode,
                textInputAction: TextInputAction.next,
                onEditingComplete: _contentFocusNode.requestFocus,
                onChanged: (text) {
                  ref.read(validatorProvider.notifier).validaForm(
                      _titleController.text, _contentController.text);
                },
                onFieldSubmitted: (String value) {},
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (state is Validating) {
                    if (state.tituloMessage == '') {
                      return null;
                    } else {
                      return state.tituloMessage;
                    }
                  }
                },
              );
            }),
            Consumer(builder: (context, ref, child) {
              final state = ref.watch(validatorProvider);
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Conteúdo',
                ),
                controller: _contentController,
                focusNode: _contentFocusNode,
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  ref.read(validatorProvider.notifier).validaForm(
                      _titleController.text, _contentController.text);
                },
                onFieldSubmitted: (String value) {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    ref.read(tasksProvider.notifier).salvarTarefa(task?.id,
                        _titleController.text, _contentController.text);
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (state is Validating) {
                    if (state.conteudoMessage == '') {
                      return null;
                    } else {
                      return state.conteudoMessage;
                    }
                  }
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Consumer(builder: (context, ref, child) {
                  final state = ref.watch(validatorProvider);
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffB81736), Color(0xff281737)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: state is Validated
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                ref.read(tasksProvider.notifier).salvarTarefa(
                                    task?.id,
                                    _titleController.text,
                                    _contentController.text);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
