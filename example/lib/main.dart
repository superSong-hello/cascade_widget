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

  final testList = [
    DropDownMenuModel(
      id: '',
      name: '一级 1',
      children: [
        DropDownMenuModel(
          id: '',
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
          id: '',
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
      id: '',
      name: '一级 2',
      children: [
        DropDownMenuModel(
          id: '',
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
          id: '',
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
          id: '',
          name: '二级 2-3',
          children: [
            DropDownMenuModel(
              id: '231',
              name: '三级 2-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
    DropDownMenuModel(
      id: '',
      name: '一级 3',
      children: [
        DropDownMenuModel(
          id: '',
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
          id: '',
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
          id: '',
          name: '二级 2-3',
          children: [
            DropDownMenuModel(
              id: '231',
              name: '三级 2-3-1',
              children: [],
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode(),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100,),
            SizedBox(
              width: 410,
              child: CascadeWidget(
                list: testList,
                selectedCallBack: (selectedList) {
                  for (final e in selectedList) {
                    debugPrint('name:${e.name}, id:${e.id}');
                  }
                },
                fieldDecoration: FieldDecoration(
                  hintText: '请选择',
                  hintStyle: const TextStyle(color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    ),
                  ),
                ),
                chipDecoration: const ChipDecoration(
                    backgroundColor: Colors.blueAccent,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    deleteIcon: Icon(Icons.clear_outlined,
                        color: Colors.white, size: 16)),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
