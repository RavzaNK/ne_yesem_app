# Proje Gereksinim Dokümanı (PRD) - "Ne Yesem?" Uygulaması

## 1. Ürün Özeti (Executive Summary)
"Ne Yesem?", kullanıcıların günlük yemek kararı verme sürecindeki "kararsızlık" sorununa çözüm üreten, kişiselleştirilmiş bir yemek öneri ve planlama uygulamasıdır. Kullanıcıların diyet tercihlerini ve o anki modlarını baz alarak onlara en uygun yemekleri sunar.

## 2. Temel Hedefler
* Kullanıcının 30 saniyeden kısa sürede yemek kararı vermesini sağlamak.
* Kullanıcıya özel yemek planları oluşturarak beslenme düzenini optimize etmek.
* Dijital bir yemek günlüğü ile geçmiş kararları takip edilebilir kılmak.

## 3. Temel Özellikler (MVP)
* **Kullanıcı Profili:** Diyet tipi (Vegan, Glutensiz vb.), alerjiler ve sevilen/sevilmeyen gıdaların tanımlanması.
* **Akıllı Yemek Önerisi:** Kullanıcının profiline göre algoritmanın veya statik verinin yemek önermesi.
* **Dijital Günlük:** Kullanıcının yediği yemekleri kaydetmesi ve gün içerisindeki modunu (mutlu, yorgun, enerjik) belirtmesi.
* **Paylaşımlı Gündem:** Kullanıcının arkadaşları ile yemek planlarını senkronize edebilmesi.

## 4. Kullanıcı Senaryosu (User Flow)
1. **Giriş:** Kullanıcı uygulamayı açar.
2. **Mod Belirleme:** Kullanıcı o anki ruh halini ve "Ne yesem?" sorusunu uygulamaya yöneltir.
3. **Öneri:** Uygulama, kullanıcının profiline uygun 3 seçenek sunar.
4. **Seçim & Kayıt:** Kullanıcı birini seçer ve bu seçim otomatik olarak "Yemek Günlüğü"ne işlenir.

## 5. Teknik Gereksinimler
* **Frontend:** Flutter & Dart (UI/UX odaklı, responsive tasarım).
* **Backend:** Node.js & Express (API servisleri).
* **Veritabanı:** Firebase (Kullanıcı verileri, günlük kayıtları ve ajanda için).
* **Versiyon Kontrol:** Git & GitHub.

## 6. Gelecek Planları (Roadmap)
* Yapay zeka entegrasyonu (Kullanıcının seçmediği yemekleri öğrenip daha iyi öneriler yapma).
* Fotoğraf yükleme özelliği ile yemek günlüğünü görselleştirme.
* Market listesi oluşturma özelliği.
