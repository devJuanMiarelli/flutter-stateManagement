import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroEquipamentoPage extends StatefulWidget {
  @override
  _CadastroEquipamentoPageState createState() =>
      _CadastroEquipamentoPageState();
}

class _CadastroEquipamentoPageState extends State<CadastroEquipamentoPage> {
  final TextEditingController _nomeController = TextEditingController();
  bool _disponivel = true;

  Future<void> cadastrarEquipamento() async {
    final String nome = _nomeController.text;

    // Captura a data/hora atual
    final String dataHora = DateTime.now().toIso8601String();

    final Map<String, dynamic> data = {
      "nome": nome,
      "disponivel": _disponivel,
      "dataHora": dataHora, // Adiciona o campo dataHora
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/equipamentos'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      // Adicionando debug para verificar status e resposta
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Equipamento cadastrado com sucesso!'),
        ));
        Navigator.pop(context);
      } else {
        // Exibe mensagem de erro se o status não for 201
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Falha ao cadastrar equipamento. Tente novamente.'),
        ));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao cadastrar equipamento'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Equipamento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Equipamento'),
            ),
            Row(
              children: [
                Checkbox(
                  value: _disponivel,
                  onChanged: (value) {
                    setState(() {
                      _disponivel = value!;
                    });
                  },
                ),
                Text('Disponível'),
              ],
            ),
            ElevatedButton(
              onPressed: cadastrarEquipamento,
              child: Text('Cadastrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar para a consulta'),
            ),
          ],
        ),
      ),
    );
  }
}
