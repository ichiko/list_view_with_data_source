import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_view_with_data_source/list_view_with_data_source.dart';

enum MyFavoriteCategory {
  fruits,
  instruments,
}

enum MyFavoriteItems {
  apple,
  banana,
  orange,
  guitar,
  piano,
  violin,
}

void main() {
  Widget buildAppWithAllView(
    ListViewDataSource<MyFavoriteCategory, MyFavoriteItems> dataSource,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: ListViewWithDataSource<MyFavoriteCategory, MyFavoriteItems>(
          dataSource: dataSource,
          sectionHeaderBuilder: (context, section, sectionIndex) {
            return Text('Header of section: $section');
          },
          itemBuilder: (context, section, item, sectionIndex, itemIndex) {
            return Text('Item: $item');
          },
          sectionFooterBuilder: (context, section, sectionIndex) {
            return Text('Footer of section: $section');
          },
          itemSeparatorBuilder:
              (context, section, item, sectionIndex, itemIndex,
                  {required insideSection}) {
            return const Divider(indent: 16, endIndent: 16);
          },
          sectionSeparatorBuilder: (context, section, sectionIndex) {
            return const Divider();
          },
        ),
      ),
    );
  }

  Widget buildAppWithSectionHeaderAndItem(
    ListViewDataSource<MyFavoriteCategory, MyFavoriteItems> dataSource,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: ListViewWithDataSource<MyFavoriteCategory, MyFavoriteItems>(
          dataSource: dataSource,
          sectionHeaderBuilder: (context, section, sectionIndex) {
            return Text('Header of section: $section');
          },
          itemBuilder: (context, section, item, sectionIndex, itemIndex) {
            return Text('Item: $item');
          },
        ),
      ),
    );
  }

  Widget buildAppWithFruitsHeaderAndInstrumentsFooter(
    ListViewDataSource<MyFavoriteCategory, MyFavoriteItems> dataSource,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: ListViewWithDataSource<MyFavoriteCategory, MyFavoriteItems>(
          dataSource: dataSource,
          sectionHeaderBuilder: (context, section, sectionIndex) {
            if (section == MyFavoriteCategory.fruits) {
              return Text('Header of section: $section');
            }
            return null;
          },
          itemBuilder: (context, section, item, sectionIndex, itemIndex) {
            return Text('Item: $item');
          },
          sectionFooterBuilder: (context, section, sectionIndex) {
            if (section == MyFavoriteCategory.instruments) {
              return Text('Footer of section: $section');
            }
            return null;
          },
        ),
      ),
    );
  }

  testWidgets('Build section with items', (tester) async {
    final dataSource = ListViewDataSource<MyFavoriteCategory, MyFavoriteItems>()
      ..addSection(MyFavoriteCategory.fruits)
      ..appendItem(MyFavoriteCategory.fruits, MyFavoriteItems.apple);

    await tester.pumpWidget(buildAppWithAllView(dataSource));

    expect(find.text('Header of section: MyFavoriteCategory.fruits'),
        findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.apple'), findsOneWidget);
    expect(find.text('Footer of section: MyFavoriteCategory.fruits'),
        findsOneWidget);
  });

  testWidgets('Build sections with multiple items and build header and item',
      (tester) async {
    final dataSource = ListViewDataSource<MyFavoriteCategory, MyFavoriteItems>()
      ..addSection(MyFavoriteCategory.fruits)
      ..appendItems(
        MyFavoriteCategory.fruits,
        [MyFavoriteItems.apple, MyFavoriteItems.banana, MyFavoriteItems.orange],
      )
      ..addSection(MyFavoriteCategory.instruments)
      ..appendItems(MyFavoriteCategory.instruments, [MyFavoriteItems.guitar]);

    await tester.pumpWidget(buildAppWithSectionHeaderAndItem(dataSource));

    expect(find.text('Header of section: MyFavoriteCategory.fruits'),
        findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.apple'), findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.banana'), findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.orange'), findsOneWidget);
    expect(find.text('Footer of section: MyFavoriteCategory.fruits'),
        findsNothing);
    expect(find.text('Header of section: MyFavoriteCategory.instruments'),
        findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.guitar'), findsOneWidget);
    expect(find.text('Footer of section: MyFavoriteCategory.instruments'),
        findsNothing);
  });

  testWidgets(
      'Build sections with multiple items and build one of header and one of footer',
      (tester) async {
    final dataSource = ListViewDataSource<MyFavoriteCategory, MyFavoriteItems>()
      ..addSection(MyFavoriteCategory.fruits)
      ..appendItems(
        MyFavoriteCategory.fruits,
        [MyFavoriteItems.apple, MyFavoriteItems.banana, MyFavoriteItems.orange],
      )
      ..addSection(MyFavoriteCategory.instruments)
      ..appendItems(MyFavoriteCategory.instruments, [MyFavoriteItems.guitar]);

    await tester
        .pumpWidget(buildAppWithFruitsHeaderAndInstrumentsFooter(dataSource));

    expect(find.text('Header of section: MyFavoriteCategory.fruits'),
        findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.apple'), findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.banana'), findsOneWidget);
    expect(find.text('Item: MyFavoriteItems.orange'), findsOneWidget);
    expect(find.text('Footer of section: MyFavoriteCategory.fruits'),
        findsNothing);
    expect(find.text('Header of section: MyFavoriteCategory.instruments'),
        findsNothing);
    expect(find.text('Item: MyFavoriteItems.guitar'), findsOneWidget);
    expect(find.text('Footer of section: MyFavoriteCategory.instruments'),
        findsOneWidget);
  });
}
