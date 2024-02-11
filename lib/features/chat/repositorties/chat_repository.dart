import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:priva_socialmedia/common/enums/message_enum.dart';
import 'package:priva_socialmedia/common/utils/utils.dart';
import 'package:priva_socialmedia/models/chat_contact.dart';
import 'package:priva_socialmedia/models/message.dart';
import 'package:priva_socialmedia/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    //user -> receiver id -> chats -> current user id -> set data
    //user -> current user id -> chats -> receiver id -> set data
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(senderUserData.uid)
        .set(
          recieverChatContact.toMap(),
        );

    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveDataToMessageSubcollection({
    required String reciverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required recieverUsername,
    required MessageEnum messageType,
  }) async {
    //user -> sender id-> receiver id -> messages -> message id -> store message
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: reciverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: '',
      repliedMessageType: null,
      repliedTo: '',
    );
    //user -> sender id-> receiver id -> messages -> message id -> store message
    //user -> receiver id-> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    await firestore
        .collection('users')
        .doc(reciverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    //user -> sender id-> receiver id -> messages -> message id -> store message
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var UserData =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(UserData.data()!);

      // ...

      var messageId = Uuid().v1();
      //user -> receiver id -> chats -> current user id -> set data
      _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );

      _saveDataToMessageSubcollection(
        reciverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.name,
        recieverUsername: receiverUserData.name,
        messageType: MessageEnum.text,
      );
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}
