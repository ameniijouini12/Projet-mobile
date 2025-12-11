import 'package:hive/hive.dart';
import 'package:hiatunisie/models/product.model.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 8;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Product(
      id: fields[0] as String? ?? '',
      name: fields[1] as String? ?? '',
      description: fields[2] as String?,
      price: (fields[3] as double?) ?? 0.0,
      image: fields[4] as String? ?? '',
      isAvailable: (fields[5] as bool?) ?? false,
      remise: (fields[6] as double?) ?? 0.0,
      remiseDeadline: fields[7] as DateTime? ?? DateTime.now(),
      marketId: fields[8] as String? ?? '',
      categoryId: fields[9] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(10) // Anzahl der Felder
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.isAvailable)
      ..writeByte(6)
      ..write(obj.remise)
      ..writeByte(7)
      ..write(obj.remiseDeadline)
      ..writeByte(8)
      ..write(obj.marketId)
      ..writeByte(9)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
