import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/bot.dart';
import 'models/message.dart';
import 'screens/login_screen.dart';
import 'screens/bot_list_screen.dart';
import 'screens/bot_profile_screen.dart';
import 'screens/chat_screen.dart';
// import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // For Android/iOS: use device directory
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  // Register adapters
  Hive.registerAdapter(BotAdapter());
  Hive.registerAdapter(MessageAdapter());

  // Open boxes
  await Hive.openBox<Bot>('bots');
  // await Hive.openBox<List>('chats'); // Maps bot.key to list<Message>
  for (var bot in Hive.box<Bot>('bots').values) {
    await Hive.openBox<Message>('chat_${bot.key}');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Companion Bot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {
        // '/': (context) => const HomePage(),
        '/': (context) => const LoginScreen(),
        '/botList': (context) => const BotListScreen(),
        '/botProfile': (context) => const BotProfileScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
