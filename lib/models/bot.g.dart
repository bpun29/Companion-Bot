// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BotAdapter extends TypeAdapter<Bot> {
  @override
  final int typeId = 0;

  @override
  Bot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bot(
      name: fields[0] as String,
      tagline: fields[1] as String,
      category: fields[2] as String,
      greeting: fields[3] as String,
    )..profilePicPath = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, Bot obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tagline)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.greeting)
      ..writeByte(4)
      ..write(obj.profilePicPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
