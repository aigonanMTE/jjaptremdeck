import 'package:flutter/material.dart';

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
                    children: const [
                      Text(
                        "설정",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),

                      // LabeledTextField 사용
                      LabeledTextFieldRow(
                        label: "버튼 크기",
                        hint: '기본값 : 120',
                      ),
                      SizedBox(height: 20),

                      Text(
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

class LabeledTextFieldRow extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final double labelWidth;
  final ValueChanged<String>? onChanged; // 입력값 변경 콜백

  const LabeledTextFieldRow({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.labelWidth = 100,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            onChanged: onChanged, // ✅ 입력 변경시 호출
          ),
        ),
      ],
    );
  }
}
