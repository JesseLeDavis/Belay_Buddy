import 'dart:ui';

import 'package:belay_buddy/theme/app_theme.dart';

/// Catalog of fun climbing identity stickers. Each tag has a display label
/// and a color. Users pick from this list to decorate their profile.
class ClimbingTag {
  final String id;
  final String label;
  final Color color;

  const ClimbingTag(this.id, this.label, this.color);
}

class ClimbingTags {
  ClimbingTags._();

  static const _tags = <ClimbingTag>[
    // Style
    ClimbingTag('dirtbag', 'DIRTBAG', AppColors.dullOrange),
    ClimbingTag('gumby', 'GUMBY', AppColors.oliveGreen),
    ClimbingTag('crusher', 'CRUSHER', AppColors.error),
    ClimbingTag('sandbagger', 'SANDBAGGER', AppColors.accentBlue),
    ClimbingTag('send_train', 'SEND TRAIN', AppColors.dullOrange),
    ClimbingTag('trad_dad', 'TRAD DAD', AppColors.oliveGreen),
    ClimbingTag('sport_clipper', 'SPORT CLIPPER', AppColors.accentBlue),
    ClimbingTag('boulder_bro', 'BOULDER BRO', AppColors.oliveGreen),
    ClimbingTag('crack_addict', 'CRACK ADDICT', AppColors.dullOrange),
    ClimbingTag('slab_wizard', 'SLAB WIZARD', AppColors.accentBlue),
    ClimbingTag('roof_rat', 'ROOF RAT', AppColors.error),
    ClimbingTag('spray_lord', 'SPRAY LORD', AppColors.amber),
    ClimbingTag('beta_sprayer', 'BETA SPRAYER', AppColors.amber),
    ClimbingTag('project_hunter', 'PROJECT HUNTER', AppColors.dullOrange),
    ClimbingTag('flash_machine', 'FLASH MACHINE', AppColors.error),
    ClimbingTag('onsight_or_bust', 'ONSIGHT OR BUST', AppColors.accentBlue),
    ClimbingTag('hangboard_goblin', 'HANGBOARD GOBLIN', AppColors.oliveGreen),
    ClimbingTag('approach_hater', 'APPROACH HATER', AppColors.dullOrange),
    ClimbingTag('rest_day_denier', 'REST DAY DENIER', AppColors.error),
    ClimbingTag('chalk_fiend', 'CHALK FIEND', AppColors.amber),

    // Vibes
    ClimbingTag('dawn_patrol', 'DAWN PATROL', AppColors.accentBlue),
    ClimbingTag('sunset_sends', 'SUNSET SENDS', AppColors.dullOrange),
    ClimbingTag('fair_weather', 'FAIR WEATHER ONLY', AppColors.amber),
    ClimbingTag('rain_or_shine', 'RAIN OR SHINE', AppColors.oliveGreen),
    ClimbingTag('van_life', 'VAN LIFE', AppColors.oliveGreen),
    ClimbingTag('crag_dog_parent', 'CRAG DOG PARENT', AppColors.amber),
    ClimbingTag('crag_dj', 'PLAYS DJ AT THE CRAG', AppColors.accentBlue),
    ClimbingTag('screamer', 'SCREAMER', AppColors.error),
    ClimbingTag('silent_sender', 'SILENT SENDER', AppColors.accentBlue),
    ClimbingTag('belay_bae', 'BELAY BAE', AppColors.dullOrange),
    ClimbingTag('first_ascensionist', 'FIRST ASCENSIONIST', AppColors.oliveGreen),
    ClimbingTag('choss_pile_lover', 'CHOSS PILE LOVER', AppColors.dullOrange),
    ClimbingTag('tape_gloves', 'TAPE GLOVE GANG', AppColors.amber),
    ClimbingTag('no_warm_up', 'NO WARM-UP', AppColors.error),
    ClimbingTag('perpetual_v4', 'PERPETUAL V4', AppColors.oliveGreen),
    ClimbingTag('rope_gun', 'ROPE GUN', AppColors.error),
  ];

  static List<ClimbingTag> get all => _tags;

  static ClimbingTag? getById(String id) {
    for (final tag in _tags) {
      if (tag.id == id) return tag;
    }
    return null;
  }

  /// Deterministic rotation for sticker feel: slight tilt based on tag id.
  static double rotationFor(String id) {
    final hash = id.hashCode;
    // Range: -3 to +3 degrees
    return ((hash % 7) - 3) * 1.0;
  }
}
