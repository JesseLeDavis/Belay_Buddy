import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:belay_buddy/widgets/retro_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final Crag crag;

  const CreatePostScreen({
    super.key,
    required this.crag,
  });

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  PostType _postType = PostType.immediate;
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));

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
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _submitPost() {
    if (!_formKey.currentState!.validate()) return;

    // Mock: just pop and show success
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Post submitted to ${widget.crag.name}',
          style: GoogleFonts.cabin(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'NEW POST',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Crag info card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.fromBorderSide(
                    BorderSide(color: AppColors.darkNavy, width: 2.5),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.darkNavy,
                      offset: Offset(5, 5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.terrain, color: AppColors.darkNavy),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.crag.name,
                            style: GoogleFonts.spaceMono(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                          if (widget.crag.region != null)
                            Text(
                              widget.crag.region!,
                              style: GoogleFonts.spaceMono(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Post type — BIG bold tabs
              Text(
                'WHEN ARE YOU CLIMBING?',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _postType = PostType.immediate;
                          _selectedDateTime = DateTime.now();
                        });
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: _postType == PostType.immediate
                              ? AppColors.dullOrange
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: AppColors.darkNavy,
                            width: _postType == PostType.immediate ? 3 : 2,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flash_on,
                                size: 18,
                                color: _postType == PostType.immediate
                                    ? Colors.white
                                    : AppColors.darkNavy,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'NOW',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _postType == PostType.immediate
                                      ? Colors.white
                                      : AppColors.darkNavy,
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
                      onTap: () {
                        setState(() {
                          _postType = PostType.scheduled;
                          _selectedDateTime =
                              DateTime.now().add(const Duration(hours: 1));
                        });
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: _postType == PostType.scheduled
                              ? AppColors.oliveGreen
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: AppColors.darkNavy,
                            width: _postType == PostType.scheduled ? 3 : 2,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: _postType == PostType.scheduled
                                    ? Colors.white
                                    : AppColors.darkNavy,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'PLANNED',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _postType == PostType.scheduled
                                      ? Colors.white
                                      : AppColors.darkNavy,
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

              // Date/time picker for scheduled
              if (_postType == PostType.scheduled) ...[
                OutlinedButton.icon(
                  onPressed: _selectDateTime,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkNavy,
                    side: const BorderSide(
                        color: AppColors.darkNavy, width: 2),
                    shape: const RoundedRectangleBorder(),
                  ),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    DateFormat('EEE, MMM d \'at\' h:mm a')
                        .format(_selectedDateTime),
                    style: GoogleFonts.spaceMono(fontSize: 12),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Title — with colored left border section header
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 14,
                    color: _postType == PostType.immediate
                        ? AppColors.dullOrange
                        : AppColors.oliveGreen,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'POST TITLE',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.cabin(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., "Looking for partner"',
                  hintStyle: GoogleFonts.cabin(
                    fontSize: 14,
                    color: AppColors.textDisabled,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 14,
                    color: _postType == PostType.immediate
                        ? AppColors.dullOrange
                        : AppColors.oliveGreen,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'DETAILS (OPTIONAL)',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descriptionController,
                style: GoogleFonts.cabin(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Add details about your plans...',
                  hintStyle: GoogleFonts.cabin(
                    fontSize: 14,
                    color: AppColors.textDisabled,
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Submit — full-width, orange fill, hard shadow
              SizedBox(
                width: double.infinity,
                child: RetroButton(
                  label: 'Submit Post',
                  icon: Icons.send,
                  color: AppColors.dullOrange,
                  shadowColor: AppColors.darkNavy,
                  textColor: Colors.white,
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
}
