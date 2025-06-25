// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 2;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      sku: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      imageUrl: fields[3] as String,
      stock: fields[4] as int,
      groupId: fields[5] as int?,
      taxRate: fields[6] as double?,
      taxedPrice: fields[7] as double?,
      category: fields[8] as Category?,
      salePrice: fields[9] as double?,
      taxedSalePrice: fields[10] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.sku)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.stock)
      ..writeByte(5)
      ..write(obj.groupId)
      ..writeByte(6)
      ..write(obj.taxRate)
      ..writeByte(7)
      ..write(obj.taxedPrice)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.salePrice)
      ..writeByte(10)
      ..write(obj.taxedSalePrice);
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
