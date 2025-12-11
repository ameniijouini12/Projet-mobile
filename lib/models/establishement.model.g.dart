// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'establishement.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewAdapter extends TypeAdapter<Review> {
  @override
  final int typeId = 3;

  @override
  Review read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Review(
      user: fields[0] as User,
      comment: fields[1] as String?,
      rating: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Review obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EstablishmentAdapter extends TypeAdapter<Establishment> {
  @override
  final int typeId = 2;

  @override
  Establishment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Establishment(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      image: fields[3] as String?,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
      address: fields[6] as String?,
      averageRating: fields[7] as int?,
      phone: fields[8] as String?,
      isOpened: fields[9] as bool,
      preferences: (fields[10] as List?)?.cast<String>(),
      foods: (fields[11] as List?)?.cast<Food>(),
      reviews: (fields[12] as List?)?.cast<Review>(),
    );
  }

  @override
  void write(BinaryWriter writer, Establishment obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.averageRating)
      ..writeByte(8)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.isOpened)
      ..writeByte(10)
      ..write(obj.preferences)
      ..writeByte(11)
      ..write(obj.foods)
      ..writeByte(12)
      ..write(obj.reviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstablishmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
