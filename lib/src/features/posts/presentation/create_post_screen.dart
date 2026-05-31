import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
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
    '5.5–5.7',
    '5.8–5.9',
    '5.10a–5.10d',
    '5.11a–5.11d',
    '5.12a–5.12d',
    '5.13+',
    'V0–V2',
    'V3–V5',
    'V6–V8',
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
          'saving posts coming soon',
          style: GoogleFonts.inter(
            color: context.appColors.canvas,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          'I’m climbing',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _VenueLine(crag: widget.crag),
              const SizedBox(height: 28),
              _buildForm(c),
              const SizedBox(height: 28),
              _PrimaryButton(label: 'post it', onTap: _submitPost),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AppColorsExtension c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Label(text: 'What do you need?'),
        const SizedBox(height: 8),
        Row(
          children: PartnerNeedType.values.map((type) {
            final isSelected = _partnerNeedType == type;
            final label = switch (type) {
              PartnerNeedType.belay => 'belay',
              PartnerNeedType.ropedPartner => 'roped',
              PartnerNeedType.boulderingBuddy => 'boulder',
            };
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: type != PartnerNeedType.boulderingBuddy ? 8 : 0,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _partnerNeedType = type),
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? c.ink : c.canvas,
                      border: Border.all(color: c.ink, width: 1.5),
                    ),
                    child: Text(
                      label,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? c.canvas : c.ink,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 22),
        const _Label(text: 'When?'),
        const SizedBox(height: 8),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _selectDateTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: c.canvas,
              border: Border.all(color: c.ink, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: c.ink),
                const SizedBox(width: 10),
                Text(
                  DateFormat('EEE, MMM d · h:mm a')
                      .format(_selectedDateTime)
                      .toLowerCase(),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: c.ink,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 22),
        const _Label(text: 'Title'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          style: GoogleFonts.inter(fontSize: 14, color: c.ink),
          decoration: InputDecoration(
            hintText: 'looking for a belay partner',
            hintStyle: GoogleFonts.inter(fontSize: 14, color: c.textDisabled),
          ),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'enter a title' : null,
        ),

        const SizedBox(height: 22),
        const _Label(text: 'Grade range (optional)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _levelOptions.map((level) {
            final isSelected = _gradeRange == level;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  setState(() => _gradeRange = isSelected ? null : level),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? c.ink : c.canvas,
                  border: Border.all(color: c.ink, width: 1.5),
                ),
                child: Text(
                  level,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? c.canvas : c.ink,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 22),
        const _Label(text: 'Details (optional)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          style: GoogleFonts.inter(fontSize: 14, color: c.ink),
          decoration: InputDecoration(
            hintText: 'add anything you want a partner to know…',
            hintStyle: GoogleFonts.inter(fontSize: 14, color: c.textDisabled),
          ),
          maxLines: 4,
        ),
      ],
    );
  }
}

// ─── Atoms ──────────────────────────────────────────────────────────────────

class _VenueLine extends StatelessWidget {
  final Crag crag;
  const _VenueLine({required this.crag});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Row(
      children: [
        Icon(
          crag.isGym ? Icons.fitness_center : Icons.terrain,
          size: 16,
          color: c.textSecondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            crag.name,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
        ),
        if (crag.region != null)
          Text(
            crag.region!,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: c.textSecondary,
              letterSpacing: -0.1,
            ),
          ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: c.textSecondary,
        letterSpacing: 0.1,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: c.ink,
          border: Border.all(color: c.ink, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: c.canvas,
          ),
        ),
      ),
    );
  }
}
