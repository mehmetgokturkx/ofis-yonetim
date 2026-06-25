import 'package:flutter/material.dart';
import '../models/harcama_model.dart';
import '../services/firestore_service.dart';

class HarcamalarScreen extends StatefulWidget {
  const HarcamalarScreen({super.key});

  @override
  State<HarcamalarScreen> createState() => _HarcamalarScreenState();
}

class _HarcamalarScreenState extends State<HarcamalarScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  // Form Kontrolcüleri
  final TextEditingController _aciklamaController = TextEditingController();
  final TextEditingController _tutarController = TextEditingController();
  String _secilenYer = 'Ofis'; // Varsayılan değer

  // Yeni Harcama Ekleme Paneli (Bottom Sheet)
  void _harcamaEklemePaneliGoster() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Yeni Harcama Ekle',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _aciklamaController,
                  decoration: const InputDecoration(
                    labelText: 'Açıklama (Örn: Ofis Yemek)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Lütfen bir açıklama girin' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tutarController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tutar (₺)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Lütfen tutar girin' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _secilenYer,
                  decoration: const InputDecoration(
                    labelText: 'Yer',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Ofis', child: Text('Ofis')),
                    DropdownMenuItem(value: 'Depo', child: Text('Depo')),
                    DropdownMenuItem(value: 'General', child: Text('General')),
                  ],
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _secilenYer = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _harcamaKaydet,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Kaydet'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // Veritabanına Kaydetme İşlemi
  void _harcamaKaydet() {
    if (_formKey.currentState!.validate()) {
      String bugun = DateTime.now().toString().split(' ')[0];

      final yeniHarcama = HarcamaModel(
        id: '', // Firestore otomatik ID verecek
        aciklama: _aciklamaController.text,
        yer: _secilenYer,
        tutar: int.tryParse(_tutarController.text) ?? 0,
        tarih: bugun,
      );

      _firestoreService.harcamaEkle(yeniHarcama);

      // Formu temizle ve paneli kapat
      _aciklamaController.clear();
      _tutarController.clear();
      Navigator.pop(context);
      
      // Başarılı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harcama başarıyla eklendi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harcamalar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _harcamaEklemePaneliGoster,
          ),
        ],
      ),
      body: StreamBuilder<List<HarcamaModel>>(
        stream: _firestoreService.harcamalariGetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz harcama eklenmedi.'));
          }

          final harcamalar = snapshot.data!;

          return ListView.builder(
            itemCount: harcamalar.length,
            itemBuilder: (context, index) {
              final harcama = harcamalar[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.receipt_long),
                  ),
                  title: Text(harcama.aciklama),
                  subtitle: Text('${harcama.yer} - ${harcama.tarih}'),
                  trailing: Text(
                    '${harcama.tutar} ₺',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  onLongPress: () {
                    _silmeOnayiGoster(harcama);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _harcamaEklemePaneliGoster,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Silme onay dialog'u
  void _silmeOnayiGoster(HarcamaModel harcama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Harcamayı Sil'),
        content: Text('${harcama.aciklama} harcamasını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              _firestoreService.harcamaSil(harcama.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Harcama silindi')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _aciklamaController.dispose();
    _tutarController.dispose();
    super.dispose();
  }
}