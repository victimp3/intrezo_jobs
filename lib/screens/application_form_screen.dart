import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'confirmation_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/gestures.dart';
import 'dart:io';

class ApplicationFormScreen extends StatefulWidget {
  final Map<String, dynamic> vacancy;

  const ApplicationFormScreen({Key? key, required this.vacancy}) : super(key: key);

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreed = false;
  bool _agreedPrivacy = false;
  int _commentLength = 0;
  List<PlatformFile> _selectedFiles = [];
  bool _uploadingFile = false;

  Map<String, bool> _uploadingStatus = {}; // ключ — имя файла, значение — грузится или нет

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

  final List<String> contactMethods = [
    'contact_methods.phone',
    'contact_methods.email',
    'contact_methods.whatsapp',
    'contact_methods.viber',
    'contact_methods.telegram',
  ];

  final List<String> permitOptions = ['yes', 'no', 'in_process'];

  late TapGestureRecognizer _privacyPolicyRecognizer;

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

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      final newFiles = result.files.take(3 - _selectedFiles.length);
      setState(() {
        _selectedFiles.addAll(newFiles);
      });
    }
  }

  Future<List<String>> _uploadFiles() async {
    setState(() => _uploadingFile = true);
    List<String> urls = [];

    for (var file in _selectedFiles) {
      if (file.path == null) continue;

      setState(() {
        _uploadingStatus[file.name] = true;
      });

      final ref = FirebaseStorage.instance.ref(
        'applications/${DateTime.now().millisecondsSinceEpoch}_${file.name}',
      );

      try {
        // Добавляем тайм-аут в 30 секунд
        await ref.putFile(File(file.path!)).timeout(const Duration(seconds: 30));
        final url = await ref.getDownloadURL();
        urls.add(url);
      } catch (e) {
        debugPrint('Ошибка загрузки файла ${file.name}: $e');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка при загрузке файла: ${file.name}'),
          backgroundColor: Colors.red,
        ));
      } finally {
        // В любом случае отключаем индикатор
        setState(() {
          _uploadingStatus[file.name] = false;
        });
      }
    }

    setState(() => _uploadingFile = false);
    return urls;
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

    String? contactInfo = (_contactMethod == 'contact_methods.email')
        ? _emailController.text.trim()
        : _phoneController.text.trim();

    List<String> fileUrls = await _uploadFiles();

    await FirebaseFirestore.instance.collection('applications').add({
      'vacancy_title': widget.vacancy['title'],
      'full_name': formattedName,
      'date_of_birth': _dobController.text,
      'citizenship': _citizenship?.tr(),
      'contact_info': contactInfo,
      'preferred_contact_method': _contactMethod?.tr(),
      'best_time_to_contact': _bestTimeController.text,
      'permit_status': _permitStatus,
      'work_experience': _experienceController.text,
      'language_skills': _languageController.text,
      'comment': _commentController.text,
      'file_urls': fileUrls, // если хранить массив из 1–3 ссылок
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
      _selectedFiles.clear();
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
  void initState() {
    super.initState();
    _privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrlString('https://intrezo.ee/est/andmekaitsetingimused/');
      };
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

              if (_contactMethod == 'contact_methods.email')
                _buildInputField(
                  label: 'email'.tr(),
                  requiredField: true,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('enter_email'.tr()),
                    validator: _validateEmail,
                  ),
                ),

              if (_contactMethod != null && _contactMethod != 'contact_methods.email')
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
                child: Wrap(
                  spacing: 20, // расстояние между кнопками
                  children: permitOptions.map((option) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: _permitStatus,
                          onChanged: (value) {
                            setState(() => _permitStatus = value);
                          },
                          activeColor: const Color(0xFF001730),
                        ),
                        Text('permit_options.$option'.tr()),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 15),
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

              // Кнопка выбора файла
              ElevatedButton.icon(
                onPressed: _selectedFiles.length < 3 ? _pickFiles : null,
                icon: const Icon(Icons.attach_file),
                label: Text('attach_file'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001730),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 12),

              // Список выбранных файлов
              ..._selectedFiles.map((file) {
                IconData icon;
                final ext = file.extension?.toLowerCase();

                if (ext == 'pdf') {
                  icon = Icons.picture_as_pdf;
                } else if (ext == 'doc' || ext == 'docx') {
                  icon = Icons.description;
                } else {
                  icon = Icons.insert_drive_file;
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _uploadingStatus[file.name] == true
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Icon(icon, color: const Color(0xFF001730)),
                  title: Text(file.name, style: const TextStyle(fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() => _selectedFiles.remove(file));
                    },
                  ),
                );
              }),

              const SizedBox(height: 16),
              // Обязательный чекбокс
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v ?? false),
                activeColor: const Color(0xFF4CAF50),
                title: RichText(
                  text: TextSpan(
                    text: 'agree_data'.tr(),
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),

// Необязательный чекбокс
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _agreedPrivacy,
                onChanged: (v) => setState(() => _agreedPrivacy = v ?? false),
                activeColor: const Color(0xFF4CAF50),
                title: RichText(
                  text: TextSpan(
                    text: '${'agree_policy_part1'.tr()} ',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'agree_policy_link'.tr(),
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: _privacyPolicyRecognizer,
                      ),
                    ],
                  ),
                ),
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

  @override
  void dispose() {
    _privacyPolicyRecognizer.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _bestTimeController.dispose();
    _commentController.dispose();
    _experienceController.dispose();
    _languageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

}