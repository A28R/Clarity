// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyUserDataAdapter extends TypeAdapter<MyUserData> {
  @override
  final int typeId = 0;

  @override
  MyUserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyUserData(
      colors: fields[0] as String,
      model: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyUserData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.colors)
      ..writeByte(1)
      ..write(obj.model);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
