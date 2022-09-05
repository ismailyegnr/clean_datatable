import 'package:flutter/material.dart';

import '../extension/context_extension.dart';
import '../model/cell_item.dart';

class TitleContainer extends StatelessWidget {
  final List<CellItem> titleCells;

  const TitleContainer({Key? key, required this.titleCells}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var edgeInsets = EdgeInsets.symmetric(vertical: context.lowValue);

    return Padding(
      padding: edgeInsets,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: titleCells
            .map(
              (element) => Expanded(
                flex: element.flex!,
                child: _buildCell(context, element),
              ),
            )
            .toList(),
      ),
    );
  }

  Padding _buildCell(BuildContext context, CellItem element) {
    return Padding(
      padding: EdgeInsets.only(
        right: context.dynamicWidth(0.02),
      ),
      child: Text(
        element.value.toString(),
        style: context.expandableTheme.rowsTextStyle,
      ),
    );
  }
}
