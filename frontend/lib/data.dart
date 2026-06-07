// MİMARİ NOTU: Bu dosya uygulamanın 'Backend' (Veri) katmanını temsil eder.
// Verilerin UI dosyasından ayrılması, projenin modülerliğini ve sürdürülebilirliğini sağlar.

class FoodData {
  static final Map<String, Map<String, dynamic>> database = {
    '🍕 Margarita Pizza': {'cat': 'Hepsi', 'drink': 'Fesleğenli Limonata', 'ings': ['gluten', 'süt']},
    '🌯 Adana Kebap': {'cat': '🔥 Acı', 'drink': 'Acılı Şalgam', 'ings': ['et']},
    '🥗 Sezar Salata': {'cat': '🥗 Hafif', 'drink': 'Maden Suyu', 'ings': ['tavuk', 'gluten']},
    '🍣 Sushi Roll': {'cat': '🥗 Hafif', 'drink': 'Soğuk Yeşil Çay', 'ings': ['balık']},
    '🍔 Klasik Burger': {'cat': 'Hepsi', 'drink': 'Buzlu Cola', 'ings': ['et', 'gluten', 'süt']},
    '🍝 Penne Arrabbiata': {'cat': '🔥 Acı', 'drink': 'Üzüm Suyu', 'ings': ['gluten']},
    '🥙 Falafel Dürüm': {'cat': '🌿 Vejetaryen', 'drink': 'Naneli Ayran', 'ings': ['gluten']},
    '🥗 Nohutlu Kinoa Salatası': {'cat': '🌿 Vejetaryen', 'drink': 'Portakal Suyu', 'ings': []},
    '🍲 Mercimek Köftesi': {'cat': '🌿 Vejetaryen', 'drink': 'Ev Yapımı Limonata', 'ings': ['gluten']},
    '🧇 Belçika Waffle': {'cat': '🍰 Tatlı', 'drink': 'Sütlü Kahve', 'ings': ['gluten', 'süt', 'şeker']},
    '🍮 Sütlaç': {'cat': '🍰 Tatlı', 'drink': 'Demleme Çay', 'ings': ['süt', 'şeker']},
    '🍰 Cheesecake': {'cat': '🍰 Tatlı', 'drink': 'Amerikano', 'ings': ['gluten', 'süt', 'şeker']},
    '🍌 Şekersiz Muzlu Puding': {'cat': '🍰 Tatlı', 'drink': 'Sütlü Kahve', 'ings': ['süt']},
    '🥥 Hindistan Cevizli Fit Toplar': {'cat': '🍰 Tatlı', 'drink': 'Bitki Çayı', 'ings': []},
    '🍎 Fırınlanmış Tarçınlı Elma': {'cat': '🍰 Tatlı', 'drink': 'Adaçayı', 'ings': []},
  };
}