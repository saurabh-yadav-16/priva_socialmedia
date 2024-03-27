import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Priva/common/utils/colors.dart';
import 'package:Priva/common/enums/message_enum.dart';
import 'package:Priva/common/providers/message_reply_provider.dart';
import 'package:Priva/common/utils/utils.dart';
import 'package:Priva/features/chat/controller/chat_controller.dart';
import 'package:Priva/features/chat/widgets/message_reply_preview.dart';

// Import statements...

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;

  const BottomChatField({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  bool isShowSendButton = false; // Define isShowSendButton variable
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  // Open audio recorder
  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  // Send text message
  void sendTextMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    if (isShowEmojiContainer) hideEmojiContainer();

    // Send message
    ref.read(chatControllerProvider).sendTextMessage(
          context,
          _messageController.text.trim(),
          widget.recieverUserId,
          widget.isGroupChat,
        );

    // Clear message field
    _messageController.clear();
  }

  // Send file message
  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
          widget.isGroupChat,
        );
  }

  // Select image from gallery
  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) sendFileMessage(image, MessageEnum.image);
  }

  // Select video from gallery
  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) sendFileMessage(video, MessageEnum.video);
  }

  // Select GIF
  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null && gif.url != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url!,
            widget.recieverUserId,
            widget.isGroupChat,
          );
    }
  }

  // Hide emoji container
  void hideEmojiContainer() => setState(() => isShowEmojiContainer = false);

  // Show emoji container
  void showEmojiContainer() => setState(() => isShowEmojiContainer = true);

  // Toggle emoji keyboard container
  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  // Show keyboard
  void showKeyboard() => focusNode.requestFocus();

  // Hide keyboard
  void hideKeyboard() => focusNode.unfocus();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  // Build prefix icons
  Widget _buildPrefixIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: toggleEmojiKeyboardContainer,
              icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
            ),
            IconButton(
              onPressed: selectGIF,
              icon: const Icon(Icons.gif, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Build suffix icons
  Widget _buildSuffixIcons() {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: selectImage,
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
          ),
          IconButton(
            onPressed: selectVideo,
            icon: const Icon(Icons.attach_file, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Build input decoration
  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: mobileChatBoxColor,
      prefixIcon: _buildPrefixIcons(),
      suffixIcon: _buildSuffixIcons(),
      hintText: 'Type a message!',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
      contentPadding: const EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Message reply preview
        ref.watch(messageReplyProvider) != null
            ? const MessageReplyPreview()
            : const SizedBox(),
        // Text input field
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) =>
                    setState(() => isShowSendButton = val.isNotEmpty),
                decoration: _buildInputDecoration(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Emoji picker
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text += emoji.emoji;
                    });
                    if (!isShowSendButton)
                      setState(() => isShowSendButton = true);
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
