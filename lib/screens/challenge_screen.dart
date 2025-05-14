import 'package:flutter/material.dart';
import 'package:tap2025/widgets/juice_widget.dart'; 
import 'package:tap2025/models/juice_entity.dart'; 

class ChallengScreen extends StatelessWidget {
  const ChallengScreen({super.key});
@override
Widget build(BuildContext context) {
  final juiceList = [
    JuiceEntity(
      id: 1,
      name: 'Tokyo Revengers',
      image: 'assets/1.jpg',
      price: '19.99',
      color: const Color.fromARGB(255, 187, 186, 183),
      descripcion: 'Una historia intensa de pandillas juveniles, viajes en el tiempo y redención. Perfecto para quienes disfrutan la acción con drama.',
    ),
    JuiceEntity(
      id: 2,
      name: 'Kimetsu no Yaiba',
      image: 'assets/2.jpeg',
      price: '25.99',
      color: const Color.fromARGB(255, 205, 170, 180),
      descripcion: 'Un viaje épico lleno de demonios, espadas y emociones. Una obra de arte visual con una narrativa poderosa.',
    ),
    JuiceEntity(
      id: 3,
      name: 'Nanatsu no Taizai',
      image: 'assets/3.jpeg',
      price: '19.99',
      color: const Color.fromARGB(255, 120, 105, 121),
      descripcion: 'Siete pecados capitales, caballeros legendarios y batallas épicas. Una mezcla de fantasía y humor que atrapa desde el primer episodio.',
    ),
  ];
  

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challeng App'),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            return JuiceWidget(juice: juiceList[index]);
          },
          itemCount: juiceList.length,
        ),
      ),
    );
  }
}
