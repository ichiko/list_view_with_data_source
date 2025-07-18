import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:list_view_with_data_source/list_view_with_data_source.dart';

sealed class Task {
  const Task({
    required this.name,
    required this.isComplete,
  });

  final String name;
  final bool isComplete;
  String get type;
}

class DesktopTask extends Task {
  const DesktopTask({
    required super.name,
    required super.isComplete,
  });

  @override
  String get type => 'Desktop';
}

class HouseTask extends Task {
  const HouseTask({
    required super.name,
    required super.isComplete,
  });

  @override
  String get type => 'House';
}

sealed class Project {
  String get name;
  List<Task> get tasks;
}

class FamilyBirthday extends Project {
  @override
  String get name => 'family birthday';

  @override
  List<Task> get tasks => const [
        DesktopTask(name: 'Create guest list', isComplete: true),
        DesktopTask(name: 'Send invitations', isComplete: false),
        HouseTask(name: 'Clean living room', isComplete: false),
        HouseTask(name: 'Clean kitchen', isComplete: true),
        HouseTask(name: 'Decorate photos', isComplete: false)
      ];
}

class HandmadeSupportApp extends Project {
  @override
  String get name => 'handmade support app';

  @override
  List<Task> get tasks => const [
        DesktopTask(name: 'Create project', isComplete: true),
        DesktopTask(name: 'Create tasks', isComplete: true),
        DesktopTask(name: 'Create task list', isComplete: true),
        DesktopTask(name: 'Create task detail', isComplete: false),
        DesktopTask(name: 'Create task list item', isComplete: false),
        DesktopTask(name: 'Create task detail item', isComplete: false),
      ];
}

class ReformKitchen extends Project {
  @override
  String get name => 'reform kitchen';

  @override
  List<Task> get tasks => const [
        HouseTask(name: 'Plan new kitchen', isComplete: true),
        HouseTask(name: 'Install new kitchen', isComplete: true),
      ];
}

class ProjectSection extends Equatable {
  const ProjectSection({
    required this.project,
    required this.itemCount,
  });

  final Project project;
  final int itemCount;

  String get title => project.name;
  String get trailing =>
      '${project.tasks.where((task) => task.isComplete).length}/${project.tasks.length}';

  @override
  List<Object?> get props => [project, itemCount];
}

sealed class ProjectSectionItem {
  const ProjectSectionItem();
  String get title;
}

class TaskItem extends ProjectSectionItem {
  const TaskItem({
    required this.task,
  });

  final Task task;

  @override
  String get title => task.name;

  String get subtitle => task.type;
}

class EmptyItem extends ProjectSectionItem {
  const EmptyItem();

  @override
  String get title => 'No tasks';
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 174, 181, 232),
        ),
      ),
      home: const ProjectListScreen(),
    );
  }
}

typedef CustomDataSource
    = ListViewDataSource<ProjectSection, ProjectSectionItem>;

enum Filter {
  all,
  desktop,
  house,
  hideCompleted,
}

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final ProjectListModel _model = ProjectListModel([
    FamilyBirthday(),
    HandmadeSupportApp(),
    ReformKitchen(),
  ]);

  Filter _filter = Filter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView With Data Source Example'),
      ),
      body: ListViewWithDataSource(
        headerBuilder: (context) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.grey,
          child: Row(
            children: [
              const Text('Tasks filter:'),
              const SizedBox(width: 8),
              DropdownButton<Filter>(
                value: _filter,
                onChanged: (Filter? newValue) {
                  setState(() {
                    _filter = newValue!;
                  });
                },
                items:
                    Filter.values.map<DropdownMenuItem<Filter>>((Filter value) {
                  return DropdownMenuItem<Filter>(
                    value: value,
                    child: Text(
                      value.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        footerBuilder: (context) => const Padding(
          padding: EdgeInsets.all(32),
          child: Text('Footer'),
        ),
        dataSource: _model.dataSourceFor(_filter),
        itemBuilder: (context, section, item, sectionIndex, itemIndex) =>
            switch (item) {
          (final TaskItem item) => ListTile(
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: item.task.isComplete ? const Icon(Icons.check) : null,
            ),
          (final EmptyItem item) => ListTile(
              title: Text(item.title),
            ),
        },
        sectionHeaderBuilder: (context, section, sectionIndex) => ListTile(
          title: Text(
            section.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        sectionFooterBuilder: (context, section, sectionIndex) =>
            0 < section.itemCount
                ? Row(
                    children: [
                      const Spacer(),
                      Text(section.trailing),
                      const SizedBox(width: 16),
                    ],
                  )
                : null,
        itemSeparatorBuilder: (context, section, item, sectionIndex, itemIndex,
                {required bool insideSection}) =>
            const Divider(indent: 16),
        sectionSeparatorBuilder: (context, section, sectionIndex) =>
            const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Divider(),
        ),
      ),
    );
  }
}

class ProjectListModel {
  ProjectListModel(this.projects);

  final List<Project> projects;

  CustomDataSource dataSourceFor(
    Filter filter,
  ) {
    switch (filter) {
      case Filter.all:
        final dataSource = CustomDataSource();
        for (final project in projects) {
          dataSource.appendItems(
            ProjectSection(project: project, itemCount: project.tasks.length),
            project.tasks.map((e) => TaskItem(task: e)).toList(),
          );
        }
        return dataSource;
      case Filter.desktop:
        final dataSource = CustomDataSource();
        for (final project in projects) {
          final desktopTasks = project.tasks.whereType<DesktopTask>().toList();
          final section =
              ProjectSection(project: project, itemCount: desktopTasks.length);
          dataSource.addSection(section);
          if (desktopTasks.isNotEmpty) {
            dataSource.appendItems(
                section, desktopTasks.map((e) => TaskItem(task: e)).toList());
          } else {
            dataSource.appendItem(section, const EmptyItem());
          }
        }
        return dataSource;
      case Filter.house:
        final dataSource = CustomDataSource();
        for (final project in projects) {
          final houseTasks = project.tasks.whereType<HouseTask>().toList();
          final section =
              ProjectSection(project: project, itemCount: houseTasks.length);
          dataSource.addSection(section);
          if (houseTasks.isNotEmpty) {
            dataSource.appendItems(
                section, houseTasks.map((e) => TaskItem(task: e)).toList());
          } else {
            dataSource.appendItem(section, const EmptyItem());
          }
        }
        return dataSource;
      case Filter.hideCompleted:
        final dataSource = CustomDataSource();
        for (final project in projects) {
          final todo = project.tasks.where((e) => !e.isComplete).toList();
          final section =
              ProjectSection(project: project, itemCount: todo.length);
          dataSource.addSection(section);
          if (todo.isNotEmpty) {
            dataSource.appendItems(
                section, todo.map((e) => TaskItem(task: e)).toList());
          } else {
            dataSource.appendItem(section, const EmptyItem());
          }
        }
        return dataSource;
    }
  }
}
