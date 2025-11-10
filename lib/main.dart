import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting/setting.dart'; // 네가 만든 setting.dart

Future<void> main() async {
  runApp(const MyApp());
  final storage = await SharedPreferences.getInstance();
  print("buttonsize${storage.getInt("buttonSize")}");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int buttonSize = 120; // 기본 버튼 크기

  @override
  void initState() {
    super.initState();
    _loadButtonSize();
  }

  Future<void> _setDefaultSetting() async{
    final storage = await SharedPreferences.getInstance();
    buttonSize = storage.getInt("buttonSize") ?? 0;
    if (buttonSize == 0 || buttonSize.isNaN){
      await storage.setInt("buttonSize", 120);
    }
  }

  Future<void> _loadButtonSize() async {
    final storage = await SharedPreferences.getInstance();
    setState(() {
      buttonSize = storage.getInt("buttonSize") ?? 120;
    });
  }

  void _updateButtonSize() async {
    final storage = await SharedPreferences.getInstance();
    setState(() {
      buttonSize = storage.getInt("buttonSize") ?? 120;
    });
  }

  void buttonPressed(int rowIndex, int colIndex) {
    HapticFeedback.vibrate();
    debugPrint("Button ($rowIndex, $colIndex) pressed");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
                (rowIndex) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                    (colIndex) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () => buttonPressed(rowIndex, colIndex),
                    child: Container(
                      width: buttonSize.toDouble(),
                      height: buttonSize.toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                debugPrint("Settings button pressed");
                showSettingDialog(context , _updateButtonSize);
                // _updateButtonSize(); // 다이얼로그 닫힌 뒤 크기 갱신
              },
              backgroundColor: Colors.grey[850],
              mini: true,
              child: const Icon(Icons.settings, color: Colors.white),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      ),
    );
  }
}