import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String country;
  final String name;
  final String postalCode;

  const AddressModel({
    required this.country,
    required this.name,
    required this.postalCode,
  });

  @override
  List<Object> get props => [country, name, postalCode];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'name': name,
      'postalCode': postalCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      country: map['country'] as String,
      name: map['name'] as String,
      postalCode: map['postalCode'] as String,
    );
  }
}
