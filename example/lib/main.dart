import 'package:cascade_widget/cascade_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cascade Widget Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cascade Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cascadeController = CascadeWidgetController();
  final testList = [
    DropDownMenuModel(
      id: '1',
      name: '一级 1',
      children: [
        DropDownMenuModel(
          id: '11',
          name: '二级 1-1',
          children: [
            DropDownMenuModel(
              id: '111',
              name: '三级 1-1-1',
              children: [],
            ),
            DropDownMenuModel(
              id: '112',
              name: '三级 1-1-2',
              children: [],
            ),
            DropDownMenuModel(
              id: '113',
              name: '三级 1-1-3',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '12',
          name: '二级 1-2',
          children: [
            DropDownMenuModel(
              id: '121',
              name: '三级 1-2-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '2',
      name: '一级 2',
      children: [
        DropDownMenuModel(
          id: '21',
          name: '二级 2-1',
          children: [
            DropDownMenuModel(
              id: '211',
              name: '三级 2-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '22',
          name: '二级 2-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 2-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '23',
          name: '二级 2-3',
          children: [
            DropDownMenuModel(
              id: '231',
              name: '三级 2-3-1 2-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3 - 1 - 1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 321',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3  3  1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 3-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 3-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 3-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
  ];

  final testList1 = [
    DropDownMenuModel(
      id: '1',
      name: '一级 1',
      children: [
        DropDownMenuModel(
          id: '11',
          name: '二级 1-1',
          children: [
            DropDownMenuModel(
              id: '111',
              name: '一级 1/二级 1-1/三级 1-1-1',
              children: [],
            ),
            DropDownMenuModel(
              id: '112',
              name: '一级/二级/三级 1-1-2',
              children: [],
            ),
            DropDownMenuModel(
              id: '113',
              name: '一级/二级/三级 1-1-3',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '12',
          name: '二级 1-2',
          children: [
            DropDownMenuModel(
              id: '121',
              name: '三级 1-2-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '2',
      name: '一级 2',
      children: [
        DropDownMenuModel(
          id: '21',
          name: '二级 2-1',
          children: [
            DropDownMenuModel(
              id: '211',
              name: '一级 2/二级 2-1/三级 2-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '22',
          name: '二级 2-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '测试长度超出一行怎么解决 一级 2/二级 2-2三级 2-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '23',
          name: '二级 2-3',
          children: [
            DropDownMenuModel(
              id: '231',
              name: '三级 2-3-1 2-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3 - 1 - 1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 321',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3  3  1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 3-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 3-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '3',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '31',
          name: '二级 3-1',
          children: [
            DropDownMenuModel(
              id: '311',
              name: '三级 3-1-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '32',
          name: '二级 3-2',
          children: [
            DropDownMenuModel(
              id: '221',
              name: '三级 3-2-1',
              children: [],
            ),
          ],
        ),
        DropDownMenuModel(
          id: '3-3',
          name: '二级 3-3',
          children: [
            DropDownMenuModel(
              id: '331',
              name: '三级 3-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
  ];

  final selecteds = ['112', '211'];

  final mulList = [
    DropDownMenuModel(
      id: '1',
      name: '选项 1',
      children: [],
    ),
    DropDownMenuModel(
      id: '2',
      name: '选项 2',
      children: [],
    ),
    DropDownMenuModel(
      id: '3',
      name: '选项 3',
      children: [],
    ),
    DropDownMenuModel(
      id: '4',
      name: '选项 4',
      children: [],
    ),
    DropDownMenuModel(
      id: '5',
      name: '选项 5',
      children: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('controller: ${cascadeController.hashCode}');
    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: 410,
                child: CascadeWidget(
                  list: testList1,
                  selectedCallBack: (selectedList) {
                    debugPrint('selected items:');
                    for (final e in selectedList) {
                      debugPrint('name:${e.name}, id:${e.id}');
                    }
                  },
                  fieldDecoration: FieldDecoration(
                    backgroundColor: Colors.white,
                    hintText: '请选择',
                    hintStyle: const TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    isRow: false,
                  ),
                  chipDecoration: const ChipDecoration(
                    backgroundColor: Colors.blueAccent,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    deleteIcon: Icon(Icons.clear_outlined,
                        color: Colors.white, size: 16),
                  ),
                  popupConfig: PopupConfig(
                    isShowAllSelectedLabel: true,
                    selectedIds: selecteds,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 410,
                child: CascadeWidget(
                  list: testList,
                  controller: cascadeController,
                  selectedCallBack: (selectedList) {
                    debugPrint('selected items:');
                    for (final e in selectedList) {
                      debugPrint('name:${e.name}, id:${e.id}');
                    }
                  },
                  fieldDecoration: FieldDecoration(
                    backgroundColor: Colors.white,
                    hintText: '请选择',
                    hintStyle: const TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    isRow: true,
                  ),
                  chipDecoration: const ChipDecoration(
                      backgroundColor: Colors.blueAccent,
                      runSpacing: 2,
                      spacing: 10,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      deleteIcon: Icon(Icons.clear_outlined,
                          color: Colors.white, size: 16),
                  ),
                  popupConfig: const PopupConfig(
                    isShowAllSelectedLabel: false,
                    isShowSearchInput: false,
                    // selectedIds: selecteds,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  cascadeController.cancelAllSelected();
                  setState(() {

                  });
                },
                child: const Text('Unselect All'),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 410,
                child: MultipleSelectWidget(
                  list: mulList,
                  selectedCallBack: (selectedList) {
                    for (final e in selectedList) {
                      debugPrint('name:${e.name}, id:${e.id}');
                    }
                  },
                  fieldDecoration: FieldDecoration(
                    hintText: '单选（支持多选）',
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    clearIcon: const Icon(
                      Icons.clear,
                      size: 14,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  chipDecoration: const ChipDecoration(
                    backgroundColor: Colors.black12,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    runSpacing: 0,
                    spacing: 5,
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    deleteIcon: Icon(
                      Icons.clear_outlined,
                      color: Colors.black54,
                      size: 15,
                    ),
                  ),
                  popupConfig: const PopupConfig(
                    isShowFullPathFromSearch: false,
                    popupHeight: 300,
                    isSingleChoice: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
