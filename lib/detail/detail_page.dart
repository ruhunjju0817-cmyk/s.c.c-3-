import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String testFile;
  final String resultKey;

  const DetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.testFile,
    required this.resultKey,
  });

  Map<String, dynamic> getThemeData() {
    if (testFile.contains('test_1')) {
      return {
        'bgColor': const Color(0xFFFCE1E4),
        'accentColor': const Color(0xFFE91E63),
        'introText': '당신의 연애 유형은?',
      };
    } else if (testFile.contains('test_2')) {
      return {
        'bgColor': const Color(0xFFE2F0CB),
        'accentColor': const Color(0xFF4CAF50),
        'introText': '나에게서 나는 분위기의 향기는?',
      };
    } else {
      return {
        'bgColor': const Color(0xFFDAEAF6),
        'accentColor': const Color(0xFF1B81F5),
        'introText': '당신을 닮은 개발 도구는...',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = getThemeData();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: theme['bgColor'],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),

              Text(
                theme['introText'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: theme['accentColor'],
                ),
              ),
              const SizedBox(height: 40),

              // 🛠️ 경로 수정 완료! res/assets/images/ 로 변경했습니다.
              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                        )
                      ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Image.asset(
                      'res/assets/images/$resultKey.png', // 👈 여기에 res/ 추가 완료!
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_outlined,
                          size: 70,
                          color: (theme['accentColor'] as Color).withOpacity(0.6),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ]
                ),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: theme['accentColor'],
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: (theme['accentColor'] as Color).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    '처음으로 돌아가기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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