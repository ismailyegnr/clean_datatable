import 'package:flutter/material.dart';

class ExpandableThemeData {
  /// Text style of header row.
  final TextStyle headerTextStyle;

  /// Text style of all rows.
  final TextStyle rowsTextStyle;

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

  factory ExpandableThemeData(
    BuildContext context, {
    TextStyle? headerTextStyle,
    TextStyle? rowsTextStyle,
    TextStyle? expandedTextStyle,
    Color? headerColor,
    Color? expandedBackgroundColor,
    Color? expandedBorderColor,
    Color? rowsColor,
    BorderSide? headerBorder,
    BorderSide? rowsBorder,
    Icon? editIcon,
    Icon? expansionIcon,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    const TextStyle fixText = TextStyle(fontSize: 13);

    headerTextStyle ??= theme.textTheme.bodyText1 ?? fixText;
    rowsTextStyle ??= theme.textTheme.bodyText2 ?? fixText;
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
      color: theme.iconTheme.color,
      size: 16,
    );
    expansionIcon ??= Icon(
      Icons.more_vert,
      color: theme.iconTheme.color,
      size: 18,
    );

    return ExpandableThemeData.raw(
      headerTextStyle: headerTextStyle,
      rowsTextStyle: rowsTextStyle,
      expandedTextStyle: expandedTextStyle,
      headerColor: headerColor,
      expandedBorderColor: expandedBorderColor,
      rowsColor: rowsColor,
      headerBorder: headerBorder,
      rowsBorder: rowsBorder,
      editIcon: editIcon,
      expansionIcon: expansionIcon,
    );
  }

  const ExpandableThemeData.raw({
    required this.headerTextStyle,
    required this.rowsTextStyle,
    required this.expandedTextStyle,
    required this.headerColor,
    required this.expandedBorderColor,
    required this.rowsColor,
    required this.headerBorder,
    required this.rowsBorder,
    required this.editIcon,
    required this.expansionIcon,
  });

  factory ExpandableThemeData.normal(BuildContext context) =>
      ExpandableThemeData(context);
}
