import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project2/Screens/page1.dart';
import 'package:project2/address_model,.dart';
import 'package:project2/location_service.dart';

class TawariScreen extends StatefulWidget {
  final String title;

  const TawariScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<TawariScreen> createState() => _TawariScreenState();
}

class _TawariScreenState extends State<TawariScreen> {
  String image = '';
  final imagepicker = ImagePicker();
  final problemController = TextEditingController();
  bool isLoading = false;

  AddressModel currentLocation =
      const AddressModel(country: '', name: '', postalCode: '');
  AddressModel emptyLocation =
      const AddressModel(country: '', name: '', postalCode: '');

  Future<void> uploadimage(ImageSource source) async {
    final img = await imagepicker.pickImage(source: source);
    if (img != null) {
      image = img.path;
      print(img.path);
    } else {
      image = '';
    }
  }

  @override
  void initState() {
    var status = Permission.location.request().then((value) {
      if (value.isDenied) {
        Permission.location.request();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.cyan,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              child: TextFormField(
                controller: problemController,
                textAlign: TextAlign.right,
                maxLines: 15,
                decoration: InputDecoration(
                    hintText: "كتابة المشكلة",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton.icon(
                onPressed: () async => await uploadimage(ImageSource.camera),
                icon: const Icon(Icons.add_a_photo),
                label: const Text('الكاميرا')),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  currentLocation =
                      await LocationService().getCurrentLocation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B8D4),
                ),
                child: const Text('Send My Location'),
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(45)),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (problemController.text.isNotEmpty) {
                          _uploadUserData();
                        }
                      },
                      child: const Text(
                        'ارسال البلاغ ',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<String> uploadImage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');

    final snanpshot = await storageRef.putFile(File(image));

    if (snanpshot.state == TaskState.running) {
      isLoading = true;
      setState(() {});
      return '';
    } else if (snanpshot.state == TaskState.success) {
      return await storageRef.getDownloadURL();
    }
    return '';
  }

  void _uploadUserData() async {
    final url = await uploadImage();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userName = (await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get())['Full Name'] as String;

    if (userName.isNotEmpty && currentLocation != emptyLocation) {
      if (url.isNotEmpty) {
        await FirebaseFirestore.instance.collection('requests').doc().set(
          {
            'location': currentLocation.toMap(),
            'userName': userName,
            'problem_desc': problemController.text,
            'problem_img': url,
          },
          SetOptions(merge: true),
        ).then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
      }

      isLoading = false;
      setState(() {});
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
