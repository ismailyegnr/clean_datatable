import '../model/sortable_row.dart';
import 'row_extension.dart';

extension ListSortExtension on List<SortableRow> {
  void get unsort => sort(
        (a, b) => a.index.compareTo(b.index),
      );

  void sortStringAscending(String columnTitle) {
    sort(
      (a, b) => a.searchTitleValue(columnTitle).toLowerCase().compareTo(
            b.searchTitleValue(columnTitle).toLowerCase(),
          ),
    );
  }

  void sortBoolAscending(String columnTitle) {
    sort(
      (a, b) => a.searchTitleValue(columnTitle).toString().compareTo(
            b.searchTitleValue(columnTitle).toString().toLowerCase(),
          ),
    );
  }

  void sortNumAscending(String columnTitle) {
    sort(
      (a, b) => a.searchTitleValue(columnTitle).compareTo(
            b.searchTitleValue(columnTitle),
          ),
    );
  }
}
