import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'document_detail_screen.dart';
import 'document_data.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late List<Map<String, dynamic>> documentList;

  @override
  void initState() {
    super.initState();
    documentList = DocumentService.getDocuments();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем список при изменении языка
    documentList = DocumentService.getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001730),
        elevation: 0,
        toolbarHeight: 80,
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
          'Documents',
          style: TextStyle(fontFamily: 'RobotoMono', color: Colors.white),
        ).tr(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
        itemCount: documentList.length,
        itemBuilder: (context, index) {
          final doc = documentList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF001730),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                doc['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DocumentDetailScreen(document: doc),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}