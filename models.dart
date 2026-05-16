// Kullanıcı profil verilerini tutan model
class UserProfile {
  final String username;
  final bool isGuest;
  final List<String> foodHistory; // Seçtiği yemeklerin geçmişi

  UserProfile({
    required this.username,
    required this.isGuest,
    required this.foodHistory,
  });
}
