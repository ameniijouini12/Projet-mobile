import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hive/hive.dart';

class MarketAdapter extends TypeAdapter<Market> {
  @override
  final int typeId = 7;

  @override
  Market read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Market(
  id: fields[0] as String? ?? '',
  name: fields[1] as String? ?? '',
  image: fields[2] as String? ?? '',
  langitude: fields[3] as double? ?? 0.0,
  latitude: fields[4] as double? ?? 0.0,
  address: fields[5] as String? ?? '',
  phone: fields[6] as String? ?? '',
  isOpened: fields[7] as bool? ?? false,
  products: (fields[8] as List?)?.cast<Product>(),
  categories: (fields[9] as List?)?.cast<String>(),
);

  }

  @override
  void write(BinaryWriter writer, Market obj) {
   writer
  ..writeByte(10) 
  ..writeByte(0)
  ..write(obj.id)
  ..writeByte(1)
  ..write(obj.name)
  ..writeByte(2)
  ..write(obj.image)
  ..writeByte(3)
  ..write(obj.langitude)
  ..writeByte(4)
  ..write(obj.latitude)
  ..writeByte(5)
  ..write(obj.address)
  ..writeByte(6)
  ..write(obj.phone)
  ..writeByte(7)
  ..write(obj.isOpened)
  ..writeByte(8)
  ..write(obj.products)
  ..writeByte(9)
  ..write(obj.categories);

      
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
