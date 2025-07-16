import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
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
    'Estonia', 'Finland', 'Latvia', 'Lithuania', 'Poland', 'Ukraine', 'Other'
  ];

  final List<String> contactMethods = [
    'Phone', 'Email', 'WhatsApp', 'Viber', 'Telegram'
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
    if (value == null || value.isEmpty) return 'Please enter email';
    if (!value.contains('@') || !value.contains('.')) return 'Invalid email address';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Please enter phone number';
    final phoneRegex = RegExp(r'^[0-9+\-\s]{6,}$');
    if (!phoneRegex.hasMatch(value)) return 'Invalid phone number';
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
        title: const Text(
          'APPLICATION',
          style: TextStyle(fontFamily: 'RobotoMono', color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MAIN', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Your Full Name',
                requiredField: true,
                child: TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('Type here'),
                  validator: (v) => v == null || v.isEmpty ? 'Please enter your full name' : null,
                ),
              ),

              _buildInputField(
                label: 'Date of Birth',
                requiredField: true,
                child: TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: _inputDecoration('DD.MM.YYYY'),
                  validator: (v) => v == null || v.isEmpty ? 'Please select your birth date' : null,
                ),
              ),

              _buildInputField(
                label: 'Citizenship',
                requiredField: true,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Select your citizenship'),
                  value: _citizenship,
                  items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _citizenship = v),
                  validator: (v) => v == null ? 'Please select citizenship' : null,
                ),
              ),

              _buildInputField(
                label: 'Preferred Method of Contact',
                requiredField: true,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Select method'),
                  value: _contactMethod,
                  items: contactMethods.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _contactMethod = v),
                  validator: (v) => v == null ? 'Please select method' : null,
                ),
              ),

              if (_contactMethod == 'Email')
                _buildInputField(
                  label: 'Email Address',
                  requiredField: true,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Enter your email'),
                    validator: _validateEmail,
                  ),
                ),

              if (_contactMethod != null && _contactMethod != 'Email')
                _buildInputField(
                  label: 'Phone Number',
                  requiredField: true,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration('Enter your phone number'),
                    validator: _validatePhone,
                  ),
                ),

              _buildInputField(
                label: 'Best Time to Contact You',
                requiredField: true,
                child: TextFormField(
                  controller: _bestTimeController,
                  decoration: _inputDecoration('Type here'),
                  validator: (v) => v == null || v.isEmpty ? 'Please enter time' : null,
                ),
              ),

              _buildInputField(
                label: 'Permit to Work/Live',
                requiredField: true,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Select option'),
                  value: _permitStatus,
                  items: ['Yes', 'No', 'In process'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _permitStatus = v),
                  validator: (v) => v == null ? 'Please select option' : null,
                ),
              ),

              const SizedBox(height: 24),
              const Text('OPTIONAL', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Work Experience',
                child: TextFormField(
                  controller: _experienceController,
                  decoration: _inputDecoration('Type here'),
                  maxLines: 2,
                ),
              ),

              _buildInputField(
                label: 'Language Skills',
                child: TextFormField(
                  controller: _languageController,
                  decoration: _inputDecoration('Type here'),
                  maxLines: 3,
                ),
              ),

              _buildInputField(
                label: 'Your Comment ($_commentLength/500)',
                child: TextFormField(
                  controller: _commentController,
                  maxLength: 500,
                  maxLines: 3,
                  onChanged: (v) => setState(() => _commentLength = v.length),
                  decoration: _inputDecoration('Type your comment'),
                ),
              ),

              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFile == null ? 'Attach File' : _selectedFile!.name),
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
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                  ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the processing of my personal data',
                        children: [
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: const BorderSide(color: Color(0xFF001730)),
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_agreed && !_uploadingFile) ? _submitForm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001730),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _uploadingFile
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Send'),
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
