import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/widgets/retro_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final Crag crag;
  final PostType postType;

  const CreatePostScreen({
    super.key,
    required this.crag,
    this.postType = PostType.partnerRequest,
  });

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Partner request
  PartnerNeedType _partnerNeedType = PartnerNeedType.belay;
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
  String? _gradeRange;

  // Introduction
  String? _climbingLevel;
  final List<String> _selectedGoals = [];

  // Lost & Found
  LostFoundStatus _lostFoundStatus = LostFoundStatus.lost;
  LostFoundCategory _lostFoundCategory = LostFoundCategory.gear;
  final _itemNameController = TextEditingController();
  final _locationNoteController = TextEditingController();

  static const _goalOptions = [
    'Find belay partners',
    'Meet climbing friends',
    'Learn to lead',
    'Trad climbing',
    'Boulder harder',
    'Get outdoors more',
    'Multi-pitch',
    'Comp prep',
    'Chill sessions',
  ];

  static const _levelOptions = [
    '5.5-5.7',
    '5.8-5.9',
    '5.10a-5.10d',
    '5.11a-5.11d',
    '5.12a-5.12d',
    '5.13+',
    'V0-V2',
    'V3-V5',
    'V6-V8',
    'V9+',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _itemNameController.dispose();
    _locationNoteController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year, date.month, date.day, time.hour, time.minute,
          );
        });
      }
    }
  }

  void _submitPost() {
    if (!_formKey.currentState!.validate()) return;

    context.pop();

    final typeLabel = switch (widget.postType) {
      PostType.introduction => 'Introduction',
      PostType.partnerRequest => 'Partner request',
      PostType.lostFound => 'Lost & found item',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$typeLabel posted to ${widget.crag.name}',
          style: GoogleFonts.cabin(
              color: context.appColors.textOnPrimary, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final headerColor = switch (widget.postType) {
      PostType.introduction => c.accentBlue,
      PostType.partnerRequest => c.dullOrange,
      PostType.lostFound => c.amber,
    };
    final headerTitle = switch (widget.postType) {
      PostType.introduction => 'NEW INTRODUCTION',
      PostType.partnerRequest => 'FIND A PARTNER',
      PostType.lostFound => 'LOST & FOUND',
    };

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: headerColor,
        title: Text(
          headerTitle,
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: widget.postType == PostType.lostFound
                ? c.textOnTertiary
                : c.textOnPrimary,
          ),
        ),
        iconTheme: IconThemeData(
          color: widget.postType == PostType.lostFound
              ? c.textOnTertiary
              : c.textOnPrimary,
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 3),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Crag info
              _CragInfoCard(crag: widget.crag),
              const SizedBox(height: AppSpacing.lg),

              // Type-specific form
              switch (widget.postType) {
                PostType.introduction => _buildIntroductionForm(c),
                PostType.partnerRequest => _buildPartnerRequestForm(c),
                PostType.lostFound => _buildLostFoundForm(c),
              },

              const SizedBox(height: AppSpacing.lg),

              // Submit
              SizedBox(
                width: double.infinity,
                child: RetroButton(
                  label: 'Post',
                  icon: Icons.send,
                  color: headerColor,
                  shadowColor: c.shadowColor,
                  textColor: widget.postType == PostType.lostFound
                      ? c.textOnTertiary
                      : c.textOnPrimary,
                  onPressed: _submitPost,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  // ── Introduction form ─────────────────────────────────────────────────────

  Widget _buildIntroductionForm(AppColorsExtension c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(label: 'ABOUT YOU', color: c.accentBlue),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _titleController,
          style: GoogleFonts.cabin(fontSize: 14, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., "New to outdoor climbing — looking for friends!"',
            hintStyle: GoogleFonts.cabin(fontSize: 14, color: c.textDisabled),
          ),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a headline' : null,
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'YOUR STORY (OPTIONAL)', color: c.accentBlue),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _descriptionController,
          style: GoogleFonts.cabin(fontSize: 14, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: 'Tell people about yourself and what you\'re looking for...',
            hintStyle: GoogleFonts.cabin(fontSize: 14, color: c.textDisabled),
          ),
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'CLIMBING LEVEL', color: c.accentBlue),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _levelOptions.map((level) {
            final isSelected = _climbingLevel == level;
            return GestureDetector(
              onTap: () => setState(() => _climbingLevel = level),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? c.accentBlue : c.surface,
                  border: Border.all(
                    color: isSelected ? c.accentBlue : c.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  level,
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? c.textOnPrimary : c.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'CLIMBING GOALS', color: c.accentBlue),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _goalOptions.map((goal) {
            final isSelected = _selectedGoals.contains(goal);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  _selectedGoals.remove(goal);
                } else {
                  _selectedGoals.add(goal);
                }
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? c.oliveGreen : c.surface,
                  border: Border.all(
                    color: isSelected ? c.oliveGreen : c.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  goal,
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? c.textOnPrimary : c.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Partner request form ──────────────────────────────────────────────────

  Widget _buildPartnerRequestForm(AppColorsExtension c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(label: 'WHAT DO YOU NEED?', color: c.dullOrange),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: PartnerNeedType.values.map((type) {
            final isSelected = _partnerNeedType == type;
            final label = switch (type) {
              PartnerNeedType.belay => 'BELAY',
              PartnerNeedType.ropedPartner => 'ROPED',
              PartnerNeedType.boulderingBuddy => 'BOULDER',
            };
            final icon = switch (type) {
              PartnerNeedType.belay => Icons.safety_check,
              PartnerNeedType.ropedPartner => Icons.hiking,
              PartnerNeedType.boulderingBuddy => Icons.terrain,
            };
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: type != PartnerNeedType.boulderingBuddy
                        ? AppSpacing.sm
                        : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _partnerNeedType = type),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isSelected ? c.dullOrange : c.surface,
                      border: Border.all(
                        color: c.borderColor,
                        width: isSelected ? 3 : 2,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon,
                            size: 16,
                            color: isSelected
                                ? c.textOnPrimary
                                : c.textPrimary),
                        const SizedBox(height: 2),
                        Text(
                          label,
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? c.textOnPrimary
                                : c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'WHEN?', color: c.dullOrange),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: _selectDateTime,
          style: OutlinedButton.styleFrom(
            foregroundColor: c.textPrimary,
            side: BorderSide(color: c.borderColor, width: 2),
            shape: const RoundedRectangleBorder(),
          ),
          icon: const Icon(Icons.calendar_today),
          label: Text(
            DateFormat('EEE, MMM d \'at\' h:mm a').format(_selectedDateTime),
            style: GoogleFonts.spaceMono(fontSize: 12),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'POST TITLE', color: c.dullOrange),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _titleController,
          style: GoogleFonts.cabin(fontSize: 14, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., "Looking for belay partner"',
            hintStyle: GoogleFonts.cabin(fontSize: 14, color: c.textDisabled),
          ),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a title' : null,
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'GRADE RANGE (OPTIONAL)', color: c.dullOrange),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _levelOptions.map((level) {
            final isSelected = _gradeRange == level;
            return GestureDetector(
              onTap: () => setState(
                  () => _gradeRange = isSelected ? null : level),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? c.dullOrange : c.surface,
                  border: Border.all(
                    color: isSelected ? c.dullOrange : c.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  level,
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? c.textOnPrimary : c.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'DETAILS (OPTIONAL)', color: c.dullOrange),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _descriptionController,
          style: GoogleFonts.cabin(fontSize: 14, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: 'Add details about your plans...',
            hintStyle: GoogleFonts.cabin(fontSize: 14, color: c.textDisabled),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  // ── Lost & Found form ─────────────────────────────────────────────────────

  Widget _buildLostFoundForm(AppColorsExtension c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(label: 'STATUS', color: c.amber),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => _lostFoundStatus = LostFoundStatus.lost),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: _lostFoundStatus == LostFoundStatus.lost
                        ? c.dullOrange
                        : c.surface,
                    border: Border.all(
                      color: c.borderColor,
                      width: _lostFoundStatus == LostFoundStatus.lost ? 3 : 2,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search,
                            size: 18,
                            color: _lostFoundStatus == LostFoundStatus.lost
                                ? c.textOnPrimary
                                : c.textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          'I LOST',
                          style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _lostFoundStatus == LostFoundStatus.lost
                                ? c.textOnPrimary
                                : c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => _lostFoundStatus = LostFoundStatus.found),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: _lostFoundStatus == LostFoundStatus.found
                        ? c.oliveGreen
                        : c.surface,
                    border: Border.all(
                      color: c.borderColor,
                      width:
                          _lostFoundStatus == LostFoundStatus.found ? 3 : 2,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2,
                            size: 18,
                            color: _lostFoundStatus == LostFoundStatus.found
                                ? c.textOnPrimary
                                : c.textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          'I FOUND',
                          style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _lostFoundStatus == LostFoundStatus.found
                                ? c.textOnPrimary
                                : c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'CATEGORY', color: c.amber),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: LostFoundCategory.values.map((cat) {
            final isSelected = _lostFoundCategory == cat;
            final label = switch (cat) {
              LostFoundCategory.gear => 'Gear',
              LostFoundCategory.clothing => 'Clothing',
              LostFoundCategory.personalItem => 'Personal',
              LostFoundCategory.rope => 'Rope',
              LostFoundCategory.other => 'Other',
            };
            return GestureDetector(
              onTap: () => setState(() => _lostFoundCategory = cat),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? c.amber : c.surface,
                  border: Border.all(
                    color: isSelected ? c.amber : c.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? c.textOnTertiary : c.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'ITEM NAME', color: c.amber),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _itemNameController,
          style: GoogleFonts.cabin(fontSize: 14, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., "Orange Petzl Grigri"',
            hintStyle: GoogleFonts.cabin(fontSize: 14, color: c.textDisabled),
          ),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter item name' : null,
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'LOCATION (OPTIONAL)', color: c.amber),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _locationNoteController,
          style: GoogleFonts.cabin(fontSize: 14, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., "Near the parking lot"',
            hintStyle: GoogleFonts.cabin(fontSize: 14, color: c.textDisabled),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'DESCRIPTION (OPTIONAL)', color: c.amber),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _descriptionController,
          style: GoogleFonts.cabin(fontSize: 14, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: 'Any identifying details...',
            hintStyle: GoogleFonts.cabin(fontSize: 14, color: c.textDisabled),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}

// ── Shared form widgets ─────────────────────────────────────────────────────

class _CragInfoCard extends StatelessWidget {
  final Crag crag;
  const _CragInfoCard({required this.crag});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.fromBorderSide(
          BorderSide(color: c.borderColor, width: 2.5),
        ),
        boxShadow: [
          BoxShadow(
              color: c.shadowColor,
              offset: const Offset(5, 5),
              blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Icon(crag.isGym ? Icons.fitness_center : Icons.terrain,
              color: c.textPrimary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crag.name,
                  style: GoogleFonts.spaceMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                if (crag.region != null)
                  Text(
                    crag.region!,
                    style: GoogleFonts.spaceMono(
                        fontSize: 11, color: c.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Row(
      children: [
        Container(width: 3, height: 14, color: color),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }
}
