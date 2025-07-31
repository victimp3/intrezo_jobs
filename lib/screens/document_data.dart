import 'package:easy_localization/easy_localization.dart';

class DocumentService {
  static List<Map<String, dynamic>> getDocuments() {
    return [
      {
        'title': 'doc_idcard_title'.tr(),
        'key': 'doc_idcard',
        'description': 'doc_idcard'.tr(),
      },
      {
        'title': 'doc_residence_title'.tr(),
        'key': 'doc_residence',
        'description': 'doc_residence'.tr(),
      },
      {
        'title': 'doc_health_title'.tr(),
        'key': 'doc_health',
        'description': 'doc_health'.tr(),
      },
      {
        'title': 'doc_sickleave_title'.tr(),
        'key': 'doc_sickleave',
        'description': 'doc_sickleave'.tr(),
      },
      {
        'title': 'doc_visa_title'.tr(),
        'key': 'doc_visa',
        'description': 'doc_visa'.tr(),
      },
      {
        'title': 'doc_tax_title'.tr(),
        'key': 'doc_tax',
        'description': 'doc_tax'.tr(),
      },
      {
        'title': 'doc_passport_photo_title'.tr(),
        'key': 'doc_passport_photo',
        'description': 'doc_passport_photo'.tr(),
        'images': [
          'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/Dphoto1.png?alt=media&token=e4c7d973-c8b5-42be-89a1-94abe5ccaf60',
          'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/Dphoto2.png?alt=media&token=04ffa41d-1b7c-49c1-87ec-3802a11dc369',
          'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/Dphoto3.png?alt=media&token=39057d99-bf01-4bf1-89c9-6e4f6b5d3281',
        ]
      },
    ];
  }
}