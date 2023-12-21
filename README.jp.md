# list_view_with_data_source



A Flutter `ListView` in which list items, header, footer and separators build from section and item structured in DataSource.

## 概要

このパッケージは、ListViewに表示する要素の構築を抽象化し、管理しやすくするものです。複数の種類のアイテムを可変な個数で並べるときに便利です。
また、Section の概念で要素グルーピングすることで、グループごとに異なるセパレータを表示したり、ヘッダー/フッターを自由に挿入することができます。

UIKit の `UICollectionViewDataSource` の考え方を取り入れたものです。

データからグループの構築を簡単にできる [grouped_list](https://pub.dev/packages/grouped_list) との違いは、以下です。

- グループ構築を自動化しないことで、より複雑の切り替えを表現できる
- ヘッダー/フッター/グループのセパレータ Widget を個別に設定できる
- 表示の構造と Widget 構築を分離することで、構造自体の検証ができる

## 使い方

グループごとのデータ件数によって、表示する項目を変更する例です。

このサンプルの全文は、 `example/lib/main/dart` で見れます。

1. `pubspec.yaml` に以下を追加します。
   ```
   list_view_with_data_source: ^1.0.0
   ```
3. DataSourceに格納する、Section と Item を定義します。これはViewの種類に対応させるとよいでしょう。
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
2. 次にデータに応じて、用意した Section と Item を `ListViewDataSource` に詰めていきます。
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
3. `ListViewWithDataSource` Widget を screen に配置して、View を構築していきます。
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
