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

  Color getProgressColor() {
    if (widget.question.contains('test_1')) {
      return const Color(0xFFE91E63);
    } else if (widget.question.contains('test_2')) {
      return const Color(0xFF4CAF50);
    } else {
      return const Color(0xFF1B81F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

              Text(
                'Q${currentIndex + 1}.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: pointColor,
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
                      color: pointColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),

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

                            // 🛠️ [해결] resultKey: resultKey.toString()을 추가해서 매칭 완료!
                            return DetailPage(
                              title: result['language'].toString(),
                              description: result['description'].toString(),
                              testFile: widget.question,
                              resultKey: resultKey.toString(), // 👈 여기에 쏙 들어갔다능!
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