class HarcamaModel {
  final String id;
  final String aciklama;
  final String yer;
  final int tutar;
  final String tarih; // Örn: 2026-05-22

  HarcamaModel({
    required this.id,
    required this.aciklama,
    required this.yer,
    required this.tutar,
    required this.tarih,
  });

  // Firebase'e veri gönderirken haritaya (Map) çeviriyoruz
  Map<String, dynamic> toMap() {
    return {
      'aciklama': aciklama,
      'yer': yer,
      'tutar': tutar,
      'tarih': tarih,
    };
  }

  // Firebase'den veri okurken modele çeviriyoruz
  factory HarcamaModel.fromMap(String id, Map<String, dynamic> map) {
    return HarcamaModel(
      id: id,
      aciklama: map['aciklama'] ?? '',
      yer: map['yer'] ?? '',
      tutar: map['tutar'] ?? 0,
      tarih: map['tarih'] ?? '',
    );
  }
}