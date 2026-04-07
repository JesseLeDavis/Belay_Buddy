import 'package:freezed_annotation/freezed_annotation.dart';

part 'header_config.freezed.dart';
part 'header_config.g.dart';

@freezed
class HeaderPanel with _$HeaderPanel {
  const factory HeaderPanel({
    required int index, // 0-5, left to right
    String? assetUrl, // Firebase Storage download URL; null = use default
    @Default(0) double slideDelay, // stagger delay in ms
  }) = _HeaderPanel;

  factory HeaderPanel.fromJson(Map<String, dynamic> json) =>
      _$HeaderPanelFromJson(json);
}

@freezed
class HeaderConfig with _$HeaderConfig {
  const factory HeaderConfig({
    required String cragId,
    @Default([]) List<HeaderPanel> panels, // exactly 6
    DateTime? updatedAt,
    String? updatedBy,
  }) = _HeaderConfig;

  factory HeaderConfig.fromJson(Map<String, dynamic> json) =>
      _$HeaderConfigFromJson(json);
}
