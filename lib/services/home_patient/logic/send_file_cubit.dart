import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_patient_cubit.dart';
import 'package:http/http.dart' as http;

class SendVideoCubit extends Cubit<SendStates> {
  SendVideoCubit() : super(SendStates.init);

  sendVideo(
      {required String filePath,
        required Reference ref,
        File? file,
        String? fileName,
        required BuildContext context,
        required senderId,
        required receiverId,
        required dateTime}) async {
    emit(SendStates.loading);


    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(BlocProvider.of<HomePatientCubit>(context).patientModel!.uId)
          .collection('patients_history')
          .add(await modelResult(
          url: "http://192.168.1.8:55827/ff", file: file!));

      // Handle send action
      await ref.child(fileName!).putFile(file);
      String url = await ref.child(fileName).getDownloadURL();
      log(url);

      if (!context.mounted) return;

      BlocProvider.of<HomePatientCubit>(context).sendMssageFromPatientToDoctor(
          text: fileName,
          senderId: senderId,
          receiverId: receiverId,
          dateTime: dateTime,
          url: url);

      emit(SendStates.success);
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      emit(SendStates.failure);
      log('Error uploading file: $e');
    }
  }
}

enum SendStates {
  init,
  loading,
  success,
  failure,
}

Future<Map<String, dynamic>> modelResult(
    {required String url, required File file}) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  var response = await request.send();
  Map<String, dynamic> jsonResponse = {};

  if (response.statusCode == 200) {
    // Upload successful
    String responseString = await response.stream.bytesToString();
    // If the response is JSON, you can parse it like this:
    jsonResponse = jsonDecode(responseString);
    //TODO: store to collection fire sore or shared prefrencess
    log(jsonResponse.toString());
  } else {
    // Handle error
    var responseString = await response.stream.bytesToString();
    jsonResponse = jsonDecode(responseString);

    log('Error: $responseString');
  }
  return jsonResponse;
}
