sealed class ListViewDataSourceItemType<SECTION, ITEM> {}

class ListViewDataSourceItemSectionHeader<SECTION, ITEM>
    extends ListViewDataSourceItemType<SECTION, ITEM> {
  ListViewDataSourceItemSectionHeader(this.section, this.sectionIndex);

  final SECTION section;
  final int sectionIndex;
}

class ListViewDataSourceItem<SECTION, ITEM>
    extends ListViewDataSourceItemType<SECTION, ITEM> {
  ListViewDataSourceItem(
    this.section,
    this.item,
    this.sectionIndex,
    this.itemIndex,
  );

  final SECTION section;
  final ITEM item;
  final int sectionIndex;
  final int itemIndex;
}

class ListViewDataSourceItemSectionFooter<SECTION, ITEM>
    extends ListViewDataSourceItemType<SECTION, ITEM> {
  ListViewDataSourceItemSectionFooter(this.section, this.sectionIndex);

  final SECTION section;
  final int sectionIndex;
}
