import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/setting/setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void buttonPressed(int rowIndex, int colIndex) {
    HapticFeedback.vibrate(); // 미세한 진동
    debugPrint("Button ($rowIndex, $colIndex) pressed");
    // 서버로 전송
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                    onTap: () => buttonPressed(rowIndex, colIndex), // ✅ 수정됨
                    child: Container(
                      width: 120,
                      height: 120,
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
              onPressed: () {
                debugPrint("Settings button pressed");
                showSettingDialog(context);
              },
              backgroundColor: Colors.grey[850],
              mini: true,
              child: const Icon(Icons.settings, color: Colors.white),
            );
          }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      ),
    );
  }
}
