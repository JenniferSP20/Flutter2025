import 'package:flutter/material.dart';
import 'package:tap2025/widgets/juice_widget.dart'; 
import 'package:tap2025/models/juice_entity.dart'; 

class ChallengScreen extends StatelessWidget {
  const ChallengScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final juiceList = [
      JuiceEntity(
        name: 'Tokyo Revengers',
        image: 'assets/1.jpg',
        price: '19.99',
        color: const Color.fromARGB(255, 187, 186, 183),
      ),
      JuiceEntity(
        name: 'kimetsu no yaiba',
        image: 'assets/2.jpeg',
        price: '25.99',
        color: const Color.fromARGB(255, 205, 170, 180),
      ),
      JuiceEntity(
        name: 'Nanatsu no taizai',
        image: 'assets/3.jpeg',
        price: '19.99',
        color: const Color.fromARGB(255, 120, 105, 121),
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
