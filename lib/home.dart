import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

// ignore: camel_case_types
class _homePageState extends State<homePage> {
  TextEditingController _cepController = TextEditingController();
  String _resultado = 'Seu endereco';

  void _buscarEndereco() async {
    String cep = _cepController.text;

    if (cep.isEmpty || cep.length != 8) {
      setState(() {
        _resultado = 'Cep inválido';
      });
      return;
    }
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> dados = json.decode(response.body);
      if (dados.containsKey('erro')) {
        setState(() {
          _resultado = 'Cep não encontrado';
        });
      } else {
        setState(() {
          _resultado =
              'Endereço: ${dados['logradouro']}, Bairro: ${dados['bairro']}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Via Cep'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _cepController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Digite o CEP', border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(onPressed: _buscarEndereco, child: const Text('Buscar')),
          const SizedBox(
            height: 16,
          ),
          Text(
            _resultado,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
