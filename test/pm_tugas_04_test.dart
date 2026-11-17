import 'package:pm_tugas_04/parkir.dart';
import 'package:test/test.dart';

void main() {
  final masuk = DateTime(2026, 11, 17, 8, 0);

  test('biaya dibulatkan ke atas per jam', () {
    final motor = Motor('BK 1 A', masuk);
    expect(motor.biaya(DateTime(2026, 11, 17, 10, 30)), 6000); // 3 jam x 2000
  });

  test('minimal bayar 1 jam', () {
    final mobil = Mobil('BK 2 B', masuk);
    expect(mobil.biaya(DateTime(2026, 11, 17, 8, 5)), 5000);
  });

  test('mixin Berlangganan memberi diskon 50%', () {
    final member = MobilMember('BK 3 C', masuk);
    expect(member.biaya(DateTime(2026, 11, 17, 10, 30)), 7500);
  });

  test('parkiran penuh melempar ParkirPenuh', () async {
    final p = Parkiran(1);
    await p.masuk(Motor('BK 1 A', masuk));
    expect(p.masuk(Mobil('BK 2 B', masuk)), throwsA(isA<ParkirPenuh>()));
    await p.tutup();
  });
}
