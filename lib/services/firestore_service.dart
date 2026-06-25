import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/harcama_model.dart';
import '../models/puantaj_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Harcama İşlemleri ---
  Future<void> harcamaEkle(HarcamaModel harcama) async => 
      await _db.collection('harcamalar').add(harcama.toMap());

  Future<void> harcamaSil(String id) async => 
      await _db.collection('harcamalar').doc(id).delete();

  Stream<List<HarcamaModel>> harcamalariGetir() {
    return _db.collection('harcamalar').orderBy('tarih', descending: true).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => HarcamaModel.fromMap(doc.id, doc.data())).toList());
  }

  // --- Puantaj İşlemleri (Yeni) ---
  Future<void> puantajEkle(PuantajModel puantaj) async => 
      await _db.collection('puantajlar').add(puantaj.toMap());

  Future<void> puantajSil(String id) async => 
      await _db.collection('puantajlar').doc(id).delete();

  // Seçilen tarihteki puantajları getirir
  Stream<List<PuantajModel>> puantajlariGetir(String tarih) {
    return _db.collection('puantajlar')
        .where('tarih', isEqualTo: tarih)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PuantajModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}