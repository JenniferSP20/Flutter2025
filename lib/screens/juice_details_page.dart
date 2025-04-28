import 'package:flutter/material.dart';
import 'package:tap2025/models/juice_entity.dart';
import 'package:tap2025/widgets/counter_widget.dart';

class JuiceDetailsPage extends StatefulWidget {
  final JuiceEntity juice;

  const JuiceDetailsPage({super.key, required this.juice});

  @override
  _JuiceDetailsPageState createState() => _JuiceDetailsPageState();
}

class _JuiceDetailsPageState extends State<JuiceDetailsPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: 0.86,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageHeight = constraints.maxHeight * 0.7;
                final imageHorizontalMargin = constraints.maxWidth * 0.15;
                final imageBottomMargin = constraints.maxHeight * 0.07;

                return Container(
                  decoration: BoxDecoration(
                    color: widget.juice.color,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: imageHorizontalMargin,
                        right: imageHorizontalMargin,
                        bottom: imageBottomMargin,
                      ),
                      child: Image.network(
                        widget.juice.image,
                        height: imageHeight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CounterWidget(
              currentCount: count,
              color: widget.juice.color,
              onIncreaseClicked: () {
                setState(() {
                  count++;
                });
              },
              onDecreaseClicked: () {
                setState(() {
                  count--;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
