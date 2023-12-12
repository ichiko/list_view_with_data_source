library list_view_with_data_source;

import 'package:flutter/material.dart';

import 'src/list_view_data_source.dart';
import 'src/list_view_data_source_item.dart';

export 'src/list_view_data_source.dart';

/// Build header widget used in [ListViewWithDataSource].
/// The widget will display at head of the [section].
/// If not needed, return null.
typedef SectionHeaderBuilder<SECTION> = Widget? Function(
  BuildContext context,
  SECTION section,
  int sectionIndex,
);

/// Build widget used in [ListViewWithDataSource],
/// which will display as [item] in [section].
typedef ItemBuilder<SECTION, ITEM> = Widget Function(
  BuildContext context,
  SECTION section,
  ITEM item,
  int sectionIndex,
  int itemIndex,
);

/// Build footer widget used in [ListViewWithDataSource].
/// The widget will display at foot of the [section].
/// If not needed, return null.
typedef SectionFooterBuilder<SECTION> = Widget? Function(
  BuildContext context,
  SECTION section,
  int sectionIndex,
);

/// Build separator widget used in [ListViewWithDataSource],
/// witch will display after the [item].
/// If [insideSection] is true, the widget displayed in between item views.
/// If [insideSection] is false, the widget displayed in between header and item
/// or between item and footer.
/// When [item] is null and [insideSection] is false, the widget displayed between
/// header and first item.
/// If not needed, return null.
typedef ItemSeparatorBuilder<SECTION, ITEM> = Widget? Function(
  BuildContext context,
  SECTION section,
  ITEM? item,
  int sectionIndex,
  int? itemIndex, {
  required bool insideSection,
});

/// Build separator between sections used in [ListViewWithDataSource].
/// If not needed, return null.
typedef SectionSeparatorBuilder<SECTION> = Widget? Function(
  BuildContext context,
  SECTION section,
  int sectionIndex,
);

/// Build list according to the [dataSource].
/// [dataSource] should be [ListViewDataSource] or its subclass.
final class ListViewWithDataSource<SECTION, ITEM> extends StatelessWidget {
  const ListViewWithDataSource({
    required this.dataSource,
    required this.itemBuilder,
    this.sectionHeaderBuilder,
    this.sectionFooterBuilder,
    this.itemSeparatorBuilder,
    this.sectionSeparatorBuilder,
    this.padding,
    this.shrinkWrap = false,
    super.key,
  });

  final ListViewDataSource<SECTION, ITEM> dataSource;

  final SectionHeaderBuilder<SECTION>? sectionHeaderBuilder;

  final ItemBuilder<SECTION, ITEM> itemBuilder;

  final SectionFooterBuilder<SECTION>? sectionFooterBuilder;

  final ItemSeparatorBuilder<SECTION, ITEM>? itemSeparatorBuilder;

  final SectionSeparatorBuilder<SECTION>? sectionSeparatorBuilder;

  /// Same as [ListView.padding].
  final EdgeInsetsGeometry? padding;

  /// Same as [ListView.shrinkWrap].
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemBuilder: (context, index) {
        final metaItem = dataSource.metaItem(index);
        return switch (metaItem) {
          (final ListViewDataSourceItemSectionHeader<SECTION, ITEM>
                headerItem) =>
            sectionHeaderBuilder?.call(
                  context,
                  headerItem.section,
                  headerItem.sectionIndex,
                ) ??
                const SizedBox.shrink(),
          (final ListViewDataSourceItem<SECTION, ITEM> item) => itemBuilder(
              context,
              item.section,
              item.item,
              item.sectionIndex,
              item.itemIndex,
            ),
          (final ListViewDataSourceItemSectionFooter<SECTION, ITEM>
                footerItem) =>
            sectionFooterBuilder?.call(
                  context,
                  footerItem.section,
                  footerItem.sectionIndex,
                ) ??
                const SizedBox.shrink(),
        };
      },
      separatorBuilder: (context, index) {
        final metaItem = dataSource.metaItem(index);
        final nextMetaItem = dataSource.nextMetaItem(index);
        return switch (metaItem) {
          (final ListViewDataSourceItemSectionHeader<SECTION, ITEM> item) =>
            nextMetaItem is ListViewDataSourceItem<SECTION, ITEM>
                ? itemSeparatorBuilder?.call(
                      context,
                      item.section,
                      null,
                      item.sectionIndex,
                      null,
                      insideSection: false,
                    ) ??
                    const SizedBox.shrink()
                : const SizedBox.shrink(),
          (final ListViewDataSourceItem<SECTION, ITEM> item) =>
            itemSeparatorBuilder?.call(
                  context,
                  item.section,
                  item.item,
                  item.sectionIndex,
                  item.itemIndex,
                  insideSection:
                      nextMetaItem is ListViewDataSourceItem<SECTION, ITEM>,
                ) ??
                const SizedBox.shrink(),
          (final ListViewDataSourceItemSectionFooter<SECTION, ITEM> item) =>
            sectionSeparatorBuilder?.call(
                  context,
                  item.section,
                  item.sectionIndex,
                ) ??
                const SizedBox.shrink(),
        };
      },
      itemCount: dataSource.listItemCount,
      shrinkWrap: shrinkWrap,
    );
  }
}
