import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cadastro.dart'; // Importa a página de cadastro
import 'package:intl/intl.dart'; // Importa o pacote intl

class EquipamentosPage extends StatefulWidget {
  @override
  _EquipamentosPageState createState() => _EquipamentosPageState();
}

class _EquipamentosPageState extends State<EquipamentosPage> {
  List<dynamic> equipamentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEquipamentos();
  }

  Future<void> fetchEquipamentos() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/api/equipamentos'));

      if (response.statusCode == 200) {
        setState(() {
          equipamentos = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar equipamentos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future<void> reservarEquipamento(int equipamentoId) async {
    // Implementação da reserva do equipamento
  }

  Future<void> liberarEquipamento(int equipamentoId) async {
    // Implementação da liberação do equipamento
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Equipamentos')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: equipamentos.length,
              itemBuilder: (context, index) {
                final equipamento = equipamentos[index];
                final dataHora = equipamento['dataHora'] != null
                    ? DateTime.parse(equipamento['dataHora'])
                    : null;

                return ListTile(
                  title: Text('${equipamento['nome']}'),
                  subtitle: Text(
                    dataHora != null
                        ? 'Retirado em: ${DateFormat('dd-MM-yy HH:mm').format(dataHora)}'
                        : 'Retirado em: Indefinido', // Alteração aqui
                  ),
                  trailing: equipamento['disponivel']
                      ? ElevatedButton(
                          onPressed: () {
                            reservarEquipamento(equipamento['id']);
                          },
                          child: Text('Reservar'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            liberarEquipamento(equipamento['id']);
                          },
                          child: Text('Liberar'),
                        ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroEquipamentoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
