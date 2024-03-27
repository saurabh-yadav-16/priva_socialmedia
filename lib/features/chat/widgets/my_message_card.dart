import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:Priva/common/utils/colors.dart';
import 'package:Priva/common/enums/message_enum.dart';
import 'package:Priva/features/chat/widgets/display_text_image_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final void Function(DragUpdateDetails) onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double minCardWidth = 150.0; // Minimum width to display time

    return SwipeTo(
      onLeftSwipe: (details) => onLeftSwipe(details),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minCardWidth,
              maxWidth: screenWidth *
                  0.8, // Adjusted to take up 80% of the screen width
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: messageColor,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isReplying) ...[
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: backgroundColor.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: DisplayTextImageGIF(
                          message: repliedText,
                          type: repliedMessageType,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    DisplayTextImageGIF(
                      message: message,
                      type: type,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                        Icon(
                          isSeen ? Icons.done_all : Icons.done,
                          size: 20,
                          color: isSeen ? Colors.blue : Colors.white60,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
