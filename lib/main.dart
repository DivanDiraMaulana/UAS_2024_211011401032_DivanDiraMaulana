import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(CryptoApp());

class CryptoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Prices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoListScreen(),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  List<dynamic> _cryptoData = [];

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _cryptoData = data['data'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Prices'),
      ),
      body: _cryptoData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cryptoData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cryptoData[index]['name']),
                  subtitle: Text('Price: \$${_cryptoData[index]['price_usd']}'),
                );
              },
            ),
    );
  }
}
