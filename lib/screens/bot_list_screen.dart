import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';
import '../models/bot.dart';

class BotListScreen extends StatefulWidget {
  const BotListScreen({super.key});

  @override
  State<BotListScreen> createState() => _BotListScreenState();
}

class _BotListScreenState extends State<BotListScreen> {
  late Box<Bot> botBox;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    botBox = Hive.box<Bot>('bots');
  }

  void _openChat(Bot bot) {
    Navigator.pushNamed(context, '/chat', arguments: bot);
  }

  @override
  Widget build(BuildContext context) {
    final bots = botBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _customAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchField(),
            const SizedBox(height: 30),
            _categorySection(bots),
            const SizedBox(height: 30),
            _myBotsSection(bots),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  AppBar _customAppBar() {
    return AppBar(
      title: const Text(
        'Companion AI',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            final result = await Navigator.pushNamed(context, '/botProfile');
            if (result != null) {
              setState(() {});
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 37,
              decoration: BoxDecoration(
                color: const Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Search AI',
          hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.grey),
            onPressed: () {},
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _categorySection(List<Bot> bots) {
    final categories = ['All', ...bots.map((b) => b.category).toSet().toList()];

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected =
                    _selectedCategory == category ||
                    (_selectedCategory == null && category == 'All');

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category == 'All' ? null : category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _myBotsSection(List<Bot> bots) {
    final filteredBots =
        _selectedCategory == null
            ? bots
            : bots.where((b) => b.category == _selectedCategory).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your bots',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredBots.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final bot = filteredBots[index];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => _openChat(bot),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          240,
                          155,
                          255,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              'assets/icons/P-${bot.name}.svg',
                              height: 50,
                              width: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Text(
                                bot.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                bot.tagline,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff9DCEFF), Color(0xff92A3FD)],
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                'Chat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioned Delete Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                      onPressed: () => _confirmAndClearBots(bot),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndClearBots(Bot bot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xffF7F8F8),
            title: Text('Delete ${bot.name}?'),
            content: const Text(
              'This will permanently delete this bot and chat.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final chatBoxName = 'chat_${bot.key}';
      try {
        if (await Hive.boxExists(chatBoxName)) {
          Box<Message> chatBox;

          if (Hive.isBoxOpen(chatBoxName)) {
            chatBox = Hive.box<Message>(chatBoxName);
          } else {
            chatBox = await Hive.openBox<Message>(chatBoxName);
          }
          await chatBox.clear();
          await chatBox.close();
          await Hive.deleteBoxFromDisk(chatBoxName);
        }
      } catch (e) {
        debugPrint('Error deleting chat box $chatBoxName: $e');
      }
      final keyToDelete = botBox.keys.firstWhere(
        (key) => botBox.get(key)?.name == bot.name,
        orElse: () => null,
      );
      if (keyToDelete != null) {
        await botBox.delete(keyToDelete);
        debugPrint('Deleted bot with key: $keyToDelete');
      } else {
        debugPrint('Bot not found in box');
      }
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deleted.'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
