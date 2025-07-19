import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tenor_flutter/tenor_flutter.dart';
import 'package:hive/hive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/bot.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late Bot bot;
  late Box<Message> chatBox;
  final List<Message> messages = [];
  final TextEditingController messageController =
      TextEditingController(); //Controller for message input field.

  // Initializes and manages voice input.
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechAvailable = false;

  //show the microphone icon while recording voice
  late AnimationController _micAnimationController;
  late Animation<double> _micScaleAnimation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _micScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );
    _initSpeech();
  }

  @override
  void dispose() {
    _micAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          bot.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
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
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.black),
            onPressed: _confirmAndClearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) => buildMessage(messages[index]),
            ),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.image), onPressed: _pickImage),
              IconButton(icon: const Icon(Icons.gif), onPressed: _pickGif),
              AnimatedBuilder(
                animation: _micScaleAnimation,
                builder: (context, child) {
                  return GestureDetector(
                    onTapDown: (_) {
                      if (_speechAvailable && !_isListening) {
                        _startListening();
                      }
                    },
                    onTapUp: (_) {
                      if (_isListening) _stopListening();
                    },
                    onTapCancel: () {
                      if (_isListening) _stopListening();
                    },
                    child: Transform.scale(
                      scale: _isListening ? _micScaleAnimation.value : 1.0,
                      child: Icon(
                        Icons.mic,
                        color:
                            _speechAvailable
                                ? (_isListening ? Colors.red : Colors.black)
                                : Colors.grey,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Message...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) sendMessage(text.trim());
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = messageController.text.trim();
                  if (text.isNotEmpty) sendMessage(text);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndClearChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Chat?'),
            content: const Text('This will delete all messages in this chat.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
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
      await chatBox.clear();
      setState(() {
        messages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chat has been deleted.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _initSpeech() async {
    final micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      await Permission.microphone.request();
    }

    if (await Permission.microphone.isGranted) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
            _micAnimationController.stop();
            _micAnimationController.reset();
          }
        },
        onError: (error) {
          debugPrint('Speech error: $error');
          setState(() => _isListening = false);
          _micAnimationController.stop();
          _micAnimationController.reset();
        },
      );
      setState(() {
        _speechAvailable = available;
      });
    } else {
      setState(() => _speechAvailable = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bot = ModalRoute.of(context)!.settings.arguments as Bot;
    chatBox = Hive.box<Message>('chat_${bot.key}');
    messages.clear();
    messages.addAll(chatBox.values);
  }

  void sendMessage(String text, {String? imageUrl}) {
    final userMsg = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
    );

    // Immediately show user message
    setState(() {
      messages.add(userMsg);
    });
    chatBox.add(userMsg);
    messageController.clear();

    // Delay bot reply by 700 milliseconds
    Future.delayed(const Duration(milliseconds: 700), () {
      final botReply = Message(
        text: 'This is a dumb answer.',
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        messages.add(botReply);
      });
      chatBox.add(botReply);
    });
  }

  Widget buildMessage(Message msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'assets/icons/${bot.name}.svg',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isUser ? 12 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 12),
                ),
              ),
              child:
                  msg.imageUrl != null && msg.imageUrl!.isNotEmpty
                      ? msg.imageUrl!.startsWith('http')
                          ? Image.network(msg.imageUrl!)
                          : Image.file(File(msg.imageUrl!))
                      : Text(msg.text),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      sendMessage('', imageUrl: picked.path);
    }
  }

  Future<void> _pickGif() async {
    final tenorClient = Tenor(
      apiKey: 'AIzaSyCNY_kjigZ-RepT0EWXFbQYvotDQmpZEPQ',
      clientKey: 'My Project',
    );
    final TenorResult? result = await tenorClient.showAsBottomSheet(
      context: context,
    );
    final selectedGif =
        result?.media.tinyGif ?? result?.media.tinyGifTransparent;
    sendMessage('', imageUrl: selectedGif?.url);
  }

  void _startListening() {
    messageController.clear();
    _speech.listen(
      onResult: (result) {
        setState(() {
          messageController.text = result.recognizedWords;
          messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: messageController.text.length),
          );
        });
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: 'en_US',
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );

    _micAnimationController.repeat(reverse: true);
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    _speech.stop();
    _micAnimationController.stop();
    _micAnimationController.reset();
    setState(() {
      _isListening = false;
    });
  }
}
