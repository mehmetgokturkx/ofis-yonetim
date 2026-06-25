import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/harcama_model.dart';
import '../models/puantaj_model.dart';

class ExcelService {
  static Future<void> raporOlustur(List<HarcamaModel> harcamalar, List<PuantajModel> puantajlar) async {
    var excel = Excel.createExcel();
    
    // 'Sheet1'i silmek yerine yeniden adlandırıyoruz (Dosya bozulmasını önler)
    excel.rename('Sheet1', 'Harcamalar');
    Sheet sheetHarcama = excel['Harcamalar'];
    
    sheetHarcama.appendRow([
      TextCellValue('Tarih'), 
      TextCellValue('Kategori / Açıklama'), 
      TextCellValue('Tutar (₺)')
    ]);
    
    for (var h in harcamalar) {
      sheetHarcama.appendRow([
        TextCellValue(h.tarih), 
        TextCellValue(h.aciklama), 
        IntCellValue(h.tutar)
      ]);
    }

    // --- 2. PUANTAJ SAYFASI ---
    Sheet sheetPuantaj = excel['Puantaj'];
    sheetPuantaj.appendRow([
      TextCellValue('Tarih'), 
      TextCellValue('Personel Adı'), 
      TextCellValue('Durum'), 
      TextCellValue('Yevmiye (₺)')
    ]);
    
    for (var p in puantajlar) {
      sheetPuantaj.appendRow([
        TextCellValue(p.tarih), 
        TextCellValue(p.personelAd), 
        TextCellValue(p.durum), 
        IntCellValue(p.yevmiye)
      ]);
    }

    var fileBytes = excel.save();
    
    // Documents yerine Temporary directory kullanıyoruz (WhatsApp/Telegram okuyabilsin diye)
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/OfisYonetim_Rapor.xlsx';
    
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    await Share.shareXFiles([XFile(filePath)], text: 'Ofis Yönetim - Güncel Finans ve Puantaj Raporu');
  }
}