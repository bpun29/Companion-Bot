import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isUser;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  String? imageUrl; // optional for image or GIF

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
  });
}
