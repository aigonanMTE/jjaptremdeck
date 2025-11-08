import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void showSettingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;

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
              // 닫기 버튼
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              // 팝업 내용
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

                      // ✅ 첫 번째 LabeledTextFieldRow: 숫자만 입력 허용
                      LabeledTextFieldRow(
                        id: "buttonSize",
                        label: "버튼 크기",
                        hint: '기본값 : 120',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // ✅ 숫자만 허용
                        ],
                        onChanged: (id, value) async {
                          print(id);

                          // 문자열을 정수로 안전하게 변환
                          final intValue = int.tryParse(value) ?? 20;

                          final storage = await SharedPreferences.getInstance();
                          await storage.setInt(id, intValue);

                          print("저장된 값: ${storage.getInt(id)}");
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "추가 설정 항목을 여기에 배치할 수 있습니다.",
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
