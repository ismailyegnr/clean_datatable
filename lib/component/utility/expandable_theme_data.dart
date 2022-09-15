import 'package:flutter/material.dart';

class ExpandableThemeData {
  /// Text style of header row.
  final TextStyle headerTextStyle;

  /// Text style of all rows.
  final TextStyle rowTextStyle;

  /// Maximum number of lines for the text to span.
  ///
  /// If the text exceeds the given number of lines. It will be truncated according
  /// to [rowTextOverflow].
  final int rowTextMaxLines;

  /// Visual overflow of the row's cell text.
  final TextOverflow rowTextOverflow;

  /// Text style of expansion content.
  ///
  /// It overrides if custom render function is used.
  final TextStyle expandedTextStyle;

  /// Background color of header row.
  final Color headerColor;

  /// Expansion border color.
  ///
  /// It overrides if rowBorder is used.
  final Color expandedBorderColor;

  /// Background color of rows.
  final Color rowColor;

  /// Border style of header row.
  final BorderSide headerBorder;

  /// Border style of all rows.
  final BorderSide rowBorder;

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
    TextStyle? rowTextStyle,
    int? rowTextMaxLines,
    TextOverflow? rowTextOverflow,
    TextStyle? expandedTextStyle,
    Color? headerColor,
    Color? expandedBackgroundColor,
    Color? expandedBorderColor,
    Color? rowColor,
    BorderSide? headerBorder,
    BorderSide? rowBorder,
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
    rowTextStyle ??= theme.textTheme.bodyText2 ?? fixText;
    rowTextMaxLines ??= 3;
    rowTextOverflow ??= TextOverflow.ellipsis;
    expandedTextStyle ??= theme.textTheme.bodyText2 ?? fixText;
    headerColor ??= theme.scaffoldBackgroundColor;
    expandedBorderColor ??= colorScheme.onBackground;
    rowColor ??= theme.scaffoldBackgroundColor;
    headerBorder ??= const BorderSide(
      width: 2.5,
      color: Color(0xffeeeeee),
    );
    rowBorder ??= BorderSide.none;
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
      rowTextStyle: rowTextStyle,
      rowTextMaxLines: rowTextMaxLines,
      rowTextOverflow: rowTextOverflow,
      expandedTextStyle: expandedTextStyle,
      headerColor: headerColor,
      expandedBorderColor: expandedBorderColor,
      rowColor: rowColor,
      headerBorder: headerBorder,
      rowBorder: rowBorder,
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
    required this.rowTextStyle,
    required this.rowTextMaxLines,
    required this.rowTextOverflow,
    required this.expandedTextStyle,
    required this.headerColor,
    required this.expandedBorderColor,
    required this.rowColor,
    required this.headerBorder,
    required this.rowBorder,
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
