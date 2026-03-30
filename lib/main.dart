import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'main/mainlist_page.dart'; // 1. 경로랑 파일 이름 확인!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '심리 테스트 앱',
      theme: ThemeData(
        // 2. [중요] .fromSeed 앞에 'ColorScheme'이 꼭 있어야 해요!
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 3. [중요] MainPage가 아니라 'MainlistPage'로 이름을 맞춰야 합니다! (const 빼고요!)
      home: MainlistPage(),
    );
  }
}

