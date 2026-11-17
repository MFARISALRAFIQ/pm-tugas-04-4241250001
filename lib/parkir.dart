import 'dart:async';

// ===== Kendaraan (abstract) + subclass =====
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  String get jenis; // abstrak
  int get tarifPerJam; // abstrak

  /// Pembulatan ke atas per jam, minimal 1 jam.
  int biaya(DateTime keluar) {
    final menit = keluar.difference(waktuMasuk).inMinutes;
    final jam = (menit / 60).ceil();
    return (jam < 1 ? 1 : jam) * tarifPerJam;
  }
}

class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);
  @override
  String get jenis => 'Motor';
  @override
  int get tarifPerJam => 2000;
}

class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);
  @override
  String get jenis => 'Mobil';
  @override
  int get tarifPerJam => 5000;
}

class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);
  @override
  String get jenis => 'Truk';
  @override
  int get tarifPerJam => 10000;
}

// ===== Mixin: diskon 50% untuk member =====
mixin Berlangganan on Kendaraan {
  double get diskon => 0.5;

  @override
  int biaya(DateTime keluar) => (super.biaya(keluar) * (1 - diskon)).round();
}

class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);
  @override
  String get jenis => 'Mobil (member)';
}

// ===== Exception kustom =====
class ParkirPenuh implements Exception {
  final int kapasitas;
  ParkirPenuh(this.kapasitas);

  @override
  String toString() => 'Ditolak: Parkiran penuh (kapasitas $kapasitas)';
}

// ===== Parkiran =====
class Parkiran {
  final int kapasitas;
  final List<Kendaraan> _isi = []; // privat: enkapsulasi
  int _pendapatan = 0;
  final _log = StreamController<String>.broadcast();

  Parkiran(this.kapasitas);

  Stream<String> get log => _log.stream;
  int get sisa => kapasitas - _isi.length;
  int get pendapatan => _pendapatan;

  /// Simulasi palang masuk.
  Future<void> masuk(Kendaraan k) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_isi.length >= kapasitas) throw ParkirPenuh(kapasitas);
    _isi.add(k);
    _log.add('MASUK ${k.jenis} ${k.plat} (sisa $sisa)');
  }

  /// Simulasi palang keluar; mengembalikan biaya.
  Future<int> keluar(String plat, {DateTime? waktu}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final k = _isi.where((x) => x.plat == plat).firstOrNull;
    if (k == null) throw Exception('Kendaraan $plat tidak ada di parkiran');
    final bayar = k.biaya(waktu ?? DateTime.now());
    _isi.remove(k);
    _pendapatan += bayar;
    _log.add('KELUAR ${k.jenis} ${k.plat} bayar Rp$bayar');
    return bayar;
  }

  Future<void> tutup() => _log.close();
}
