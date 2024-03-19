import 'package:basicstatemanagement_makingappstatevisibleacrossmultiplescreens/plan_provider.dart';

import '../models/data_layer.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  Plan plan;
  PlanScreen({super.key, required this.plan});
  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  Plan get plan => widget.plan;
  /*
  widget. allows us to access the contents of the actual widget from the widgets state
  In this case, "widget." is PlanScreen, but this can be used with any stateful widget
   */
  set plan(Plan newPlan) {
    widget.plan = newPlan;
  }
  /*
  Added a setter so that the plan field may be changed (like in addTaskButton)
   */

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  Widget _buildAddTaskButton() {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Plan currentPlan = plan;
        int planIndex =
            planNotifier.value.indexWhere((p) => p.name == currentPlan.name);

        List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
          ..add(const Task());

        planNotifier.value = List<Plan>.from(planNotifier.value)
          ..[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );
        plan = Plan(
          name: currentPlan.name,
          tasks: updatedTasks,
        );
      },
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
          value: task.complete,
          onChanged: (selected) {
            Plan currentPlan = plan;
            int planIndex = planNotifier.value
                .indexWhere((p) => p.name == currentPlan.name);

            planNotifier.value = List<Plan>.from(planNotifier.value)
              ..[planIndex] = Plan(
                name: currentPlan.name,
                tasks: List<Task>.from(currentPlan.tasks)
                  ..[index] = Task(
                    description: task.description,
                    complete: selected ?? false,
                  ),
              );
          }),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          Plan currentPlan = plan;
          int planIndex =
              planNotifier.value.indexWhere((p) => p.name == currentPlan.name);

          /*
          planNotifier.value = List<Plan>.from(currentPlan.tasks)
            ..[planIndex] = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: text,
                  complete: task.complete,
                ),
            );
            //Old code, does not work
          */
          List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
            ..[index] = Task(
              description: text,
              complete: task.complete,
            );
          Plan updatedPlan = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = updatedPlan;
          plan = updatedPlan;
        },
      ),
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) => _buildTaskTile(plan.tasks[index], index),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Master Plan')),
      body: ValueListenableBuilder<List<Plan>>(
          valueListenable: plansNotifier,
          builder: (context, plans, child) {
            Plan currentPlan = plans.firstWhere((p) => p.name == plan.name);
            //returns the first plan in Plan List (ValueListenableBuilder<List<Plan>>) that matches plan.name
            return Column(
              children: [
                Expanded(child: _buildList(currentPlan)),
                SafeArea(child: Text(currentPlan.completenessMessage))
              ],
            );
          }),
      floatingActionButton: _buildAddTaskButton(),
    );
  }
}
