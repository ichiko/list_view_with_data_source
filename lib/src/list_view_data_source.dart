import 'dart:collection';

import 'list_view_data_source_item.dart';

/// DataSource for ListViewWithDataSource.
/// Hold display items for each section groups.
class ListViewDataSource<SECTION, ITEM> {
  final LinkedHashMap<SECTION, List<ITEM>> _sections =
      LinkedHashMap<SECTION, List<ITEM>>();

  /// Add section to the end of the list, if not exists.
  /// If already exists, do nothing.
  void addSection(SECTION section) {
    if (!_sections.containsKey(section)) {
      _sections[section] = [];
      _applyToMetaItems();
    }
  }

  /// Add item to the end of the section's item list.
  /// If section not exists, create new section.
  /// If section already exists, same section will be merged.
  void appendItem(SECTION section, ITEM item) {
    appendItems(section, [item]);
  }

  /// Add items to the end of the section's item list.
  /// If section not exists, create new section.
  /// If section already exists, same section will be merged.
  void appendItems(SECTION section, List<ITEM> items) {
    if (_sections.containsKey(section)) {
      _sections[section]!.addAll(items);
    } else {
      _sections[section] = items;
    }
    _applyToMetaItems();
  }

  final List<ListViewDataSourceItemType<SECTION, ITEM>> _metaItems = [];

  void _applyToMetaItems() {
    _metaItems.clear();
    for (var sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
      final section = sections[sectionIndex];
      final items = sectionItems(section);
      if (items.isEmpty) {
        continue;
      }
      _metaItems.add(
        ListViewDataSourceItemSectionHeader(section, sectionIndex),
      );
      for (var itemIndex = 0; itemIndex < items.length; itemIndex++) {
        final item = items[itemIndex];
        _metaItems.add(
          ListViewDataSourceItem(section, item, sectionIndex, itemIndex),
        );
      }
      _metaItems.add(
        ListViewDataSourceItemSectionFooter(section, sectionIndex),
      );
    }
  }

  List<SECTION> get sections => _sections.keys.toList();

  List<ITEM> sectionItems(SECTION section) {
    return _sections[section] ?? [];
  }

  int get listItemCount => _metaItems.length;

  ListViewDataSourceItemType<SECTION, ITEM> metaItem(int index) {
    return _metaItems[index];
  }

  ListViewDataSourceItemType<SECTION, ITEM>? nextMetaItem(int index) {
    return index < listItemCount - 1 ? metaItem(index + 1) : null;
  }
}
