import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../detail/detail_page.dart';

class QuestionPage extends StatefulWidget {
  final String question; // JSON 파일명 (test_1, test_2, test_3, list 등)
  final Color themeColor;

  const QuestionPage({
    super.key,
    required this.question,
    required this.themeColor
  });

  @override
  State<StatefulWidget> createState() => _QuestionPage();
}

class _QuestionPage extends State<QuestionPage> {
  List<dynamic> questions = [];
  int currentIndex = 0;
  Map<String, int> scores = {};
  Map<String, dynamic> testData = {};

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  Future<void> loadQuestion() async {
    String jsonString = await rootBundle.loadString('res/api/${widget.question}.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    setState(() {
      testData = jsonData;
      questions = List<dynamic>.from(jsonData['questions']);
    });
  }

  // 🎨 [신규 로직] 테스트 파일명에 맞춰 진행바 및 포인트 컬러를 동적으로 리턴합니다.
  Color getProgressColor() {
    if (widget.question.contains('test_1')) {
      return const Color(0xFFE91E63); // 1번 테스트: 진한 핑크
    } else if (widget.question.contains('test_2')) {
      return const Color(0xFF4CAF50); // 2번 테스트: 진한 연두
    } else {
      return const Color(0xFF1B81F5); // 3번 테스트 및 기본값: 파랑
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 파일별 동적 포인트 컬러 가져오기
    final pointColor = getProgressColor();

    return Scaffold(
      backgroundColor: widget.themeColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),

              // --- [1. 진행 상태바 & Q 번호 (색상 연동)] ---
              Text(
                'Q${currentIndex + 1}.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: pointColor, // 👈 테스트별 포인트 색상 적용!
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / questions.length,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      color: pointColor, // 👈 테스트별 진행바 색상 적용!
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // --- [2. 질문 텍스트] ---
              Text(
                questions[currentIndex]['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2235),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 60),

              // --- [3. 답변 선택지 버튼들] ---
              ... (questions[currentIndex]['answers'] as Map).entries.map((entry) {
                final answerData = entry.value as Map;
                final answerText = answerData['text'].toString();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      final scoreMap = answerData['score'] as Map;

                      scoreMap.forEach((key, value) {
                        scores[key.toString()] =
                            (scores[key.toString()] ?? 0) + (value as int);
                      });

                      setState(() {
                        if (currentIndex < questions.length - 1) {
                          currentIndex++;
                        } else {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                            final resultKey = scores.entries
                                .reduce((a, b) => a.value >= b.value ? a : b)
                                .key;
                            final result = Map<String, dynamic>.from(
                              testData['results'][resultKey],
                            );

                            return DetailPage(
                              title: result['language'].toString(),
                              description: result['description'].toString(),
                              testFile: widget.question,
                            );
                          }),
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        answerText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}