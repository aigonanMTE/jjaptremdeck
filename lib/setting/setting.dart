import 'dart:ffi';

//TODO : 진동 켜고 끄는 기능 만들기

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void showSettingDialog(BuildContext context, onSettingChanged) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      // ✅ 화면에 맞춘 최대 버튼 크기
      // 가로 7개, 세로 4개 기준
      final maxWidthButtonSize = (screenWidth / 7) - 10; // 버튼 사이 간격 고려
      final maxHeightButtonSize = (screenHeight / 4) - 10; // 세로 간격
      final dynamicMaxSize = maxWidthButtonSize < maxHeightButtonSize
          ? maxWidthButtonSize
          : maxHeightButtonSize;

      return Dialog(
        backgroundColor: const Color(0xFF282C34),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: screenWidth * 0.8,
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "설정",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ✅ 화면 크기에 맞춘 최대값 적용
                      LabeledTextFieldRow(
                        id: "buttonSize",
                        label: "버튼 크기",
                        hint: '기본값: 120',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (id, value) async {
                          final intValue = int.tryParse(value) ?? 120;

                          // 최소값 50, 최대값 화면 기준
                          final safeValue = intValue.clamp(50, dynamicMaxSize.toInt());

                          final storage = await SharedPreferences.getInstance();
                          await storage.setInt(id, safeValue);

                          // if (intValue != safeValue+1) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text(
                          //         "버튼 크기는 50~${dynamicMaxSize.toInt()} 사이로만 설정 가능합니다. ($safeValue으로 조정됨)",
                          //       ),
                          //       duration: const Duration(seconds: 2),
                          //     ),
                          //   );
                          // }

                          onSettingChanged();
                        },
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "변경사항은 설정창을 닫을 때 적용됩니다.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

typedef ValueChangedWithId = void Function(String id, String value);

class LabeledTextFieldRow extends StatelessWidget {
  final String id; // 고유 ID
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final double labelWidth;
  final ValueChangedWithId? onChanged; // id와 값 전달
  final List<TextInputFormatter>? inputFormatters; // ✅ 추가됨

  const LabeledTextFieldRow({
    super.key,
    required this.id,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.labelWidth = 100,
    this.onChanged,
    this.inputFormatters, // ✅ 선택적 포맷터
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            inputFormatters: inputFormatters, // ✅ 적용
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF3B4048),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              if (onChanged != null) {
                onChanged!(id, value); // ✅ ID와 함께 값 전달
              }
            },
          ),
        ),
      ],
    );
  }
}
