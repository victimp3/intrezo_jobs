import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:typed_data';
import 'confirmation_screen.dart';

class ApplicationFormScreen extends StatefulWidget {
  final Map<String, dynamic> vacancy;

  const ApplicationFormScreen({Key? key, required this.vacancy}) : super(key: key);

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreed = false;
  int _commentLength = 0;
  PlatformFile? _selectedFile;
  bool _uploadingFile = false;

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _bestTimeController = TextEditingController();
  final _commentController = TextEditingController();
  final _experienceController = TextEditingController();
  final _languageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _citizenship;
  String? _contactMethod;
  String? _permitStatus;

  final List<String> countries = [
    'countries.estonia',
    'countries.finland',
    'countries.latvia',
    'countries.lithuania',
    'countries.poland',
    'countries.ukraine',
    'countries.other',
  ];

  final List<String> contactMethods = [ // ← обнови этот блок
    'contact_methods.phone',
    'contact_methods.email',
    'contact_methods.whatsapp',
    'contact_methods.viber',
    'contact_methods.telegram',
  ];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text =
      '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<String?> _uploadFile() async {
    if (_selectedFile == null) return null;
    setState(() => _uploadingFile = true);

    final storageRef = FirebaseStorage.instance.ref(
        'applications/${DateTime.now().millisecondsSinceEpoch}_${_selectedFile!.name}');
    Uint8List fileBytes = _selectedFile!.bytes!;

    await storageRef.putData(fileBytes);
    final url = await storageRef.getDownloadURL();

    setState(() => _uploadingFile = false);
    return url;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || !_agreed) return;

    String formattedName = _nameController.text.trim();
    formattedName = formattedName
        .split(' ')
        .map((word) => word.isEmpty
        ? ''
        : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');

    String? contactInfo = (_contactMethod == 'Email')
        ? _emailController.text.trim()
        : _phoneController.text.trim();

    String? fileUrl = await _uploadFile();

    await FirebaseFirestore.instance.collection('applications').add({
      'vacancy_title': widget.vacancy['title'],
      'full_name': formattedName,
      'date_of_birth': _dobController.text,
      'citizenship': _citizenship,
      'contact_info': contactInfo,
      'preferred_contact_method': _contactMethod,
      'best_time_to_contact': _bestTimeController.text,
      'permit_status': _permitStatus,
      'work_experience': _experienceController.text,
      'language_skills': _languageController.text,
      'comment': _commentController.text,
      'file_url': fileUrl ?? '',
      'submitted_at': DateTime.now(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(vacancy: widget.vacancy),
      ),
    );
  }
  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _dobController.clear();
    _bestTimeController.clear();
    _commentController.clear();
    _experienceController.clear();
    _languageController.clear();
    _emailController.clear();
    _phoneController.clear();
    setState(() {
      _citizenship = null;
      _contactMethod = null;
      _permitStatus = null;
      _commentLength = 0;
      _agreed = false;
      _selectedFile = null;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'error_email_empty'.tr();
    if (!value.contains('@') || !value.contains('.')) return 'error_email_invalid'.tr();
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'error_phone_empty'.tr();
    final phoneRegex = RegExp(r'^[0-9+\-\s]{6,}$');
    if (!phoneRegex.hasMatch(value)) return 'error_phone_invalid'.tr();
    return null;
  }

  Widget _buildInputField({
    required String label,
    required Widget child,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              children: requiredField
                  ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF001730), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF001730), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Ink(
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: Color(0xFF001730),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'application'.tr(),
          style: const TextStyle(fontFamily: 'RobotoMono', color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('main'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'full_name'.tr(),
                requiredField: true,
                child: TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('type_here'.tr()),
                  validator: (v) => v == null || v.isEmpty ? 'error_full_name'.tr() : null,
                ),
              ),

              _buildInputField(
                label: 'dob'.tr(),
                requiredField: true,
                child: TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: _inputDecoration('ddmmyyyy'.tr()),
                  validator: (v) => v == null || v.isEmpty ? 'error_dob'.tr() : null,
                ),
              ),

              _buildInputField(
                label: 'citizenship'.tr(),
                requiredField: true,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration('select_citizenship'.tr()),
                  value: _citizenship,
                  items: countries.map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.tr()), // ← здесь правильное место для перевода
                  )).toList(),
                  onChanged: (v) => setState(() => _citizenship = v),
                  validator: (v) => v == null ? 'error_citizenship'.tr() : null,
                ),
              ),

              _buildInputField(
                label: 'contact_method'.tr(),
                requiredField: true,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration('select_method'.tr()),
                  value: _contactMethod,
                  items: contactMethods.map((m) => DropdownMenuItem(
                    value: m,
                    child: Text(m.tr()), // ← перевод каждого метода
                  )).toList(),
                  onChanged: (v) => setState(() => _contactMethod = v),
                  validator: (v) => v == null ? 'error_contact_method'.tr() : null,
                ),
              ),

              if (_contactMethod == 'Email')
                _buildInputField(
                  label: 'email'.tr(),
                  requiredField: true,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('enter_email'.tr()),
                    validator: _validateEmail,
                  ),
                ),

              if (_contactMethod != null && _contactMethod != 'Email')
                _buildInputField(
                  label: 'phone'.tr(),
                  requiredField: true,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration('enter_phone'.tr()),
                    validator: _validatePhone,
                  ),
                ),

              _buildInputField(
                label: 'best_time'.tr(),
                requiredField: true,
                child: TextFormField(
                  controller: _bestTimeController,
                  decoration: _inputDecoration('type_here'.tr()),
                  validator: (v) => v == null || v.isEmpty ? 'error_best_time'.tr() : null,
                ),
              ),

              _buildInputField(
                label: 'permit'.tr(),
                requiredField: true,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration('select_option'.tr()),
                  value: _permitStatus,
                  items: ['Yes', 'No', 'In process']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _permitStatus = v),
                  validator: (v) => v == null ? 'error_permit'.tr() : null,
                ),
              ),

              const SizedBox(height: 24),
              Text('optional'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'experience'.tr(),
                child: TextFormField(
                  controller: _experienceController,
                  decoration: _inputDecoration('type_here'.tr()),
                  maxLines: 2,
                ),
              ),

              _buildInputField(
                label: 'languages'.tr(),
                child: TextFormField(
                  controller: _languageController,
                  decoration: _inputDecoration('type_here'.tr()),
                  maxLines: 3,
                ),
              ),

              _buildInputField(
                label: '${'comment'.tr()} ($_commentLength/500)',
                child: TextFormField(
                  controller: _commentController,
                  maxLength: 500,
                  maxLines: 3,
                  onChanged: (v) => setState(() => _commentLength = v.length),
                  decoration: _inputDecoration('type_comment'.tr()),
                ),
              ),

              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFile == null ? 'attach_file'.tr() : _selectedFile!.name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001730),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreed,
                    activeColor: const Color(0xFF4CAF50),
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'agree_data'.tr(),
                        children: const [
                          TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        foregroundColor: const Color(0xFF001730),
                        side: const BorderSide(color: Color(0xFF001730)),
                      ),
                      child: Text('clear'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_agreed && !_uploadingFile) ? _submitForm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001730),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _uploadingFile
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('send'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}