import 'package:flutter/material.dart';

class ExpandableThemeData {
  /// Text style of header row.
  final TextStyle headerTextStyle;

  /// Text style of all rows.
  final TextStyle rowsTextStyle;

  /// Maximum number of lines for the text to span.
  ///
  /// If the text exceeds the given number of lines. It will be truncated according
  /// to [rowsTextOverflow].
  final int rowsTextMaxLines;

  /// Visual overflow of the row's cell text.
  final TextOverflow rowsTextOverflow;

  /// Text style of expansion content.
  ///
  /// It overrides if custom render function is used.
  final TextStyle expandedTextStyle;

  /// Background color of header row.
  final Color headerColor;

  /// Expansion border color.
  ///
  /// It overrides if rowsBorder is used.
  final Color expandedBorderColor;

  /// Background color of rows.
  final Color rowsColor;

  /// Border style of header row.
  final BorderSide headerBorder;

  /// Border style of all rows.
  final BorderSide rowsBorder;

  /// Icon showing editing feature.
  final Icon editIcon;

  /// Icon that expands the expansion content.
  final Icon expansionIcon;

  /*************** Pagination Widget Theme Properties *******************/
  /// If the custom pagination widget is not used. These properties
  /// are used to customize default pagination widget.

  /// Size of the default pagination widget.
  ///
  /// If this property is null, then paginationSize 48 is be used.
  final double paginationSize;

  final TextStyle? paginationTextStyle;

  final Color? paginationSelectedTextColor;

  final Color? paginationUnselectedTextColor;

  final Color? paginationSelectedFillColor;

  final Color? paginationBorderColor;

  final BorderRadius? paginationBorderRadius;

  final double? paginationBorderWidth;

  factory ExpandableThemeData(
    BuildContext context, {
    TextStyle? headerTextStyle,
    TextStyle? rowsTextStyle,
    int? rowsTextMaxLines,
    TextOverflow? rowsTextOverflow,
    TextStyle? expandedTextStyle,
    Color? headerColor,
    Color? expandedBackgroundColor,
    Color? expandedBorderColor,
    Color? rowsColor,
    BorderSide? headerBorder,
    BorderSide? rowsBorder,
    Icon? editIcon,
    Icon? expansionIcon,
    double? paginationSize,
    TextStyle? paginationTextStyle,
    Color? paginationSelectedTextColor,
    Color? paginationUnselectedTextColor,
    Color? paginationSelectedFillColor,
    Color? paginationBorderColor,
    BorderRadius? paginationBorderRadius,
    double? paginationBorderWidth,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    const TextStyle fixText = TextStyle(fontSize: 13);

    headerTextStyle ??= theme.textTheme.bodyText1 ?? fixText;
    rowsTextStyle ??= theme.textTheme.bodyText2 ?? fixText;
    rowsTextMaxLines ??= 3;
    rowsTextOverflow ??= TextOverflow.ellipsis;
    expandedTextStyle ??= theme.textTheme.bodyText2 ?? fixText;
    headerColor ??= theme.scaffoldBackgroundColor;
    expandedBorderColor ??= colorScheme.onBackground;
    rowsColor ??= theme.scaffoldBackgroundColor;
    headerBorder ??= const BorderSide(
      width: 2.5,
      color: Color(0xffeeeeee),
    );
    rowsBorder ??= BorderSide.none;
    editIcon ??= Icon(
      Icons.edit,
      color: theme.unselectedWidgetColor,
      size: 16,
    );
    expansionIcon ??= Icon(
      Icons.more_vert,
      color: theme.unselectedWidgetColor,
      size: 18,
    );
    paginationSize ??= 48;

    return ExpandableThemeData.raw(
      headerTextStyle: headerTextStyle,
      rowsTextStyle: rowsTextStyle,
      rowsTextMaxLines: rowsTextMaxLines,
      rowsTextOverflow: rowsTextOverflow,
      expandedTextStyle: expandedTextStyle,
      headerColor: headerColor,
      expandedBorderColor: expandedBorderColor,
      rowsColor: rowsColor,
      headerBorder: headerBorder,
      rowsBorder: rowsBorder,
      editIcon: editIcon,
      expansionIcon: expansionIcon,
      paginationSize: paginationSize,
      paginationTextStyle: paginationTextStyle,
      paginationSelectedTextColor: paginationSelectedTextColor,
      paginationUnselectedTextColor: paginationUnselectedTextColor,
      paginationSelectedFillColor: paginationSelectedFillColor,
      paginationBorderColor: paginationBorderColor,
      paginationBorderRadius: paginationBorderRadius,
      paginationBorderWidth: paginationBorderWidth,
    );
  }

  const ExpandableThemeData.raw({
    required this.headerTextStyle,
    required this.rowsTextStyle,
    required this.rowsTextMaxLines,
    required this.rowsTextOverflow,
    required this.expandedTextStyle,
    required this.headerColor,
    required this.expandedBorderColor,
    required this.rowsColor,
    required this.headerBorder,
    required this.rowsBorder,
    required this.editIcon,
    required this.expansionIcon,
    required this.paginationSize,
    this.paginationTextStyle,
    this.paginationSelectedTextColor,
    this.paginationUnselectedTextColor,
    this.paginationSelectedFillColor,
    this.paginationBorderColor,
    this.paginationBorderRadius,
    this.paginationBorderWidth,
  });

  factory ExpandableThemeData.normal(BuildContext context) =>
      ExpandableThemeData(context);
}
