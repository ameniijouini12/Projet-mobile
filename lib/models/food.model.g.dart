// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodAdapter extends TypeAdapter<Food> {
  @override
  final int typeId = 0;

  @override
  Food read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Food(
      id: fields[12] as String,
      name: fields[0] as String,
      description: fields[1] as String,
      price: fields[2] as double,
      image: fields[3] as String,
      category: (fields[4] as List).cast<String>(),
      averageRating: fields[5] as int,
      ingredients: (fields[6] as List).cast<String>(),
      isAvailable: fields[7] as bool,
      remise: fields[8] as int,
      remiseDeadline: fields[9] as DateTime,
      reviews: (fields[10] as List?)?.cast<Review>(),
      establishment: fields[11] as Establishment,
    );
  }

  @override
  void write(BinaryWriter writer, Food obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.averageRating)
      ..writeByte(6)
      ..write(obj.ingredients)
      ..writeByte(7)
      ..write(obj.isAvailable)
      ..writeByte(8)
      ..write(obj.remise)
      ..writeByte(9)
      ..write(obj.remiseDeadline)
      ..writeByte(10)
      ..write(obj.reviews)
      ..writeByte(11)
      ..write(obj.establishment)
      ..writeByte(12)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
