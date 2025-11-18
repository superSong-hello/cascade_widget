import 'package:cascade_widget/cascade_widget.dart';
import 'package:cascade_widget/src/components/select/single_select_widget.dart';
import 'package:flutter/material.dart';

//region Data Sources
final selecteds = ['112', '211'];

final testList = [
  DropDownMenuModel(
    id: '1',
    name: 'Level 1',
    children: [
      DropDownMenuModel(
        id: '11',
        name: 'Level 1-1',
        children: [
          DropDownMenuModel(id: '111', name: 'Level 1-1-1', children: []),
          DropDownMenuModel(id: '112', name: 'Level 1-1-2', children: []),
          DropDownMenuModel(id: '113', name: 'Level 1-1-3', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '12',
        name: 'Level 1-2',
        children: [
          DropDownMenuModel(id: '121', name: 'Level 1-2-1', children: []),
        ],
      ),
    ],
  ),
  DropDownMenuModel(
    id: '2',
    name: 'Level 2',
    children: [
      DropDownMenuModel(
        id: '21',
        name: 'Level 2-1',
        children: [
          DropDownMenuModel(id: '211', name: 'Level 2-1-1', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '22',
        name: 'Level 2-2',
        children: [
          DropDownMenuModel(id: '221', name: 'Level 2-2-1', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '23',
        name: 'Level 2-3',
        children: [
          DropDownMenuModel(id: '231', name: 'Level 2-3-1', children: []),
        ],
      ),
    ],
  ),
  DropDownMenuModel(
    id: '3',
    name: 'Level 3',
    children: [
      DropDownMenuModel(
        id: '31',
        name: 'Level 3-1',
        children: [
          DropDownMenuModel(id: '311', name: 'Level 3-1-1', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '32',
        name: 'Level 3-2',
        children: [
          DropDownMenuModel(id: '321', name: 'Level 3-2-1', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '3-3',
        name: 'Level 3-3',
        children: [
          DropDownMenuModel(id: '331', name: 'Level 3-3-1', children: []),
        ],
      ),
    ],
  ),
];

final testList1 = [
  DropDownMenuModel(
    id: '1',
    name: 'Level 1',
    children: [
      DropDownMenuModel(
        id: '11',
        name: 'Level 1-1',
        children: [
          DropDownMenuModel(id: '111', name: 'Level 1-1-1', children: []),
          DropDownMenuModel(id: '112', name: 'Level 1-1-2', children: []),
          DropDownMenuModel(id: '113', name: 'Level 1-1-3', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '12',
        name: 'Level 1-2',
        children: [
          DropDownMenuModel(id: '121', name: 'Level 1-2-1', children: []),
        ],
      ),
    ],
  ),
  DropDownMenuModel(
    id: '2',
    name: 'Level 2',
    children: [
      DropDownMenuModel(
        id: '21',
        name: 'Level 2-1',
        children: [
          DropDownMenuModel(id: '211', name: 'Level 2-1-1', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '22',
        name: 'Level 2-2',
        children: [
          DropDownMenuModel(
              id: '221',
              name:
                  'This is a very long text to test wrapping in the dropdown Level 2/Level 2-2/Level 2-2-1',
              children: []),
        ],
      ),
      DropDownMenuModel(
        id: '23',
        name: 'Level 2-3',
        children: [
          DropDownMenuModel(id: '231', name: 'Level 2-3-1', children: []),
        ],
      ),
    ],
  ),
  DropDownMenuModel(
    id: '3',
    name: 'Level 3',
    children: [
      DropDownMenuModel(
        id: '31',
        name: 'Level 3-1',
        children: [
          DropDownMenuModel(id: '311', name: 'Level 3-1-1', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '32',
        name: 'Level 3-2',
        children: [
          DropDownMenuModel(id: '321', name: 'Level 3-2-1', children: []),
        ],
      ),
      DropDownMenuModel(
        id: '3-3',
        name: 'Level 3-3',
        children: [
          DropDownMenuModel(id: '331', name: 'Level 3-3-1', children: []),
        ],
      ),
    ],
  ),
];

final singleList = [
  DropDownMenuModel(
    id: '1',
    name: 'This is a long option to test the display 1',
    children: [],
  ),
  DropDownMenuModel(
    id: '2',
    name: 'Option 2',
    children: [],
  ),
  DropDownMenuModel(
    id: '3',
    name: 'Option 3',
    children: [],
  ),
  DropDownMenuModel(
    id: '4',
    name: 'Option 4',
    children: [],
  ),
  DropDownMenuModel(
    id: '5',
    name: 'Option 5',
    children: [],
  ),
  DropDownMenuModel(
    id: '6',
    name: 'Option 6',
    children: [],
  ),
  DropDownMenuModel(
    id: '7',
    name: 'Option 7',
    children: [],
  ),
  DropDownMenuModel(
    id: '8',
    name: 'Option 8',
    children: [],
  ),
  DropDownMenuModel(
    id: '9',
    name: 'Option 9',
    children: [],
  ),
  DropDownMenuModel(
    id: '10',
    name: 'Option 10',
    children: [],
  ),
  DropDownMenuModel(
    id: '11',
    name: 'Option 11',
    children: [],
  ),
  DropDownMenuModel(
    id: '12',
    name: 'Option 12',
    children: [],
  ),
];

final mulList = [
  DropDownMenuModel(
    id: '1',
    name: 'This is a long option to test the display 1',
    children: [],
  ),
  DropDownMenuModel(
    id: '2',
    name: 'Option 2',
    children: [],
  ),
  DropDownMenuModel(
    id: '3',
    name: 'Option 3',
    children: [],
  ),
  DropDownMenuModel(
    id: '4',
    name: 'Option 4',
    children: [],
  ),
  DropDownMenuModel(
    id: '5',
    name: 'Option 5',
    children: [],
  ),
];

final pureSingleList = [
  DropDownMenuModel(id: 's1', name: 'Simple Item 1', children: []),
  DropDownMenuModel(id: 's2', name: 'Simple Item 2', children: []),
  DropDownMenuModel(id: 's3', name: 'Simple Item 3', children: []),
  DropDownMenuModel(id: 's4', name: 'Simple Item 4', children: []),
  DropDownMenuModel(id: 's5', name: 'Simple Item 5', children: []),
  DropDownMenuModel(id: 's6', name: 'Simple Item 6', children: []),
  DropDownMenuModel(id: 's7', name: 'Simple Item 7', children: []),
  DropDownMenuModel(id: 's8', name: 'Simple Item 8', children: []),
  DropDownMenuModel(id: 's9', name: 'Simple Item 9', children: []),
  DropDownMenuModel(id: 's10', name: 'Simple Item 10', children: []),
  DropDownMenuModel(id: 's11', name: 'Simple Item 11', children: []),
  DropDownMenuModel(id: 's12', name: 'Simple Item 12', children: []),
];
//endregion

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
  final mulSelectController = MultipleSelectWidgetController();
  final singleCascadeSelectController = SingleSelectCascadeWidgetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _Title('Cascade Widgets (Web Optimized)'),
                _CascadeExample(
                  title: 'Show all selected items:',
                  list: testList1,
                  selectedIds: selecteds,
                  layoutConfig: const LayoutConfig(
                    isShowAllSelectedLabel: true,
                  ),
                ),
                _CascadeExample(
                  title: 'Show first item +n more:',
                  list: testList,
                  controller: cascadeController,
                  layoutConfig: const LayoutConfig(
                    isShowAllSelectedLabel: false,
                  ),
                  isShowSearchInput: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => cascadeController.cancelAllSelected(),
                    child: const Text('Unselect All'),
                  ),
                ),
                _CascadeExample(
                  title: 'Disabled Cascade Widget:',
                  list: testList,
                  enabled: false,
                ),
                const SizedBox(height: 40),
                const _Title('Single Select Cascade Widget (Web Optimized)'),
                _SingleSelectCascadeExample(
                  controller: singleCascadeSelectController,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () =>
                        singleCascadeSelectController.cancelAllSelected(),
                    child: const Text('Unselect All (Cascade Single Select)'),
                  ),
                ),
                const _Title('Pure Single Select Widget'),
                SizedBox(
                  width: 300,
                  child: _Card(
                    child: SingleSelectWidget(
                      list: pureSingleList,
                      selectedCallBack: (selectedList) {
                        debugPrint('Pure single select callback:');
                        for (final e in selectedList) {
                          debugPrint('name:${e.name}, id:${e.id}');
                        }
                      },
                      fieldDecoration: FieldDecoration(
                        backgroundColor: Colors.white,
                        hintText: 'Please select a simple item',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        showClearIcon: false,
                      ),
                      popupConfig: const PopupConfig(
                        isShowSearchInput: true,
                        isShowOverlay: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const _Title('Multiple/Single Select Widgets'),
                const _MultipleSelectExample(
                  title: 'Single Select:',
                  isSingleChoice: true,
                  maxWidth: 200,
                  selectedIds: ['1'],
                ),
                const _MultipleSelectExample(
                  title: 'Single Select (No Search):',
                  isSingleChoice: true,
                  selectedIds: ['1'],
                  popupConfig: PopupConfig(
                    isShowSearchInput: false,
                    isShowOverlay: true,
                  ),
                ),
                _MultipleSelectExample(
                  title: 'Multiple Select:',
                  controller: mulSelectController,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => mulSelectController.cancelAllSelected(),
                    child: const Text('Unselect All (Multiple Select)'),
                  ),
                ),
                // const _MultipleSelectExample(
                //   title: 'Multiple Select (Column Layout):',
                //   layoutConfig: LayoutConfig(isRow: false),
                // ),
                const _MultipleSelectExample(
                  title: 'Disabled Multiple Select:',
                  enabled: false,
                ),
                const _Title(
                    'Pure Single Select Widget (popup location: above)'),
                SizedBox(
                  width: 300,
                  child: _Card(
                    child: SingleSelectWidget(
                      list: pureSingleList,
                      selectedCallBack: (selectedList) {
                        debugPrint('Pure single select callback:');
                        for (final e in selectedList) {
                          debugPrint('name:${e.name}, id:${e.id}');
                        }
                      },
                      fieldDecoration: FieldDecoration(
                        backgroundColor: Colors.white,
                        hintText: 'Please select a simple item',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        showClearIcon: false,
                      ),
                      popupConfig: const PopupConfig(
                        isShowSearchInput: true,
                        isShowOverlay: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _CascadeExample extends StatelessWidget {
  const _CascadeExample({
    required this.title,
    required this.list,
    this.controller,
    this.layoutConfig,
    this.selectedIds,
    this.enabled = true,
    this.isShowSearchInput = false,
  });

  final String title;
  final List<DropDownMenuModel> list;
  final CascadeWidgetController? controller;
  final LayoutConfig? layoutConfig;
  final List<String>? selectedIds;
  final bool enabled;
  final bool isShowSearchInput;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 10),
          CascadeWidget(
            list: list,
            controller: controller,
            layoutConfig: layoutConfig ?? const LayoutConfig(),
            selectedIds: selectedIds,
            enabled: enabled,
            selectedCallBack: (selectedList) {
              debugPrint('selected items:');
              for (final e in selectedList) {
                debugPrint('name:${e.name}, id:${e.id}');
              }
            },
            fieldDecoration: FieldDecoration(
              backgroundColor: Colors.white,
              hintText: 'Please select',
              hintStyle: const TextStyle(color: Colors.black45),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            chipDecoration: ChipDecoration(
              backgroundColor: Colors.blueAccent,
              runSpacing: 2,
              spacing: 10,
              labelStyle: const TextStyle(
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey),
              deleteIcon: const Icon(Icons.clear_outlined,
                  color: Colors.white, size: 16),
              maxWidth: 100,
            ),
            popupConfig: PopupConfig(
              isShowSearchInput: isShowSearchInput,
              isShowOverlay: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleSelectCascadeExample extends StatelessWidget {
  const _SingleSelectCascadeExample({this.controller});
  final SingleSelectCascadeWidgetController? controller;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: SingleSelectCascadeWidget(
        list: testList1, // Using testList1 as testList2 is repetitive
        controller: controller,
        selectedCallBack: (selectedList) {
          debugPrint('selected items:');
          for (final e in selectedList) {
            debugPrint('name:${e.name}, id:${e.id}');
          }
        },
        fieldDecoration: FieldDecoration(
          backgroundColor: Colors.white,
          hintText: 'Please select',
          hintStyle: const TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        chipDecoration: ChipDecoration(
          backgroundColor: Colors.blue,
          runSpacing: 2,
          spacing: 10,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.grey),
          deleteIcon:
              const Icon(Icons.clear_outlined, color: Colors.white, size: 16),
          maxWidth: 250,
          isShowFullPathFromSelectedTag: true,
        ),
        popupConfig: const PopupConfig(
          isShowSearchInput: true,
          isShowOverlay: true,
        ),
        layoutConfig: const LayoutConfig(
          isShowAllSelectedLabel: false,
        ),
        selectedIds: const [],
      ),
    );
  }
}

class _MultipleSelectExample extends StatelessWidget {
  const _MultipleSelectExample({
    required this.title,
    this.controller,
    this.isSingleChoice = false,
    this.selectedIds,
    // ignore: unused_element_parameter
    this.layoutConfig,
    this.popupConfig,
    this.enabled = true,
    this.maxWidth = 100,
    this.width = 410,
  });

  final String title;
  final MultipleSelectWidgetController? controller;
  final bool isSingleChoice;
  final List<String>? selectedIds;
  final LayoutConfig? layoutConfig;
  final PopupConfig? popupConfig;
  final bool enabled;
  final double maxWidth;
  final double width;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 10),
          SizedBox(
            width: width,
            height: layoutConfig?.isRow == false ? 100 : 40,
            child: MultipleSelectWidget(
              list: isSingleChoice ? singleList : mulList,
              controller: controller,
              selectedCallBack: (selectedList) {
                for (final e in selectedList) {
                  debugPrint('name:${e.name}, id:${e.id}');
                }
              },
              isSingleChoice: isSingleChoice,
              selectedIds: selectedIds,
              enabled: enabled,
              layoutConfig: layoutConfig ?? const LayoutConfig(),
              popupConfig: popupConfig ??
                  const PopupConfig(
                    isShowFullPathFromSearch: false,
                    popupHeight: 300,
                    isShowOverlay: true,
                  ),
              fieldDecoration: FieldDecoration(
                backgroundColor: Colors.white,
                hintText: 'Select...',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                showClearIcon: false,
                clearIcon: const Icon(
                  Icons.clear,
                  size: 14,
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              chipDecoration: ChipDecoration(
                backgroundColor: Colors.black12,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                runSpacing: 0,
                spacing: 5,
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                maxWidth: maxWidth,
                deleteIcon: const Icon(
                  Icons.clear_outlined,
                  color: Colors.black54,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
