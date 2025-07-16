import 'package:hive/hive.dart';

part 'bot.g.dart';

@HiveType(typeId: 0)
class Bot extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String tagline;

  @HiveField(2)
  String category;

  @HiveField(3)
  String greeting;

  @HiveField(4)
  String? profilePicPath;

  Bot({
    required this.name,
    required this.tagline,
    required this.category,
    required this.greeting,
    this.profilePicPath,
  });
}
