import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                  color: Colors.transparent, // InkWell을 위한 Material 래퍼
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0), // 물결효과 모양
                    onTap: buttonPressed(rowIndex , colIndex),
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

        // ✅ 오른쪽 아래에 설정 버튼 추가
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint("Settings button pressed");
          },
          backgroundColor: Colors.grey[850],
          mini: true, // 작게 만들기
          child: const Icon(Icons.settings, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop, // 오른쪽 아래
      ),
    );
  }
}

buttonPressed(rowIndex , colIndex){
  HapticFeedback.vibrate(); //미세한 진동
  debugPrint("Button ($rowIndex, $colIndex) pressed");
  // 서버로 전송
}
