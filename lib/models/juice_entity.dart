import 'package:flutter/material.dart'; 

class JuiceEntity {
  final int id;
  final String name;
  final String image;
  final String price;
  final Color color;
  final String descripcion;

  JuiceEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.color,
    required this.descripcion
  });
}
