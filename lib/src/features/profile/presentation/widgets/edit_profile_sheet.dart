import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
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
        color: c.canvas,
        border: Border(
          top: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 3,
                color: c.borderColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Edit profile',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
            const SizedBox(height: 22),

            // Name
            const _FieldLabel(text: 'Display name'),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              style: GoogleFonts.inter(fontSize: 15, color: c.ink),
              decoration: const InputDecoration(hintText: 'your name'),
            ),
            const SizedBox(height: 18),

            // Bio
            const _FieldLabel(text: 'Bio'),
            const SizedBox(height: 6),
            TextField(
              controller: _bioCtrl,
              style: GoogleFonts.inter(fontSize: 15, color: c.ink),
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'a sentence about your climbing',
              ),
            ),
            const SizedBox(height: 18),

            // Tags
            Row(
              children: [
                const _FieldLabel(text: 'Vibes'),
                const SizedBox(width: 8),
                Text(
                  '${_selectedTags.length}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: c.textDisabled,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: ClimbingTags.all.map((tag) {
                final selected = _selectedTags.contains(tag.id);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _toggleTag(tag.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? c.ink : c.canvas,
                      border: Border.all(
                        color: selected ? c.ink : c.textDisabled,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      tag.label.toLowerCase(),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: selected ? c.canvas : c.textSecondary,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Save
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _save,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: c.ink,
                  border: Border.all(color: c.ink, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  'save',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.canvas,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

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
