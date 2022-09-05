import 'package:flutter/material.dart';

import 'extension/context_extension.dart';
import 'model/cell_item.dart';
import 'model/expandable_column.dart';
import 'model/expandable_row.dart';
import 'model/sortable_row.dart';
import 'utility/sort_operations.dart';
import 'widget/custom_expansion_tile.dart' as custom_tile;
import 'widget/edit_dialog.dart';
import 'widget/expansion_container.dart';
import 'widget/pagination_widget.dart';
import 'widget/table_header.dart';
import 'widget/title_container.dart';

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

  /// Renders a custom edit dialog widget with two parameters.
  ///
  /// First parameter, row, gives the current selected row information.
  ///
  /// Second parameter, onSuccess, is a function and it must return a new
  /// [ExpandableRow] variable to update the value of the row inside the widget.
  final Widget Function(
    ExpandableRow row,
    Function(ExpandableRow newRow) onSuccess,
  )? editDialog;

  ExpandableDataTable({
    Key? key,
    required this.rows,
    required this.headers,
    required this.onRowChanged,
    required this.visibleColumnCount,
    this.enableMultiExpansion = true,
    this.pageSize = 10,
    this.editDialog,
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
  List<ExpandableColumn> _headerTitles = [];

  /// Stores the sorted state data of the data table.
  ///
  /// This helps for building.
  List<List<SortableRow>> _sortedRowsList = [];

  /// Indicates the index of the expanded single row in a page,
  ///
  /// This is only used if [enableMultiExpansion] is false.
  int? _expandedRowIndex;

  int _totalPageCount = 0;

  int _currentPage = 0;

  final SortOperations _sortOperations = SortOperations();

  late double _trailingWidth;

  int get pageLength =>
      _sortedRowsList.isNotEmpty ? _sortedRowsList[_currentPage].length : 0;

  @override
  void initState() {
    super.initState();

    _composeRowsList(widget.rows, isInit: true);

    if (!widget.enableMultiExpansion) {
      _expandedRowIndex = -1;

      _keys = [];

      for (int i = 0; i < widget.pageSize; i++) {
        _keys!.add(GlobalKey<custom_tile.ExpansionTileState>());
      }
    }
  }

  @override
  void didChangeDependencies() {
    _trailingWidth = context.dynamicWidth(0.15);

    super.didChangeDependencies();
  }

  /// Create or update two dimension sorted rows list
  void _composeRowsList(List<dynamic> list, {bool isInit = false}) {
    _totalPageCount = 0;
    _sortedRowsList = [];

    for (int i = 0; i < list.length; i++) {
      if (i % widget.pageSize == 0) {
        _totalPageCount++;
        _sortedRowsList.add([]);
      }

      _sortedRowsList[_totalPageCount - 1].add(
        isInit ? SortableRow(i, row: list[i]) : list[i],
      );
    }
  }

  void _onExpansionChange(bool val, int index) {
    if (widget.enableMultiExpansion == false) {
      if (val) {
        if (_expandedRowIndex != -1) {
          if (_keys![_expandedRowIndex!].currentState != null) {
            _keys![_expandedRowIndex!].currentState!.handleTap();
          }
        }
        _expandedRowIndex = index;
        setState(() {});
      } else {
        setState(() {
          _expandedRowIndex = -1;
        });
      }
    }
  }

  /// Handles the row data by, loading titleCells and expansionCells lists for
  /// expansion tiles.
  void _createRowCells(
    List<String> headerNames,
    ExpandableRow rowData,
    List<CellItem> titleCells,
    List<CellItem> expansionCells,
  ) {
    for (var element in rowData.cells) {
      if (headerNames.contains(element.columnTitle)) {
        int headerInd = _headerTitles
            .indexWhere((val) => val.columnTitle == element.columnTitle);

        titleCells.add(
          CellItem(
            columnName: element.columnTitle,
            value: element.value,
            flex: _headerTitles[headerInd].columnFlex,
          ),
        );
      } else {
        expansionCells.add(
          CellItem(
            columnName: element.columnTitle,
            value: element.value,
          ),
        );
      }
    }
  }

  /// Sort all rows.
  void _sortRows(ExpandableColumn column) {
    ///Resets the page and go back to first page.
    _currentPage = 0;

    List<SortableRow> tempSortArray =
        _sortOperations.sortAllRows(column, _sortedRowsList);

    _composeRowsList(tempSortArray);

    setState(() {});
  }

  /// Close expanded rows while page is changing.
  void _changePage(int newPage) {
    if (_keys != null && _expandedRowIndex != -1) {
      _keys![_expandedRowIndex!].currentState?.handleTap();
      _expandedRowIndex = -1;
    }

    setState(() {
      _currentPage = newPage;
    });
  }

  /// Change a row after the row is edited with an edit dialog.
  void _updateRow(ExpandableRow newRow, int rowInd) {
    _sortedRowsList[_currentPage][rowInd].row = newRow;

    widget.onRowChanged(newRow);

    setState(() {});
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
          child: PaginationWidget(
            currentPage: _currentPage,
            totalPageCount: _totalPageCount,
            onChanged: (value) => _changePage(value),
          ),
        )
      ],
    );
  }

  Widget buildRows() {
    List<String> headerNames = [];

    for (var element in _headerTitles) {
      headerNames.add(element.columnTitle);
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: pageLength,
        itemBuilder: (context, index) {
          //gets current index value of sorted data list
          ExpandableRow rowData =
              _sortedRowsList[_currentPage].elementAt(index).row;

          List<CellItem> expansionCells = [];
          List<CellItem> titleCells = [];

          _createRowCells(headerNames, rowData, titleCells, expansionCells);

          return buildSingleRow(context, index, expansionCells, titleCells);
        },
      ),
    );
  }

  Container buildSingleRow(
    BuildContext context,
    int index,
    List<CellItem> expansionCells,
    List<CellItem> titleCells,
  ) {
    var boxDecoration = BoxDecoration(
      border: Border(
        bottom: context.expandableTheme.rowsBorder,
      ),
    );

    return Container(
      decoration: boxDecoration,
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: context.expandableTheme.expandedBorderColor,
        ),
        child: custom_tile.ExpansionTile(
          key: _keys != null ? _keys![index] : UniqueKey(),
          showExpansionIcon: expansionCells.isNotEmpty,
          expansionIcon: context.expandableTheme.expansionIcon,
          collapsedBackgroundColor: context.expandableTheme.rowsColor,
          backgroundColor: context.expandableTheme.rowsColor,
          trailingWidth: _trailingWidth,
          secondTrailing: buildEditIcon(context, index),
          title: buildRowTitleContent(titleCells),
          onExpansionChanged: (val) => _onExpansionChange(val, index),
          childrenPadding: EdgeInsets.symmetric(vertical: context.lowValue),
          children: buildExpansionContent(context, expansionCells),
        ),
      ),
    );
  }

  Widget buildHeader() {
    if (widget.headers.isNotEmpty) {
      _headerTitles = widget.headers.sublist(0, widget.visibleColumnCount);
    }

    return TableHeader(
      headerRow: _headerTitles,
      currentSort: _sortOperations.sortInformation,
      onTitleTap: _sortRows,
      trailingWidth: _trailingWidth,
    );
  }

  Widget buildRowTitleContent(List<CellItem> titleCells) {
    return TitleContainer(
      titleCells: titleCells,
    );
  }

  List<Widget> buildExpansionContent(
    BuildContext context,
    List<CellItem> expansionCells,
  ) {
    if (expansionCells.isEmpty) {
      return [];
    }

    return [
      ExpansionContainer(expansionCells: expansionCells),
    ];
  }

  Widget buildEditIcon(BuildContext context, int rowInd) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: context.expandableTheme.editIcon,
      onPressed: () => showEditDialog(context, rowInd),
    );
  }

  Future<dynamic> showEditDialog(BuildContext context, int rowInd) {
    return showDialog(
      context: context,
      builder: (context) => widget.editDialog != null
          ? widget.editDialog!(
              _sortedRowsList[_currentPage][rowInd].row,
              (newRow) => _updateRow(newRow, rowInd),
            )
          : EditDialog(
              row: _sortedRowsList[_currentPage][rowInd].row,
              onSuccess: (newRow) => _updateRow(newRow, rowInd),
            ),
    );
  }
}
