import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const StrawberryPavlova());
}

class StrawberryPavlova extends StatelessWidget {
  const StrawberryPavlova({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Strawberry Pavlova',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Strawberry Pavlova', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda con información
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Strawberry Pavlova',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Pavlova is a meringue-based dessert named after the Russian ballerine Anna Pavlova. Pavlova features a crisp crust and soft, light inside, topped with fruit and whipped cream.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                                  (index) => Icon(Icons.star,
                                  color: Colors.amber[600],
                                  size: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(

                            '170 Reviews',
                            style: TextStyle(color: Colors.grey[600], fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoColumn('PREP', '25 min', Icons.schedule),
                          _buildInfoColumn('COOK', '1 hr', Icons.outdoor_grill),
                          _buildInfoColumn('FEEDS', '4-6', Icons.person),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Columna derecha con imagen
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/strawberry_pavlova.png',
                      height: 300,
                      width: 38,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInfoColumn(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

