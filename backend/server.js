require('dotenv').config(); // .env dosyasındaki değişkenleri yükler
const express = require('express');
const cors = require('cors');
const { GoogleGenAI } = require('@google/genai');

const app = express();
app.use(cors());
app.use(express.json());

// API Anahtarı Tanımlama (Eğer .env kullanacaksan böyle kalsın, kullanmayacaksan tırnak içinde buraya yaz)
const GEMINI_API_KEY = process.env.GEMINI_API_KEY || "Buraya_Gemini_API_Anahtarını_Yazabilirsin";

if (!GEMINI_API_KEY || GEMINI_API_KEY.includes("Buraya_Gemini")) {
    console.error("❌ UYARI: GEMINI_API_KEY bulunamadı! Lütfen anahtarınızı tanımlayın.");
}

const ai = new GoogleGenAI({ apiKey: GEMINI_API_KEY });

// =========================================================================
// 🎯 1. KÜRESEL ÇARK ENDPOINT'İ
// =========================================================================
app.post('/api/wheel/spin', async (req, res) => {
    try {
        const { category, flavor, excludedIngredients, cuisine, targetLanguage } = req.body;
        const selectedCuisine = cuisine || "Türk";
        const currentLang = targetLanguage || "Türkçe";

        const prompt = `
        Sen profesyonel bir gastronomi asistanısın. Kullanıcı çarkı döndürdü ve senden şu filtrelere uyan gerçek bir yemek/tatlı ve içecek kombinasyonu üretmeni istiyor:
        - MUTFAK KÖKENİ: ${selectedCuisine} Mutfağı
        - KATEGORİ: ${category}
        - LEZZET/AROMA: ${flavor}
        - ALERJENLER: ${excludedIngredients && excludedIngredients.length > 0 ? excludedIngredients.join(', ') : 'Yok'}

        DİL KURALI: Yanıtı tamamen "${currentLang}" dilinde ver.
        Yanıtı SADECE aşağıdaki saf JSON formatında ver, markdown veya açıklama satırı ekleme:
        {
          "food": "Yiyeceğin ${currentLang} dilindeki adı",
          "drink": "İçeceğin ${currentLang} dilindeki adı"
        }
        `;

        const response = await ai.models.generateContent({
            model: 'gemini-2.5-flash',
            contents: prompt,
        });

        let responseText = response.text.trim();
        const cleanJson = responseText.replace(/```json|```/g, "").trim();
        const foodMatch = JSON.parse(cleanJson);

        res.json(foodMatch);
    } catch (error) {
        console.error("Küresel Çark API Hatası:", error);
        // Hata durumunda ana yemek istendiyse köfte, istenmediyse cheesecake dönecek akıllı fallback:
        if (req.body.category === "Ana Yemek") {
            res.json({ "food": "Izgara Köfte", "drink": "Soğuk Ayran" });
        } else {
            res.json({ "food": "Limonlu Cheesecake", "drink": "Ferahlatıcı Bitki Çayı" });
        }
    }
});

// =========================================================================
// 🧠 2. KÜRESEL ANALİZ ENDPOINT'İ (Canlı AI Raporu)
// =========================================================================
app.post('/api/nutrition/analyze', async (req, res) => {
    try {
        const { username, foodHistory, userMod, currentCalorieBudget, targetLanguage } = req.body;
        const historyList = (foodHistory && foodHistory.length > 0) ? foodHistory : ["Henüz çark çevrilmedi"];
        const mod = userMod || "Nötr";
        const budget = currentCalorieBudget !== undefined ? currentCalorieBudget : 2000;
        const currentLang = targetLanguage || "Türkçe";
        const currentHour = new Date().getHours();

        const prompt = `Sen dünya çapında beslenme psikolojisi danışmanlığı yapan esprili ve zeki bir yapay zeka koçusun.
        Kullanıcı Bilgileri:
        - İsim: ${username}
        - Çarktan Çıkan Son Yemekler: [${historyList.join(', ')}]
        - Şu Anki Ruh Hali: ${mod}
        - Kalan Kalori Bütçesi: ${budget} kcal
        - Şu Anki Saat: ${currentHour}:00

        Senden isteğim kullanıcının modunu, saatini ve bütçesini analiz ederek ona esprili, samimi bir dille geri bildirim vermen. Ardından çarktan bağımsız olarak bu bütçeye ve moda uyacak, internetteki tariflerden beslenen sürpriz, sağlıklı ve gurme bir alternatif menü (1 yemek + 1 yan ürün/salata/içecek) önermen.
        
        Kural: Metnin son cümlesinde önerdiğin yemeğin adını tam olarak **Yemek Adı** ve yan ürünün adını **Yan Ürün Adı** şeklinde kalın (bold) yaz ki arayüzde ayrıştırabilelim. Maksimum 4-5 cümle olsun. Yanıt dili tamamen "${currentLang}" olmalı.`;

        const response = await ai.models.generateContent({
            model: 'gemini-2.5-flash',
            contents: prompt,
        });

        res.json({ analysis: response.text });
    } catch (error) {
        console.error("Küresel Analiz Hatası:", error);
        res.json({ analysis: "Cemile şu an mutfakta yoğun, lütfen daha sonra tekrar dene! 🍳" });
    }
});

// =========================================================================
// 🥣 3. DETAYLI TARİF GETİRME ENDPOINT'İ (Yenilik!)
// =========================================================================
app.post('/api/recipe', async (req, res) => {
    try {
        const { foodName, targetLanguage } = req.body;
        const currentLang = targetLanguage || "Türkçe";

        const prompt = `Kullanıcı '${foodName}' yemeğinin tarifini istiyor. 
        Bana malzemeleri ve hazırlanış adımlarını SADECE aşağıdaki saf JSON formatında döndür:
        {
          "ingredients": "Malzemelerin liste hali",
          "instructions": "Hazırlanış adımları sıralı hali"
        }
        DİL KURALI: Yanıtı tamamen "${currentLang}" dilinde ver.`;

        const response = await ai.models.generateContent({
            model: 'gemini-2.5-flash',
            contents: prompt,
        });

        let responseText = response.text.trim();
        const cleanJson = responseText.replace(/```json|```/g, "").trim();
        const recipeData = JSON.parse(cleanJson);

        res.json(recipeData);
    } catch (error) {
        console.error("Tarif API Hatası:", error);
        res.json({
            ingredients: `• 1 Porsiyon Taze ${foodName}\n• 2 yemek kaşığı Sızma Zeytinyağı\n• Gurme Baharat Karışımı`,
            instructions: "1. Malzemeleri taze olarak temin edip temizleyin.\n2. Besin değerini koruyacak sağlıklı pişirme teknikleriyle hazırlayın."
        });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 BiteWise Küresel AI Sunucusu ${PORT} portunda çalışıyor.`));