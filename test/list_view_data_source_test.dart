import 'package:flutter_test/flutter_test.dart';
import 'package:list_view_with_data_source/list_view_with_data_source.dart';

enum ExampleSection {
  fruits,
  instruments,
}

enum ExampleItems {
  apple,
  banana,
  orange,
  guitar,
  piano,
  violin,
}

void main() {
  test('Build section with item', () {
    final dataSource = ListViewDataSource<ExampleSection, ExampleItems>()
      ..addSection(ExampleSection.fruits)
      ..appendItem(ExampleSection.fruits, ExampleItems.apple);

    expect(dataSource.sections, [ExampleSection.fruits]);
    expect(
      dataSource.sectionItems(ExampleSection.fruits),
      [ExampleItems.apple],
    );
  });

  test('Build section with multiple items', () {
    final dataSource = ListViewDataSource<ExampleSection, ExampleItems>()
      ..addSection(ExampleSection.fruits)
      ..appendItems(
        ExampleSection.fruits,
        [ExampleItems.apple, ExampleItems.banana, ExampleItems.orange],
      );

    expect(dataSource.sections, [ExampleSection.fruits]);
    expect(
      dataSource.sectionItems(ExampleSection.fruits),
      [ExampleItems.apple, ExampleItems.banana, ExampleItems.orange],
    );
  });

  test('Build sections with items', () {
    final dataSource = ListViewDataSource<ExampleSection, ExampleItems>()
      ..addSection(ExampleSection.fruits)
      ..appendItems(
        ExampleSection.fruits,
        [ExampleItems.apple, ExampleItems.banana, ExampleItems.orange],
      )
      ..addSection(ExampleSection.instruments)
      ..appendItems(
        ExampleSection.instruments,
        [ExampleItems.guitar, ExampleItems.piano, ExampleItems.violin],
      );

    expect(
      dataSource.sections,
      [ExampleSection.fruits, ExampleSection.instruments],
    );
    expect(
      dataSource.sectionItems(ExampleSection.fruits),
      [ExampleItems.apple, ExampleItems.banana, ExampleItems.orange],
    );
    expect(
      dataSource.sectionItems(ExampleSection.instruments),
      [ExampleItems.guitar, ExampleItems.piano, ExampleItems.violin],
    );
  });

  test('Append items repeatedly', () {
    final dataSource = ListViewDataSource<ExampleSection, ExampleItems>()
      ..appendItems(
        ExampleSection.fruits,
        [
          ExampleItems.apple,
          ExampleItems.banana,
        ],
      )
      ..appendItems(
        ExampleSection.fruits,
        [ExampleItems.orange],
      );

    expect(dataSource.sections, [ExampleSection.fruits]);
    expect(
      dataSource.sectionItems(ExampleSection.fruits),
      [ExampleItems.apple, ExampleItems.banana, ExampleItems.orange],
    );
  });
}
