# Ofis Yönetim ve Puantaj Sistemi

Bu proje, ofis içi harcamaların ve personel puantaj kayıtlarının dijital ortamda tutulması, yönetilmesi ve raporlanması amacıyla geliştirilmiş bir mobil uygulamadır.

## 🚀 Özellikler
* **Harcama Takibi:** Tarih, mekan (Ofis, Depo, General vb.) ve tutar bazlı gider girişi.
* **Puantaj Cetveli:** Personel yevmiye takibi (Tam Gün, Yarım Gün, Mesai, İzinli statüleri).
* **Bulut Veritabanı:** Cloud Firestore ile gerçek zamanlı veri senkronizasyonu.
* **Raporlama:** Verilerin `.xlsx` formatında dışa aktarılması ve paylaşılması.

## 🛠 Kullanılan Teknolojiler
* **Framework:** Flutter (Dart)
* **Veritabanı:** Firebase Cloud Firestore
* **Paketler:** `excel`, `share_plus`, `path_provider`

## ⚠️ Bilinen Hatalar (Known Issues)
* **Fiziksel Cihazlarda Boş Excel Çıktısı:** Uygulama Xiaomi Redmi Note 7 gibi bazı fiziksel cihazlarda test edildiğinde, dışa aktarılan Excel dosyası 0 byte (boş) olarak oluşabilmektedir. Bu durum depolama izinleri (Storage Permissions) ve asenkron dosya yazma hızından kaynaklanmakta olup, bir sonraki yamada düzeltilecektir. Emülatör üzerinde geliştirme testleri devam etmektedir.

## 👨‍💻 Geliştirici
**Mehmet Göktürk**