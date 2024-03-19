import 'package:basicstatemanagement_makingappstatevisibleacrossmultiplescreens/models/plan.dart';
import 'package:basicstatemanagement_makingappstatevisibleacrossmultiplescreens/plan_provider.dart';
import 'package:basicstatemanagement_makingappstatevisibleacrossmultiplescreens/views/plan_creator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlanProvider(
      notifier: ValueNotifier<List<Plan>>(const []),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const PlanCreatorScreen(),
      ),
    );
  }
}

/*
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: PlanProvider(
        notifier: ValueNotifier<List<Plan>>(const []),
        child: const PlanCreatorScreen(),
      ),
    );
  }
}
 */