import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/ticket_model.dart';
import '../providers/ticket_provider.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _files = [];
  final List<Uint8List> _bytes = [];

  String _category = 'Hardware';
  TicketPriority _priority = TicketPriority.medium;

  bool get _isDirty {
    return _titleController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty ||
        _files.isNotEmpty;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    final data = await file.readAsBytes();
    setState(() {
      _files.add(file);
      _bytes.add(data);
    });
  }

  Future<void> _pickFromGallery() async {
    final files = await _picker.pickMultiImage();
    if (files.isEmpty) return;
    for (final file in files) {
      final data = await file.readAsBytes();
      setState(() {
        _files.add(file);
        _bytes.add(data);
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _files.removeAt(index);
      _bytes.removeAt(index);
    });
  }

  Future<bool> _confirmLeave() async {
    if (!_isDirty) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yakin ingin keluar?'),
        content: const Text('Perubahan pada form belum disimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    final ticketProvider = context.read<TicketProvider>();

    final urls = <String>[];
    for (var i = 0; i < _files.length; i++) {
      final url = await ticketProvider.uploadAttachment(
        _bytes[i],
        _files[i].name,
      );
      if (url != null) {
        urls.add(url);
      }
    }

    if (_files.isNotEmpty && urls.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal upload lampiran. Tiket tetap disimpan tanpa lampiran.'),
          backgroundColor: Colors.orange,
        ),
      );
    }

    final ok = await ticketProvider.createTicket(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      priority: _priority,
      reporterId: user.id,
      attachments: urls,
    );

    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat tiket. Coba lagi.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tiket berhasil dikirim.')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TicketProvider>().isLoading;

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _confirmLeave();
        if (shouldLeave && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Buat Tiket Baru')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Judul Tiket',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tiket wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: const [
                  DropdownMenuItem(value: 'Hardware', child: Text('Hardware')),
                  DropdownMenuItem(value: 'Software', child: Text('Software')),
                  DropdownMenuItem(value: 'Network', child: Text('Network')),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _category = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TicketPriority>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Prioritas'),
                items: TicketPriority.values
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _priority = value);
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
                maxLines: 5,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Deskripsi wajib diisi';
                  if (text.length < 10) return 'Deskripsi minimal 10 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lampiran',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _pickFromCamera,
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Kamera'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _pickFromGallery,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Galeri'),
                          ),
                        ],
                      ),
                      if (_files.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 110,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _files.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      _bytes[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeAttachment(index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(Icons.close,
                                            size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(4)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      child: Text(
                                        _files[index].name,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: CustomButton(
              label: 'Kirim Tiket',
              onPressed: _submit,
              isLoading: isLoading,
            ),
          ),
        ),
      ),
    );
  }
}
