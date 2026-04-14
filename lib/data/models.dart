/// House names matching the JNV four-house system.
enum House {
  arawali('Arawali'),
  shivalik('Shivalik'),
  nilgiri('Nilgiri'),
  udaygiri('Udaygiri');

  const House(this.label);
  final String label;
}

/// One cohort under a house (e.g. 2010–2015, lateral entry).
class CohortNames {
  const CohortNames({required this.label, required this.names});

  final String label;
  final List<String> names;
}

/// One boy on a house page: cohort, photo (bundled asset), and social URLs.
class BoyMemberProfile {
  const BoyMemberProfile({
    required this.cohortLabel,
    required this.name,
    this.subtitle,
    this.photoAssetPath,
    this.facebookUrl,
    this.instagramUrl,
    this.whatsappUrl,
  });

  final String cohortLabel;
  final String name;
  final String? subtitle;
  final String? photoAssetPath;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? whatsappUrl;
}

/// Boys and girls name groups for a single house (same layout as index.html).
class HouseRoster {
  const HouseRoster({
    required this.house,
    required this.boysByCohort,
    required this.girlsByCohort,
  });

  final House house;
  final List<CohortNames> boysByCohort;
  final List<CohortNames> girlsByCohort;
}
