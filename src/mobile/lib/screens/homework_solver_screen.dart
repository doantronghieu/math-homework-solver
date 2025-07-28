import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class HomeworkSolverScreen extends StatefulWidget {
  const HomeworkSolverScreen({super.key});

  @override
  State<HomeworkSolverScreen> createState() => _HomeworkSolverScreenState();
}

class _HomeworkSolverScreenState extends State<HomeworkSolverScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _solution;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isServerHealthy = false;

  @override
  void initState() {
    super.initState();
    _checkServerHealth();
  }

  // Process text to handle math expressions better
  String _processMathText(String text) {
    // Replace common LaTeX patterns with more readable text
    return text
        .replaceAll(r'\text{', '')
        .replaceAll(r'}', '')
        .replaceAll(r'\times', '×')
        .replaceAll(r'\div', '÷')
        .replaceAll(r'\pm', '±')
        .replaceAll(r'\ne', '≠')
        .replaceAll(r'\le', '≤')
        .replaceAll(r'\ge', '≥')
        .replaceAll(r'\approx', '≈')
        .replaceAll(r'\infty', '∞')
        .replaceAll(r'\alpha', 'α')
        .replaceAll(r'\beta', 'β')
        .replaceAll(r'\gamma', 'γ')
        .replaceAll(r'\pi', 'π')
        .replaceAll(r'\theta', 'θ')
        .replaceAll(r'\sum', '∑')
        .replaceAll(r'\int', '∫')
        .replaceAll(r'\sqrt', '√')
        .replaceAll(r'\frac', '/')
        .replaceAll(RegExp(r'\$([^$]+)\$'), r'$1') // Remove single $ delimiters
        .replaceAll(RegExp(r'\$\$([^$]+)\$\$'), r'$1'); // Remove double $$ delimiters
  }

  Future<void> _checkServerHealth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Check if API is healthy
    final isHealthy = await ApiService.healthCheck();
    setState(() {
      _isServerHealthy = isHealthy;
      _isLoading = false;
      if (!isHealthy) {
        _errorMessage = 'Cannot connect to server. Please check your connection.';
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _solution = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to take photo: $e';
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _solution = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to select image: $e';
      });
    }
  }

  Future<void> _solveProblem() async {
    if (!_isServerHealthy || _selectedImage == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _solution = null;
    });

    final result = await ApiService.solveProblem(_selectedImage!);
    
    if (result != null) {
      setState(() {
        _solution = result['solution'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to solve problem. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _pickImageFromCamera();
                        },
                        icon: const Icon(Icons.camera_alt),
                        iconSize: 50,
                        color: Colors.blue,
                      ),
                      const Text('Camera'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _pickImageFromGallery();
                        },
                        icon: const Icon(Icons.photo_library),
                        iconSize: 50,
                        color: Colors.green,
                      ),
                      const Text('Gallery'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Solver'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),

            // Image selection section
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Take or select a photo of your homework',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isServerHealthy ? _showImageSourceDialog : null,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Add Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isServerHealthy && _selectedImage != null && !_isLoading)
                        ? _solveProblem
                        : null,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.psychology),
                    label: Text(_isLoading ? 'Solving...' : 'Solve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Solution section
            if (_solution != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Solution',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MarkdownBody(
                      data: _processMathText(_solution!),
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                        h1: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                        h2: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                        h3: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                        strong: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        em: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        code: TextStyle(
                          backgroundColor: Colors.grey.shade200,
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        codeblockPadding: const EdgeInsets.all(12),
                        codeblockAlign: WrapAlignment.start,
                        textAlign: WrapAlignment.start,
                        listBullet: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      fitContent: false,
                      extensionSet: md.ExtensionSet(
                        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                        [
                          md.EmojiSyntax(),
                          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Loading indicator
            if (_isLoading && _solution == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'AI is analyzing your homework...\nThis may take a moment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}