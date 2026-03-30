import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MainlistPage extends StatefulWidget {
  const MainlistPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainlistPage();
}

class _MainlistPage extends State<MainlistPage> {
  // JSON 데이터를 가져오는 함수
  Future<List<dynamic>> loadAsset() async {
    String jsonString = await rootBundle.loadString('res/api/list.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    return jsonResponse['questions'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('심리 테스트 목록'),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadAsset(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = snapshot.data![index];
                return InkWell(
                  onTap: () async {
                    await FirebaseAnalytics.instance.logEvent(
                      name: "test_click",
                      parameters: {"test_name": item['title'].toString()},
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuestionPage(question: item),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 5,
                    child: Container(
                      height: 80,
                      alignment: Alignment.center,
                      child: Text(
                        item['title'].toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('데이터 로딩 중...'));
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// QuestionPage 클래스 (오타 수정 완료!)
// ---------------------------------------------------------
class QuestionPage extends StatelessWidget {
  final Map<String, dynamic> question;
  const QuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(question['title'])),
      body: Center(
        child: Column(
          // 👇 여기서 MainCenter라고 썼던 오타를 고쳤습니다!
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${question['title']} 테스트 시작!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text('여기서 질문이 하나씩 나올 거예요.'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('목록으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}