import 'package:flutter/material.dart';

const String _title = 'StrawBerry';
const String _description = 'Hello, StrawBerry!';

void main() {
  runApp(const StrawBerry());
}

class StrawBerry extends StatefulWidget {
  const StrawBerry({super.key});

  @override
  _StrawBerryState createState() => _StrawBerryState();
}

class _StrawBerryState extends State<StrawBerry> {
  List<String> _items = [];
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrawBerry',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
        ),
        body: Column(
          children: [
            const Text(_description),
            const Align(
              alignment: Alignment.center,
              child: Text('Items'),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index]),
                  );
                },
                itemCount: _items.length,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _items.add('Item $_count');
                  _count++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Text('Add Item'),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _items.add('Item $_count');
              _count++;
            });
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}