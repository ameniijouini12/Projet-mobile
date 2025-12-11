// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfferAdapter extends TypeAdapter<Offer> {
  @override
  final int typeId = 1;

  @override
  Offer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Offer(
      name: fields[0] as String,
      description: fields[1] as String,
      image: fields[2] as String,
      food: (fields[3] as List).cast<Food>(),
      etablishment: fields[4] as Establishment,
      remise: fields[5] as int,
      validFrom: fields[6] as DateTime,
      validUntil: fields[7] as DateTime,
      isAvailable: fields[8] as bool,
      quantity: fields[9] as int,
      id: fields[10] as String,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      price: fields[13] as int,
      newPrice: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Offer obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.food)
      ..writeByte(4)
      ..write(obj.etablishment)
      ..writeByte(5)
      ..write(obj.remise)
      ..writeByte(6)
      ..write(obj.validFrom)
      ..writeByte(7)
      ..write(obj.validUntil)
      ..writeByte(8)
      ..write(obj.isAvailable)
      ..writeByte(9)
      ..write(obj.quantity)
      ..writeByte(10)
      ..write(obj.id)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.price)
      ..writeByte(14)
      ..write(obj.newPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
