# 📂 Proje Geliştirme Yol Haritası (plan.md)

Bu dosya, BiteWise uygulamasının MVP (Minimum Uygulanabilir Ürün) geliştirme aşamalarını ve mimari kararlarını içerir.

## 🛠️ Faz 1: Altyapı ve Hazırlık
- [x] **Frontend Kurulumu:** Flutter SDK yapılandırması ve Material 3 tema entegrasyonu.
- [x] **Mimari Karar:** Veri yönetiminin UI dosyasından ayrılması (Separation of Concerns).

## 🎯 Faz 2: Veri ve Algoritma Geliştirme
- [x] **Veri Katmanı:** `data.dart` üzerinden asenkron çalışmaya uygun Map tabanlı veri tabanı kurgusu.
- [x] **Filtreleme Logic:** Alerjenlerin listeden çıkarılması ve kategori bazlı eşleşme algoritması.
- [x] **Şeker Algoritması:** Şeker tercihiyle tetiklenen "fit tatlı" çapraz sorgu mantığı.

## 🎨 Faz 3: Kullanıcı Deneyimi ve Arayüz
- [x] **Dinamik Seçim:** `ChoiceChip` ve `FilterChip` bileşenleriyle responsive panel tasarımı.
- [x] **Animasyon:** Karar verme sürecini simüle eden Timer tabanlı görsel geçişler.

## 🚀 Faz 4: Final ve Dokümantasyon
- [x] **Test:** Sonuçların tutarlılığı ve tekrar engelleme mekanizmasının kontrolü.
- [x] **Dokümantasyon:** README ve plan.md dosyalarının profesyonel standartlara getirilmesi.
