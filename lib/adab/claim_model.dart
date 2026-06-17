class Claim {
  const Claim({
    required this.name,
    required this.id,
    required this.activity,
    required this.credit,
    required this.status,
  });

  final String name;
  final String id;
  final String activity;
  final String credit;
  final ClaimStatus status;

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}

enum ClaimStatus { pending, approved, rejected }
