import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailPage extends StatelessWidget {
  final String title;       // JSON 결과 데이터의 타이틀 값
  final String description; // JSON 결과 데이터의 상세 설명 값
  final String testFile;    // 현재 진행된 테스트 파일명

  const DetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.testFile,
  });

  // --- [🎨 테스트별 배경색, 포인트 컬러, 인트로 문구 매핑 데이터 정의] ---
  Map<String, dynamic> getThemeData() {
    if (testFile.contains('test_1')) {
      return {
        'bgColor': const Color(0xFFFCE1E4),       // 💗 1번 테스트: 연핑크 배경
        'accentColor': const Color(0xFFE91E63),    // 진한 핑크 포인트
        'introText': '당신의 연애 유형은?',          // 요구사항 문구 반영
      };
    } else if (testFile.contains('test_2')) {
      return {
        'bgColor': const Color(0xFFE2F0CB),       // 💚 2번 테스트: 연두 배경
        'accentColor': const Color(0xFF4CAF50),    // 진한 연두 포인트
        'introText': '나에게서 나는 분위기의 향기는?', // 요구사항 문구 반영
      };
    } else {
      return {
        'bgColor': const Color(0xFFDAEAF6),       // 💙 3번 테스트 & 기본: 연하늘 배경
        'accentColor': const Color(0xFF1B81F5),    // 진한 파란색 포인트
        'introText': '당신을 닮은 개발 도구는...',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = getThemeData();

    // 스마트폰 상단 바 투명화 세팅 일치화
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: theme['bgColor'], // 👈 테스트 매핑 배경색 동적 전환!
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),

              // 💥 [해결 완료] 고정 문구가 아닌 테스트 파일별 맞춤형 인트로 상단 멘트 출력!
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

              // 진짜 결과 타이틀 출력
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

              // 캐릭터 이미지 가상 영역 (둥근 원형)
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
                  child: Icon(
                    Icons.image_outlined,
                    size: 70,
                    color: (theme['accentColor'] as Color).withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 진짜 결과 상세 설명 출력
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

              // 처음으로 돌아가기 버튼
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