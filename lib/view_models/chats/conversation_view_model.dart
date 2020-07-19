import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/services/chat_service.dart';

class ConversationViewModel extends ChangeNotifier {
  ChatService chatService = ChatService();
  bool uploadingImage = false;
  File image;

  sendMessage(String chatId, Message message) {
    chatService.sendMessage(
      message,
      chatId,
    );
  }

  Future<String> sendFirstMessage(String recipient, Message message) async {
    String newChatId = await chatService.sendFirstMessage(
      message,
      recipient,
    );

    return newChatId;
  }

  pickImage({int source, BuildContext context, String chatId}) async {
    File image = source == 0
        ? await ImagePicker.pickImage(
            source: ImageSource.camera,
          )
        : await ImagePicker.pickImage(
            source: ImageSource.gallery,
          );

    print(image.path);

    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Theme.of(context).appBarTheme.color,
          toolbarWidgetColor: Theme.of(context).iconTheme.color,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      Navigator.of(context).pop();

      if (croppedFile != null) {
        uploadingImage = true;
        image = croppedFile;
        notifyListeners();
        String imageUrl = await chatService.uploadImage(croppedFile, chatId);
        return imageUrl;
      }
    }
  }
}
