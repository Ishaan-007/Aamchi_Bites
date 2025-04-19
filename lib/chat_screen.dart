import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final Connectivity _connectivity = Connectivity();
  static const String _apiKey = 'AIzaSyDdclJ3X-X6b08f0yGoEfD0XR4dXg7LHF8'; // Replace with your actual API key
  bool _isSending = false;
  double _imageSize = 80;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _addInitialBotMessage();
    _scrollController.addListener(_adjustImageSize);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_adjustImageSize);
    _scrollController.dispose();
    super.dispose();
  }

  void _adjustImageSize() {
    setState(() {
      _imageSize = (80 - _scrollController.offset / 5).clamp(40, 80);
    });
  }

  void _addInitialBotMessage() {
    _messages.add(ChatMessage(
      text: "Good Evening! How can I help you?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if ((text.isEmpty && _selectedImage == null) || _isSending) return;

    setState(() {
      _messages.add(ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
          imagePath: _selectedImage?.path));
      _messages.add(ChatMessage(
          text: '', isUser: false, timestamp: DateTime.now(), isLoading: true));
      _textController.clear();
      _selectedImage = null;
      _isSending = true;
    });

    _scrollToBottom();

    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      final model =
          GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

      final parts = <Part>[];
      if (text.isNotEmpty) {
        parts.add(TextPart(text));
      }
      if (_selectedImage != null) {
        final bytes = await File(_selectedImage!.path).readAsBytes();
        parts.add(DataPart('image', bytes));
      }

      parts.add(TextPart(
      "Analyze the following food image and text description (if any) to provide scores out of 100 for:\n"
      "- Observable Cleanliness\n"
      "- Ingredient Quality\n"
      "- Water Safety\n\n"
      "Respond with the scores in the format: Cleanliness: [score]/100, Ingredient Quality: [score]/100, Water Safety: [score]/100. Also, provide a brief explanation for each score."));

      final response = await model.generateContent([Content.multi(parts),]);

      final responseText = response.text?.trim() ??
          "Couldn't process the image and text. Try again.";

      final scores = _parseScores(responseText);

      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          text: responseText,
          isUser: false,
          timestamp: DateTime.now(),
          cleanlinessScore: scores['cleanliness'],
          ingredientQualityScore: scores['ingredientQuality'],
          waterSafetyScore: scores['waterSafety'],
        ));
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          text: "Error: ${e.toString()}",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() => _isSending = false);
    }

    _scrollToBottom();
  }

  Map<String, int?> _parseScores(String text) {
    final scores = <String, int?>{};
    final cleanlinessMatch =
        RegExp(r"Cleanliness: (\d+)/100").firstMatch(text);
    final ingredientQualityMatch =
        RegExp(r"Ingredient Quality: (\d+)/100").firstMatch(text);
    final waterSafetyMatch =
        RegExp(r"Water Safety: (\d+)/100").firstMatch(text);

    scores['cleanliness'] =
        cleanlinessMatch != null ? int.tryParse(cleanlinessMatch.group(1)!) : null;
    scores['ingredientQuality'] = ingredientQualityMatch != null
        ? int.tryParse(ingredientQualityMatch.group(1)!)
        : null;
    scores['waterSafety'] = waterSafetyMatch != null
        ? int.tryParse(waterSafetyMatch.group(1)!)
        : null;

    return scores;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KrishiMitra',
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Yanone Kaffeesatz',
                color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 203),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: _imageSize,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path)) as ImageProvider<Object>?
                    : const AssetImage('assets/images/street_food_1.jpg'),
                child: _selectedImage == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
          ),
          const Text(
            "Today",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return message.isLoading
                    ? _buildLoadingBubble()
                    : _ChatBubble(
                        message: message.text,
                        isUser: message.isUser,
                        time: DateFormat.Hm().format(message.timestamp),
                        imagePath: message.imagePath,
                        cleanlinessScore: message.cleanlinessScore,
                        ingredientQualityScore: message.ingredientQualityScore,
                        waterSafetyScore: message.waterSafetyScore,
                      );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !_isSending,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: _isSending ? null : _pickImage,
          ),
          IconButton(
            icon: Icon(Icons.send, color: _isSending ? Colors.grey : Colors.green),
            onPressed: _isSending ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;
  final String? imagePath;
  final int? cleanlinessScore;
  final int? ingredientQualityScore;
  final int? waterSafetyScore;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
    this.imagePath,
    this.cleanlinessScore,
    this.ingredientQualityScore,
    this.waterSafetyScore,
  });
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String time;
  final String? imagePath;
  final int? cleanlinessScore;
  final int? ingredientQualityScore;
  final int? waterSafetyScore;

  const _ChatBubble({
    required this.message,
    required this.isUser,
    required this.time,
    this.imagePath,
    this.cleanlinessScore,
    this.ingredientQualityScore,
    this.waterSafetyScore,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 34, 65, 3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.file(File(imagePath!), fit: BoxFit.cover),
                ),
              ),
            Text(
              message,
              style:
                  TextStyle(color: isUser ? Colors.white : Colors.black, fontSize: 16),
            ),
            if (!isUser && cleanlinessScore != null && ingredientQualityScore != null && waterSafetyScore != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cleanliness: $cleanlinessScore/100',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Ingredient Quality: $ingredientQualityScore/100',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Water Safety: $waterSafetyScore/100',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}