import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> document;

  const DocumentDetailScreen({super.key, required this.document});

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
        title: Text(
          document['title'],
          style: const TextStyle(
            fontFamily: 'RobotoMono',
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            document['description'],
            style: const TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 16,
              color: Color(0xFF001730),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          if (document['images'] != null)
            ...document['images'].map<Widget>(
                  (url) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.network(url),
              ),
            ).toList(),
        ],
      ),
    );
  }
}