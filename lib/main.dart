import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/harcamalar_screen.dart';
import 'screens/puantaj_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/excel_service.dart';
import 'models/harcama_model.dart';
import 'models/puantaj_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "YOUR_API_KEY_HERE", 
      appId: "YOUR_APP_ID_HERE", 
      messagingSenderId: "YOUR_SENDER_ID_HERE", 
      projectId: "YOUR_PROJECT_ID_HERE", 
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ofis Yönetim',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _currentIndex = 0;
  final List<Widget> _ekranlar = [
    const HarcamalarScreen(),
    const PuantajScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofis Yönetim', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download, color: Colors.green, size: 30),
            tooltip: 'Excel Raporu Al',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel hazırlanıyor...')));
              
              var harcamaSnapshot = await FirebaseFirestore.instance.collection('harcamalar').get();
              var puantajSnapshot = await FirebaseFirestore.instance.collection('puantajlar').get();
              
              List<HarcamaModel> hList = harcamaSnapshot.docs.map((d) => HarcamaModel.fromMap(d.id, d.data())).toList();
              List<PuantajModel> pList = puantajSnapshot.docs.map((d) => PuantajModel.fromMap(d.id, d.data())).toList();
              
              await ExcelService.raporOlustur(hList, pList);
            },
          )
        ],
      ),
      body: _ekranlar[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Harcamalar'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_ind), label: 'Puantaj'),
        ],
      ),
    );
  }
}