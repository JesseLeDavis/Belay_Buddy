/// Catalog of climbing identity stickers. Each tag is an id + display label;
/// rendering colors are dictated by the active theme (Chalk & Static uses
/// ink-on-canvas hairline chips everywhere these are shown).
class ClimbingTag {
  final String id;
  final String label;

  const ClimbingTag(this.id, this.label);
}

class ClimbingTags {
  ClimbingTags._();

  static const _tags = <ClimbingTag>[
    // Style
    ClimbingTag('dirtbag', 'DIRTBAG'),
    ClimbingTag('gumby', 'GUMBY'),
    ClimbingTag('crusher', 'CRUSHER'),
    ClimbingTag('sandbagger', 'SANDBAGGER'),
    ClimbingTag('send_train', 'SEND TRAIN'),
    ClimbingTag('trad_dad', 'TRAD DAD'),
    ClimbingTag('sport_clipper', 'SPORT CLIPPER'),
    ClimbingTag('boulder_bro', 'BOULDER BRO'),
    ClimbingTag('offwidth_warrior', 'OFFWIDTH WARRIOR'),
    ClimbingTag('hand_jam_hero', 'HAND JAM HERO'),
    ClimbingTag('slab_wizard', 'SLAB WIZARD'),
    ClimbingTag('roof_rat', 'ROOF RAT'),
    ClimbingTag('spray_lord', 'SPRAY LORD'),
    ClimbingTag('beta_sprayer', 'BETA SPRAYER'),
    ClimbingTag('project_hunter', 'PROJECT HUNTER'),
    ClimbingTag('flash_machine', 'FLASH MACHINE'),
    ClimbingTag('onsight_or_bust', 'ONSIGHT OR BUST'),
    ClimbingTag('hangboard_goblin', 'HANGBOARD GOBLIN'),
    ClimbingTag('approach_hater', 'APPROACH HATER'),
    ClimbingTag('rest_day_denier', 'REST DAY DENIER'),
    ClimbingTag('chalk_fiend', 'CHALK FIEND'),

    // Vibes
    ClimbingTag('dawn_patrol', 'DAWN PATROL'),
    ClimbingTag('sunset_sends', 'SUNSET SENDS'),
    ClimbingTag('fair_weather', 'FAIR WEATHER ONLY'),
    ClimbingTag('rain_or_shine', 'RAIN OR SHINE'),
    ClimbingTag('van_life', 'VAN LIFE'),
    ClimbingTag('crag_dog_parent', 'CRAG DOG PARENT'),
    ClimbingTag('crag_dj', 'PLAYS DJ AT THE CRAG'),
    ClimbingTag('screamer', 'SCREAMER'),
    ClimbingTag('silent_sender', 'SILENT SENDER'),
    ClimbingTag('belay_bae', 'BELAY BAE'),
    ClimbingTag('first_ascensionist', 'FIRST ASCENSIONIST'),
    ClimbingTag('choss_pile_lover', 'CHOSS PILE LOVER'),
    ClimbingTag('tape_gloves', 'TAPE GLOVE GANG'),
    ClimbingTag('no_warm_up', 'NO WARM-UP'),
    ClimbingTag('perpetual_v4', 'PERPETUAL V4'),
    ClimbingTag('rope_gun', 'ROPE GUN'),
  ];

  static List<ClimbingTag> get all => _tags;

  static ClimbingTag? getById(String id) {
    for (final tag in _tags) {
      if (tag.id == id) return tag;
    }
    return null;
  }

  /// Deterministic rotation for sticker feel: slight tilt based on tag id.
  /// Kept in case the chip design later wants its old kinetic energy back.
  static double rotationFor(String id) {
    final hash = id.hashCode;
    // Range: -3 to +3 degrees
    return ((hash % 7) - 3) * 1.0;
  }
}
