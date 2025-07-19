import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import '../models/bot.dart';

class BotProfileScreen extends StatefulWidget {
  const BotProfileScreen({super.key});

  @override
  State<BotProfileScreen> createState() => _BotProfileScreenState();
}

class _BotProfileScreenState extends State<BotProfileScreen> {
  final nameController = TextEditingController();
  final taglineController = TextEditingController();
  final greetingController = TextEditingController();

  String? _profilePicPath;
  final List<String> _categories = ['Entertainment', 'Travel', 'Other'];
  String? _selectedCategory;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicPath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create Bot',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purpleAccent.withOpacity(0.2),
                backgroundImage:
                    _profilePicPath != null
                        ? FileImage(File(_profilePicPath!))
                        : null,
                child:
                    _profilePicPath == null
                        ? const Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: Colors.black54,
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 24),
            _buildInputField(nameController, 'Name*'),
            _buildInputField(taglineController, 'Tagline'),
            _buildInputField(greetingController, 'Greeting'),
            _buildDropdownField(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_selectedCategory == null ||
                    nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please insert name and select category'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                final bot = Bot(
                  name: nameController.text.trim(),
                  tagline: taglineController.text.trim(),
                  greeting: greetingController.text.trim(),
                  category: _selectedCategory!,
                  profilePicPath: _profilePicPath,
                );

                final botBox = Hive.box<Bot>('bots');
                await botBox.add(bot);
                await Hive.openBox<Message>('chat_${bot.key}');
                Navigator.pop(context, bot);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xff92A3FD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'create',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xffF7F8F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category*',
          filled: true,
          fillColor: const Color(0xffF7F8F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items: [
          ..._categories.map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          ),
          const DropdownMenuItem(
            value: 'add_new',
            child: Text('➕ Add new category'),
          ),
        ],
        onChanged: (value) {
          if (value == 'add_new') {
            _showAddCategoryDialog();
          } else {
            setState(() {
              _selectedCategory = value;
            });
          }
        },
      ),
    );
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add New Category'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter category name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final newCategory = controller.text.trim();
                  if (newCategory.isNotEmpty &&
                      !_categories.contains(newCategory)) {
                    setState(() {
                      _categories.add(newCategory);
                      _selectedCategory = newCategory;
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
