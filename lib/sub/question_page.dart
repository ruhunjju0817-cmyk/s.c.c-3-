import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../detail/detail_page.dart';

class QuestionPage extends StatefulWidget {
  final String question; // JSON 파일명
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

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  // 파일을 읽어오는 함수
  Future<void> loadQuestion() async {
    String jsonString = await rootBundle.loadString('res/api/${widget.question}.json');
    // json data type에 맞게 파일 읽는 방식 수정
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    setState(() {
      questions = jsonDecode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: widget.themeColor, // 넘겨받은 테마색 적용!
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),

              // --- [1. 진행 상태바 & Q 번호] ---
              Text(
                'Q${currentIndex + 1}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B81F5),
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
                      color: const Color(0xFF1B81F5),
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
              ... (questions[currentIndex]['answer'] as List).map((answer) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (currentIndex < questions.length - 1) {
                        currentIndex++;
                      } else {
                        // 마지막 질문이면 결과 페이지로! (학번: 20241207)
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                          return DetailPage(
                              answer: answer,
                              question: questions[currentIndex]['question']
                          );
                        }));
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
                      answer,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}