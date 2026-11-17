import 'package:pm_tugas_04/parkir.dart';

Future<void> main() async {
  final parkiran = Parkiran(3);
  parkiran.log.listen(print); // layar pos jaga

  // Waktu masuk disimulasikan agar biayanya dapat diprediksi
  final masuk = DateTime(2026, 11, 17, 8, 0);
  final keluar = DateTime(2026, 11, 17, 10, 30); // 2,5 jam -> 3 jam

  // Polimorfisme: satu List berisi berbagai jenis kendaraan
  final antrean = <Kendaraan>[
    Motor('BK 1234 AB', masuk),
    Mobil('BK 88 UN', masuk),
    MobilMember('BK 7 MIPA', masuk),
    Truk('BK 9999 XX', masuk), // akan ditolak: penuh
  ];

  for (final k in antrean) {
    try {
      await parkiran.masuk(k);
    } on ParkirPenuh catch (e) {
      print(e);
    }
  }

  for (final k in antrean.take(3)) {
    await parkiran.keluar(k.plat, waktu: keluar);
  }
  await Future.delayed(
    Duration.zero,
  ); // beri kesempatan listener Stream mencetak log terakhir
  print('Pendapatan: Rp${parkiran.pendapatan}'); // 6000 + 15000 + 7500 = 28500
  await parkiran.tutup();
}
