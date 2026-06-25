class PuantajModel {
  final String id;
  final String personelAd;
  final String tarih; // YYYY-MM-DD
  final int yevmiye;
  final String durum; // Tam Gün, Yarım Gün, Mesai

  PuantajModel({
    required this.id,
    required this.personelAd,
    required this.tarih,
    required this.yevmiye,
    required this.durum,
  });

  Map<String, dynamic> toMap() {
    return {
      'personelAd': personelAd,
      'tarih': tarih,
      'yevmiye': yevmiye,
      'durum': durum,
    };
  }

  factory PuantajModel.fromMap(String id, Map<String, dynamic> map) {
    return PuantajModel(
      id: id,
      personelAd: map['personelAd'] ?? '',
      tarih: map['tarih'] ?? '',
      yevmiye: map['yevmiye'] ?? 0,
      durum: map['durum'] ?? 'Tam Gün',
    );
  }
}