import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/widgets/retro_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  final AppUser user;
  const EditProfileSheet({super.key, required this.user});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;
  late Set<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.displayName);
    _bioCtrl = TextEditingController(text: widget.user.bio ?? '');
    _selectedTags = Set.from(widget.user.climbingTags);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_selectedTags.contains(tagId)) {
        _selectedTags.remove(tagId);
      } else {
        _selectedTags.add(tagId);
      }
    });
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    final bio = _bioCtrl.text.trim();
    ref.read(currentUserNotifierProvider.notifier).updateProfile(
          displayName: name,
          bio: bio.isEmpty ? null : bio,
          climbingTags: _selectedTags.toList(),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        border: Border(
          top: BorderSide(color: c.borderColor, width: 3),
          left: BorderSide(color: c.borderColor, width: 3),
          right: BorderSide(color: c.borderColor, width: 3),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.darkGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(
              'EDIT PROFILE',
              style: GoogleFonts.spaceMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.borderColor,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Name field
            Text(
              'DISPLAY NAME',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _nameCtrl,
              style: GoogleFonts.cabin(fontSize: 15, color: c.textPrimary),
              decoration: const InputDecoration(hintText: 'Your name'),
            ),
            const SizedBox(height: AppSpacing.md),

            // Bio field
            Text(
              'BIO',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _bioCtrl,
              style: GoogleFonts.cabin(fontSize: 15, color: c.textPrimary),
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tell others about your climbing...',
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Tag sticker picker
            Row(
              children: [
                Text(
                  'VIBE CHECK',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (_selectedTags.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: c.oliveGreen,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      '${_selectedTags.length}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: ClimbingTags.all.map((tag) {
                final selected = _selectedTags.contains(tag.id);
                return GestureDetector(
                  onTap: () => _toggleTag(tag.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + 2,
                      vertical: AppSpacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? tag.color : c.chipBg,
                      border: Border.all(
                        color: selected ? tag.color : c.darkGrey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: tag.color.withAlpha(80),
                                offset: const Offset(2, 2),
                                blurRadius: 0,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      tag.label,
                      style: GoogleFonts.spaceMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? (tag.color.computeLuminance() > 0.4
                                ? const Color(0xFF0F0F0F)
                                : Colors.white)
                            : c.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Save button
            RetroButton(
              label: 'Save',
              icon: Icons.check,
              color: c.oliveGreen,
              shadowColor: c.borderColor,
              textColor: Colors.white,
              onPressed: _save,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
