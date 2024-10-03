import 'package:flutter/material.dart';
import 'database_helper.dart'; // Asegúrate de tener este archivo implementado

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DatabaseHelper.instance
        .getItems(); // Asegúrate de implementar getItems
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem(String name, int quantity) async {
    final newItem = {
      'name': name,
      'quantity': quantity,
    };
    await DatabaseHelper.instance.insertItem(newItem); // Implementa insertItem
    _loadItems();
  }

  Future<void> _updateItem(int id, String name, int quantity) async {
    final updatedItem = {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
    await DatabaseHelper.instance
        .updateItem(updatedItem); // Implementa updateItem
    _loadItems();
  }

  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.instance.deleteItem(id); // Implementa deleteItem
    _loadItems();
  }

  void _showItemDialog({Map<String, dynamic>? item}) {
    final nameController = TextEditingController(text: item?['name']);
    final quantityController =
        TextEditingController(text: item?['quantity']?.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Agregar Item' : 'Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (item == null) {
                  _addItem(
                    nameController.text,
                    int.parse(quantityController.text),
                  );
                } else {
                  _updateItem(
                    item['id'],
                    nameController.text,
                    int.parse(quantityController.text),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Agregar' : 'Actualizar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text('Cantidad: ${item['quantity']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: const Color.fromARGB(255, 121, 4, 121)),
                    onPressed: () => _showItemDialog(item: item),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(item['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
