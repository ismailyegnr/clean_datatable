import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'component/expandable_data_table.dart';
import 'component/model/expandable_column.dart';
import 'component/model/expandable_row.dart';
import 'component/utility/expandable_theme.dart';
import 'component/utility/expandable_theme_data.dart';
import 'model/models.dart';

//Datatable Page
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Users> userList = [];

  late List<ExpandableColumn<dynamic>> headers;
  late List<ExpandableRow> rows;

  bool _isLoading = true;

  void setLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    fetch();
  }

  void fetch() async {
    userList = await getUsers();

    createDataSource();

    setLoading();
  }

  Future<List<Users>> getUsers() async {
    final String response = await rootBundle.loadString('asset/dumb.json');

    final data = await json.decode(response);

    API apiData = API.fromJson(data);

    if (apiData.users != null) {
      return apiData.users!;
    }

    return [];
  }

  void createDataSource() {
    headers = [
      ExpandableColumn<int>(columnTitle: "ID", columnFlex: 1),
      ExpandableColumn<String>(columnTitle: "First name", columnFlex: 2),
      ExpandableColumn<String>(columnTitle: "Last name", columnFlex: 2),
      ExpandableColumn<String>(columnTitle: "Maiden name", columnFlex: 2),
      ExpandableColumn<int>(columnTitle: "Age", columnFlex: 1),
      ExpandableColumn<String>(columnTitle: "Gender", columnFlex: 2),
      ExpandableColumn<String>(columnTitle: "Email", columnFlex: 4),
    ];

    rows = userList.map<ExpandableRow>((e) {
      return ExpandableRow(cells: [
        ExpandableCell<int>(columnTitle: "ID", value: e.id),
        ExpandableCell<String>(columnTitle: "First name", value: e.firstName),
        ExpandableCell<String>(columnTitle: "Last name", value: e.lastName),
        ExpandableCell<String>(columnTitle: "Maiden name", value: e.maidenName),
        ExpandableCell<int>(columnTitle: "Age", value: e.age),
        ExpandableCell<String>(columnTitle: "Gender", value: e.gender),
        ExpandableCell<String>(columnTitle: "Email", value: e.email),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expandable Datatable Example"),
      ),
      body: !_isLoading
          ? ExpandableTheme(
              data: ExpandableThemeData(
                context,
                rowsBorder: const BorderSide(color: Colors.amber),
                expandedBorderColor: Colors.transparent,
                paginationSize: 48,
              ),
              child: ExpandableDataTable(
                rows: rows,
                headers: headers,
                onRowChanged: (newRow) {
                  print(newRow.cells[01].value);
                },
                onPageChanged: (page) {
                  print(page);
                },
                visibleColumnCount: 3,
                editDialog: (row, onSuccess) =>
                    _buildEditDialog(row, onSuccess),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEditDialog(
      ExpandableRow row, Function(ExpandableRow) onSuccess) {
    return AlertDialog(
      title: SizedBox(
        height: 300,
        child: TextButton(
          child: const Text("bas"),
          onPressed: () {
            row.cells[1].value = "x3";
            onSuccess(row);
          },
        ),
      ),
    );
  }
}
