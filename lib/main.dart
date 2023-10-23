import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqllite/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CRUD SQLLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController JudulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  List<Map<String, dynamic>> catatan = [];

  @override
  void initState() {
    super.initState();
    refreshcatatan();
  }

  void refreshcatatan() async {
    final data = await SQLHelper.getCatatan();
    setState(() {
      catatan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        modalForm(-1);
      }),
      body: ListView.builder(
        itemCount: catatan.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(catatan[index]['judul']),
            subtitle: Text(catatan[index]['deskripsi']),
            trailing: SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => modalForm(catatan[index]['id']),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => konfirmasiHapus(
                        catatan[index]['judul'], catatan[index]['id']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //fungsi tambah
  Future<void> tambahCatatan() async {
    await SQLHelper.tambahCatatan(
        JudulController.text, deskripsiController.text);
    refreshcatatan();
  }

  Future<void> ubahData(int id) async {
    await SQLHelper.ubahCatatan(
        id, JudulController.text, deskripsiController.text);
    refreshcatatan();
  }

  Future<void> hapusCatatan(int id) async {
    await SQLHelper.hapusCatatan(id);
    refreshcatatan();
  }

  void modalForm(int id) async {
    if (id != null) {
      final dataCatatan = catatan.firstWhere((element) => element['id'] == id);
      JudulController.text = dataCatatan['deskripsi'];
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 800,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: JudulController,
                  decoration: InputDecoration(
                    hintText: 'Judul',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (id == -1) {
                      await tambahCatatan();
                    } else {
                      await ubahData(id);
                    }
                    JudulController.text = "";
                    deskripsiController.text = "";
                    Navigator.pop(context);
                  },
                  child: Text(id == -1 ? "Tambah" : "Ubah"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> konfirmasiHapus(String judul, int id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content:
              Text("Apakah Anda yakin ingin menghapus catatan \"$judul\"?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                await hapusCatatan(id);
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }
}
