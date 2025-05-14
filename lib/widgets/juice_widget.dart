import 'package:flutter/material.dart';
import 'package:tap2025/models/juice_entity.dart';

class JuiceWidget extends StatelessWidget {
  final JuiceEntity juice;

  const JuiceWidget({super.key, required this.juice});

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return AspectRatio(
      aspectRatio: 1.25,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = constraints.maxHeight * 0.2;
          final leftPadding = constraints.maxWidth * 0.1;
          final imageWidth = constraints.maxWidth * 0.35;

          return Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: topPadding),
                decoration: BoxDecoration(
                  color: juice.color,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: topPadding,
                        left: leftPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            juice.name,
                            style: textStyle.copyWith(fontSize: 20),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$',
                                  style: textStyle.copyWith(fontSize: 16),
                                ),
                                TextSpan(
                                   text: '25.99',
                                  style: textStyle.copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {Navigator.pushNamed(context, '/cha', arguments: [juice.id, juice.name,juice.image, juice.price, juice.descripcion]);},
                              child: const Text('Comprar ahora'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 159, 185, 205), 
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: imageWidth,
                    child: Image.asset(
                      juice.image,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
