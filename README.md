# 🍽️ Ne Yesem? - Akıllı Gastronomi Asistanı

Kararsız kullanıcılar için geliştirilmiş, akıllı filtreleme sistemine sahip bir mobil gastronomi asistanıdır. Kullanıcının ruh haline, diyet tercihlerine ve sağlık hassasiyetlerine (alerjenler) göre en uygun yemek-içecek eşleşmesini sunar.

## ✨ Öne Çıkan Teknik Özellikler

* **🎯 Akıllı Filtreleme (Smart Filter Logic):** Uygulama sadece rastgele bir seçim yapmaz. Seçilen kategori (Acı, Hafif, Vejetaryen vb.) ile kullanıcının belirttiği alerjenleri (Gluten, Şeker, Süt vb.) çapraz sorgulayarak kişiye özel güvenli bir liste oluşturur.
* **🥤 Gurme Eşleştirme (Data Mapping):** Her yemek, kendi karakterine en uygun içecekle (Örn: Adana Kebap - Acılı Şalgam, Fit Puding - Bitki Çayı) eşleştirilmiştir.
* **🍬 Şeker Hassasiyeti Algoritması:** "Tatlı" kategorisinde "Şeker" alerjisi/tercihi seçildiğinde, sistem otomatik olarak şekerli ürünleri eleyip meyve ve doğal içerikli "fit" alternatifleri sunar.
* **📱 Kullanıcı Odaklı Tasarım (UI/UX):** Flutter'ın `Wrap` ve `ChoiceChip` mimarisi kullanılarak, tüm seçeneklerin tek bir panelde, kaydırma gerektirmeden görülmesini sağlayan responsive bir arayüz sunulmuştur.

## 🛠️ Kullanılan Teknolojiler & Mimari

* **Dil/Framework:** Flutter & Dart
* **Algoritma:** Çok kriterli filtreleme ve "Last Result Tracking" (Üst üste aynı sonucun gelmesini engelleme mantığı).
* **Veri Yapısı:** Temiz kod (Clean Code) prensiplerine uygun, genişletilebilir Map yapıları.

---
> **Not:** Bu proje, **UPSchool & Future Talent** programı teknik bitirme projesi kapsamında, kullanıcı deneyimini ve algoritmik filtrelemeyi ön plana çıkarmak amacıyla geliştirilmiştir.
