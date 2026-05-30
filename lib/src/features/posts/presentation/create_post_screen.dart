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

  const CreatePostScreen({super.key, required this.crag});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  PartnerNeedType _partnerNeedType = PartnerNeedType.belay;
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
  String? _gradeRange;

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Partner request preview — saving posts coming soon',
          style: GoogleFonts.cabin(
              color: context.appColors.textOnPrimary, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.dullOrange,
        foregroundColor: c.textOnPrimary,
        title: Text(
          'FIND A PARTNER',
          style: GoogleFonts.spaceMono(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: c.textOnPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CragInfoCard(crag: widget.crag),
              const SizedBox(height: AppSpacing.md),
              _buildPartnerRequestForm(c),
              const SizedBox(height: AppSpacing.xl),
              RetroButton(
                label: 'POST IT',
                onPressed: _submitPost,
                color: c.dullOrange,
                textColor: c.textOnPrimary,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
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
