# 🗺️ Geliştirme ve Entegrasyon Planı (Plan.md) - BiteWise

This document outlines the step-by-step technical execution plan for the BiteWise application, tracking frontend, backend, and AI integration tasks.

## 🏁 Faz 1: Altyapı ve Klasör Modernizasyonu (Tamamlandı)
- [x] Projenin kök dizin yapısının `/frontend`, `/backend` ve `/prodocs` olarak ayrılması.
- [x] Tüm Flutter kaynak kodlarının ve konfigürasyonlarının `/frontend` dizinine taşınması.
- [x] Ürün Gereksinimleri Dokümanı (`PRD.md`) ve Teknoloji Yığını (`tech-stack.md`) dosyalarının oluşturulması.

## ⚙️ Faz 2: Backend Servis Katmanı ve API Tasarımı (Mevcut Aşama)
- [ ] Node.js (Express) tabanlı bağımsız bir lokal API sunucusu ayağa kaldırılması.
- [ ] Sunucu üzerinde `/api/analyze-nutrition` POST endpoint'inin tanımlanması.
- [ ] `@google/genai` SDK'sı entegre edilerek gerçek zamanlı yemek geçmişi analizi yapacak Prompt mimarisinin kurulması.
- [ ] API anahtarlarının güvenliği için sunucu tarafında çevre değişkenleri (`.env`) altyapısının kurulması.

## 📱 Faz 3: Frontend HTTP Entegrasyonu
- [ ] Flutter projesine `http` paketinin dahil edilmesi.
- [ ] `backend_service.dart` dosyasındaki kural tabanlı yapay zeka simülasyonunun kaldırılarak gerçek HTTP POST isteklerine dönüştürülmesi.
- [ ] Asenkron veri yükleme süreçleri için arayüzde yükleniyor (Loading indicator) durumlarının işlenmesi.

## 🚀 Faz 4: Canlıya Alma (Deployment) ve Kapanış
- [ ] Node.js backend servisinin Render/Vercel platformu üzerinde canlıya alınması.
- [ ] Flutter uygulamasının Web platformu için derlenerek (`flutter build web`) Firebase Hosting veya GitHub Pages üzerinde deploy edilmesi.
- [ ] Proje teslim dokümanlarının (`Progress.md`, `DesignSystem.md`) nihai hale getirilmesi.