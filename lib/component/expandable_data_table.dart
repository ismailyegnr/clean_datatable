import 'package:clear_datatable/component/utility/sort_operations.dart';
import 'package:flutter/material.dart';

import 'extension/context_extension.dart';
import 'extension/sort_extension.dart';
import 'model/cell_item.dart';
import 'model/expandable_column.dart';
import 'model/expandable_row.dart';
import 'model/sortable_row.dart';
import 'widget/expansion_tile.dart' as custom_tile;
import 'utility/sort_information.dart';
import 'widget/edit_dialog.dart';
import 'widget/page_selector.dart';
import 'widget/table_header.dart';

class ExpandableDataTable extends StatefulWidget {
  /// The data of rows
  final List<ExpandableRow> rows;

  /// Headers row generates the header row of the datatable. Header's columns data
  /// creates a template for all rows.
  final List<ExpandableColumn> headers;

  /// This determines how many columns will appear for that build and the data
  /// for the remaining columns are stored in the expansion widget.
  ///
  /// This parameter can be work compatible with [LayoutBuilder].
  ///
  /// ```dart
  /// return LayoutBuilder(
  ///   builder: (context, constraints) {
  ///     int visibleCount = 3;
  ///     if (constraints.maxWidth < 600) {
  ///       visibleCount = 3;
  ///     } else if (constraints.maxWidth < 800) {
  ///       visibleCount = 4;
  ///     } else if (constraints.maxWidth < 1000) {
  ///       visibleCount = 5;
  ///     } else {
  ///       visibleCount = 6;
  ///     }
  ///
  ///     return ExpandableDataTable(
  ///       visibleColumnCount: visibleCount,
  ///       ...
  ///     );
  /// ```
  ///
  final int visibleColumnCount;

  /// Triggers when a row is edited with [ExpandableEditDialog].
  ///
  /// Returns the new [ExpandableRow] data.`
  final Function(ExpandableRow newRow) onRowChanged;

  /// This determines whether to enable the multi-extension feature.
  ///
  /// Default value is [true].
  ///
  /// If this value is false. Only one row will be expanded at the same time.
  final bool enableMultiExpansion;

  /// Specifies the number of rows to be used on a single page.
  ///
  /// It defaults to 10.
  final int pageSize;

  ExpandableDataTable({
    Key? key,
    required this.rows,
    required this.headers,
    required this.onRowChanged,
    required this.visibleColumnCount,
    this.enableMultiExpansion = true,
    this.pageSize = 10,
  })  : assert(visibleColumnCount > 0),
        assert(
          rows.isNotEmpty ? headers.length == rows.first.cells.length : true,
        ),
        super(key: key);

  @override
  State<ExpandableDataTable> createState() => _ExpandableDataTableState();
}

class _ExpandableDataTableState extends State<ExpandableDataTable> {
  List<GlobalKey<custom_tile.ExpansionTileState>>? _keys;
  List<ExpandableColumn> headerRow = [];

  /// Stores the sorted state data of the data table.
  ///
  /// This helps for building.
  List<List<SortableRow>> twoDimensionSortedRows = [];

  /// Indicates the index of the expanded single row in a page,
  ///
  /// This is only used if [enableMultiExpansion] is false.
  int? selectedRow;

  int _totalPageCount = 0;

  int _currentPage = 0;

  final SortOperations _sortOperations = SortOperations();

  List<ExpandableRow> get originalRows => widget.rows;

  late double trailingWidth;

  @override
  void initState() {
    super.initState();

    _composeRowsList(originalRows, isInit: true);

    if (!widget.enableMultiExpansion) {
      selectedRow = -1;

      _keys = [];

      for (int i = 0; i < widget.pageSize; i++) {
        _keys!.add(GlobalKey<custom_tile.ExpansionTileState>());
      }
    }
  }

  @override
  void didChangeDependencies() {
    trailingWidth = context.dynamicWidth(0.15);

    super.didChangeDependencies();
  }

  void _composeRowsList(List<dynamic> list, {bool isInit = false}) {
    _totalPageCount = 0;
    twoDimensionSortedRows = [];

    for (int i = 0; i < list.length; i++) {
      if (i % widget.pageSize == 0) {
        _totalPageCount++;
        twoDimensionSortedRows.add([]);
      }

      twoDimensionSortedRows[_totalPageCount - 1].add(
        isInit ? SortableRow(i, row: list[i]) : list[i],
      );
    }
  }

  void _expandedChanged(bool val, int index) {
    if (widget.enableMultiExpansion == false) {
      if (val) {
        if (selectedRow != -1) {
          if (_keys![selectedRow!].currentState != null) {
            _keys![selectedRow!].currentState!.handleTap();
          }
        }
        selectedRow = index;
        setState(() {});
      } else {
        setState(() {
          selectedRow = -1;
        });
      }
    }
  }

  /// Handles the row data by, loading shownCells and unshownBodyCells lists for
  /// expansion tiles.
  void _handleRowData(
    List<String> shownRowNames,
    ExpandableRow rowData,
    List<CellItem> shownCells,
    List<CellItem> unshownBodyCells,
  ) {
    for (var element in rowData.cells) {
      if (shownRowNames.contains(element.columnTitle)) {
        int headerInd = headerRow
            .indexWhere((val) => val.columnTitle == element.columnTitle);

        shownCells.add(
          CellItem(
              columnName: element.columnTitle,
              value: element.value,
              flex: headerRow[headerInd].columnFlex),
        );
      } else {
        unshownBodyCells.add(
          CellItem(
            columnName: element.columnTitle,
            value: element.value,
          ),
        );
      }
    }
  }

  void _sortAllRows(ExpandableColumn column) {
    ///Resets the page and go back to first page.
    _currentPage = 0;

    List<SortableRow> tempSortArray =
        _sortOperations.sortAllRows(column, twoDimensionSortedRows);

    _composeRowsList(tempSortArray);

    setState(() {});
  }

  void pageChanged(int newPage) {
    /// Close expanded rows while page is changing.
    if (_keys != null && selectedRow != -1) {
      _keys![selectedRow!].currentState?.handleTap();
      selectedRow = -1;
    }

    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        Expanded(
          child: buildRows(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.lowValue),
          child: PageSelector(
            currentPage: _currentPage,
            totalPageCount: _totalPageCount,
            onPageChange: (value) => pageChanged(value),
          ),
        )
      ],
    );
  }

  Widget buildRows() {
    List<String> shownRowNames = [];

    for (var element in headerRow) {
      shownRowNames.add(element.columnTitle);
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: twoDimensionSortedRows.isNotEmpty
            ? twoDimensionSortedRows[_currentPage].length
            : 0,
        itemBuilder: (context, index) {
          //gets current index value of sorted data list
          ExpandableRow rowData =
              twoDimensionSortedRows[_currentPage].elementAt(index).row;

          List<CellItem> unshownBodyCells = [];

          List<CellItem> shownCells = [];

          _handleRowData(shownRowNames, rowData, shownCells, unshownBodyCells);

          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: context.expandableTheme.rowsBorder,
              ),
            ),
            child: Theme(
              data: ThemeData().copyWith(
                dividerColor: context.expandableTheme.expandedBorderColor,
              ),
              child: custom_tile.ExpansionTile(
                key: _keys != null ? _keys![index] : UniqueKey(),
                showExpansionIcon: unshownBodyCells.isNotEmpty,
                expansionIcon: context.expandableTheme.expansionIcon,
                collapsedBackgroundColor: context.expandableTheme.rowsColor,
                backgroundColor: context.expandableTheme.rowsColor,
                trailingWidth: trailingWidth,
                secondTrailing: buildEditButton(context, index),
                title: buildRowTitleContent(shownCells),
                onExpansionChanged: (val) => _expandedChanged(val, index),
                childrenPadding:
                    EdgeInsets.symmetric(vertical: context.lowValue),
                children: buildExpansionContent(context, unshownBodyCells),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeader() {
    if (widget.headers.isNotEmpty) {
      headerRow = widget.headers.sublist(0, widget.visibleColumnCount);
    }

    return TableHeader(
      headerRow: headerRow,
      currentSort: _sortOperations.sortInformation,
      onTitleTap: _sortAllRows,
      trailingWidth: trailingWidth,
    );
  }

  Widget buildRowTitleContent(List<CellItem> shownCells) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValue),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: shownCells
            .map(
              (e) => Expanded(
                flex: e.flex!,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: context.dynamicWidth(0.02),
                  ),
                  child: Text(
                    e.value.toString(),
                    style: context.expandableTheme.rowsTextStyle,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> buildExpansionContent(
    BuildContext context,
    List<CellItem> unshownBodyCells,
  ) {
    if (unshownBodyCells.isEmpty) {
      return [];
    }

    return unshownBodyCells.map(
      (e) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.normalValue,
            vertical: context.lowValue,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "${e.columnName}:",
                    style: context.expandableTheme.expandedTextStyle,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    "${e.value}",
                    style: context.expandableTheme.expandedTextStyle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  Widget buildEditButton(BuildContext context, int rowInd) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: context.expandableTheme.editIcon,
      onPressed: () => buildShowDialog(context, rowInd),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context, int rowInd) {
    return showDialog(
      context: context,
      builder: (context) => EditDialog(
        row: twoDimensionSortedRows[_currentPage][rowInd],
        onSuccess: (newRow) {
          twoDimensionSortedRows[_currentPage][rowInd] = newRow;

          widget.onRowChanged(newRow.row);

          setState(() {});
        },
      ),
    );
  }
}
