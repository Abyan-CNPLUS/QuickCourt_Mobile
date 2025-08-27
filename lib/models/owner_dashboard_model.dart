class OwnerDashboardData {
  final int perluDiproses;
  final int kendala;
  final int dibatalkan;
  final int totalBookings;
  final int totalTransactions;
  final int totalBalance;

  OwnerDashboardData({
    required this.perluDiproses,
    required this.kendala,
    required this.dibatalkan,
    required this.totalBookings,
    required this.totalTransactions,
    required this.totalBalance,
  });

  factory OwnerDashboardData.fromJson(Map<String, dynamic> json) {
    return OwnerDashboardData(
      perluDiproses: json['perluDiproses'],
      kendala: json['kendala'],
      dibatalkan: json['dibatalkan'],
      totalBookings: json['totalBookings'],
      totalTransactions: json['totalTransactions'],
      totalBalance: json['totalBalance'],
    );
  }
}
