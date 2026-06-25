import 'package:flutter/material.dart';
import '../models/puantaj_model.dart';
import '../services/firestore_service.dart';

class PuantajScreen extends StatefulWidget {
  const PuantajScreen({super.key});

  @override
  State<PuantajScreen> createState() => _PuantajScreenState();
}

class _PuantajScreenState extends State<PuantajScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  DateTime _secilenTarih = DateTime.now();

  void _puantajEkleDialog() {
    final TextEditingController adController = TextEditingController();
    final TextEditingController yevmiyeController = TextEditingController(text: "1500"); // Varsayılan yevmiye
    String durum = 'Tam Gün';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personel Yevmiye Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: adController, decoration: const InputDecoration(labelText: 'Personel Adı')),
            TextField(controller: yevmiyeController, decoration: const InputDecoration(labelText: 'Yevmiye (₺)'), keyboardType: TextInputType.number),
            DropdownButton<String>(
              value: durum,
              isExpanded: true,
              items: ['Tam Gün', 'Yarım Gün', 'Mesai', 'İzinli'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => durum = v!),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              if (adController.text.isNotEmpty) {
                _firestoreService.puantajEkle(PuantajModel(
                  id: '',
                  personelAd: adController.text,
                  tarih: _secilenTarih.toString().split(' ')[0],
                  yevmiye: int.parse(yevmiyeController.text),
                  durum: durum,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formatTarih = _secilenTarih.toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puantaj Cetveli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              DateTime? pick = await showDatePicker(
                context: context,
                initialDate: _secilenTarih,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (pick != null) setState(() => _secilenTarih = pick);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tarih:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatTarih, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PuantajModel>>(
              stream: _firestoreService.puantajlariGetir(formatTarih),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final list = snapshot.data!;
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final p = list[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(p.personelAd),
                      subtitle: Text(p.durum),
                      trailing: Text("${p.yevmiye} ₺", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      onLongPress: () => _firestoreService.puantajSil(p.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _puantajEkleDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}