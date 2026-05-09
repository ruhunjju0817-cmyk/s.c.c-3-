import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../sub/question_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class MainlistPage extends StatefulWidget {
  const MainlistPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainlistPage();
}

class _MainlistPage extends State<MainlistPage> {
  //firebase databaseURL
  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://scc-project-d5c12-default-rtdb.firebaseio.com/',
  );

  // JSON 데이터를 가져오는 함수 -> 목록을 Firebase에 업로그, Firebase에서 데이터를 가져오는 함수
  // Firebase 업로드 코드
  Future<void> uploadJsonToFirebase() async {
    DatabaseReference ref = database.ref('test');
    String jsonString = await rootBundle.loadString('res/api/list.json',);
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    await ref.remove();
    await ref.set(jsonData['questions']);
  }

  // 개별 심리테스트를 Firebase에 업로드
  Future<void> uploadTestFilesToFirebase() async {
    final ref = database.ref('tests');

    final testFiles = ['test_1', 'test_2', 'test_3'];

    await ref.remove();

    for (final fileName in testFiles) {
      final jsonString = await rootBundle.loadString('res/api/$fileName.json');
      final jsonData = jsonDecode(jsonString);

      await ref.child(fileName).set(jsonData);
    }

    print('개별 심리테스트 업로드 완료');
  }

  // Firebase 읽기 함수
  Future<List<Map<String, dynamic>>> loadFirebase() async {
    DatabaseReference ref = database.ref('test');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.value == null) return [];

    final list = List<dynamic>.from(snapshot.value as List);

    return list
        .where((item) => item != null)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  // 2. 피그마 디자인 테마 설정 (연핑크, 연두, 연하늘)
  final List<Color> cardColors = [
    const Color(0xFFFFF0F4), // 연애 애착 유형 (연핑크)
    const Color(0xFFEBF7ED), // 퍼스널 향기 찾기 (연두)
    const Color(0xFFE5F0FA), // 나를 닮은 개발 도구 (연하늘)
  ];

  final List<String> subtitles = [
    "불안형? 회피형?\n나의 연애 유형은?",
    "나에게서 나는\n분위기와 향기는?",
    "나의 업무 스타일은\n어떤 언어와 같을까?"
  ];

  final List<String> emojis = ["💖", "🌿", "💻"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFBFBF9), // 피그마 오프화이트 배경
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // --- [피그마 헤더] ---
              const Text(
                '오늘의 심리 테스트!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E2235),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '나에게 꼭 맞는 테스트를 골라보세요!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

            // --- [리스트 카드 부분] ---
              // --- [리스트 카드] ---
              Expanded(
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                        //json 변환 과정 수정
                        final item = Map<String, dynamic>.from(snapshot.data![index] as Map);

                        int styleIndex = index % 3;

                        return GestureDetector(
                          onTap: () {
                            // 로딩 속도를 위해 await 없이 바로 전송 및 이동
                            FirebaseAnalytics.instance.logEvent(
                              name: "test_click",
                              parameters: {"test_name": item['title'].toString()},
                            );

                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return QuestionPage(
                                question: item['file'].toString(),
                                themeColor: cardColors[styleIndex], // 선택한 카드의 색상을 전달!
                              );
                            }));
                          },
                          // --- [개별 카드 디자인 설정] ---
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            decoration: BoxDecoration(
                              color: cardColors[styleIndex],
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${emojis[styleIndex]} ${item['title']} ${emojis[styleIndex]}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: styleIndex == 2 ? Colors.blue[800] : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  subtitles[styleIndex],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('데이터 로딩 실패'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
        // +버튼 클릭 시 data가 firebase에 저장
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              try {
                await uploadJsonToFirebase();
                await uploadTestFilesToFirebase();
                print('업로드 성공');

                setState(() {});
              } catch (e) {
                print('업로드 실패: $e');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('업로드 실패: $e'))
                );
              }
            }
        )
    );
  }
}