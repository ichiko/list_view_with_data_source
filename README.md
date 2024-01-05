# list_view_with_data_source

[![Pub Version](https://img.shields.io/pub/v/list_view_with_data_source)](https://pub.dev/packages/list_view_with_data_source)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/ichiko/list_view_with_data_source/ci.yml)

A Flutter `ListView` in which list items, header, footer and separators build from section and item structured in DataSource.

## About

This package abstracts the construction of elements to be displayed in a ListView, making it easier to manage. It's useful when arranging a variable number of multiple types of items. Also, by grouping elements with the concept of Sections, you can display different separators for each group and freely insert headers/footers.

It's inspired by `UICollectionViewDataSource` from UIKit.

The differences from [grouped_list](https://pub.dev/packages/grouped_list), which makes it easy to build groups from data, are as follows:

- By not automating group construction, it can express more complex switches
- Headers/footers/group separator Widgets can be set individually
- By separating the display structure and Widget construction, the structure itself can be verified

## Example

This is an example of changing the items displayed based on the number of data entries per group.

The full text of this sample can be seen in `example/lib/main/dart`.

1. Add the package to your pubspec.yaml:
   ```
   list_view_with_data_source: ^1.0.0
   ```
1. define the Sections and Items to be stored in the DataSource. It's a good idea to match these with the types of Views.
  ```
  class ProjectSection extends Equatable {
    const ProjectSection({
      required this.project,
      required this.itemCount,
    });

    final Project project;
    final int itemCount;

    ...
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
  ```
2. Next, according to the data, fill the prepared Sections and Items into the `ListViewDataSource`.
  ```
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
  ```
3. Place the `ListViewWithDataSource` Widget on the screen and start building the View.
  ```
  ListViewWithDataSource(
    dataSource: _model.dataSourceFor(_filter),
    itemBuilder:
        (context, section, item, sectionIndex, itemIndex) =>
            switch (item) {
      (final TaskItem item) => ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          trailing:
              item.task.isComplete ? const Icon(Icons.check) : null,
        ),
      (final EmptyItem item) => ListTile(
          title: Text(item.title),
        ),
    },
    itemSeparatorBuilder:
        (context, section, item, sectionIndex, itemIndex,
                {required bool insideSection}) =>
            const Divider(indent: 16),
  );
  ```
