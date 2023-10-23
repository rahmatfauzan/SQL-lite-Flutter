import 'package:flutter/material.dart';

class tes extends StatelessWidget {
  final String judul;
  final int id;

  const tes(this.judul, this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TES hasil"),
      ),
      body: Column(
        children: [
          Text("Judul: $judul"),
          Text("ID: $id"),
        ],
      ),
    );
  }
}
