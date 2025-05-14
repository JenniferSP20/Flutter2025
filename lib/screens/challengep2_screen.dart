import 'package:flutter/material.dart';

class Challengep2Screen extends StatefulWidget {
  const Challengep2Screen({super.key});

  @override
  State<Challengep2Screen> createState() => _Challengep2ScreenState();
}

class _Challengep2ScreenState extends State<Challengep2Screen> {
  int _productCount = 1;

  void _incrementCount() {
    setState(() {
      _productCount++;
    });
  }

  void _decrementCount() {
    if (_productCount > 1) {
      setState(() {
        _productCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<Object?>;
    final int id = args[0] as int;
    final String nombre = args[1] as String;
    final String imagen = args[2] as String;
    final String price = args[3] as String;
    final String descripcion = args[4] as String;

    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(imagen, height: 250, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$$price',
                  style: const TextStyle(fontSize: 22, color: Colors.green),
                ),
                const SizedBox(height: 16),
                Text(
                  descripcion,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _decrementCount,
                    ),
                    Text(
                      '$_productCount',
                      style: const TextStyle(fontSize: 24),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _incrementCount,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Objeto Comprado"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text("Agregar al carrito"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
