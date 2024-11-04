import 'dart:io';

import 'package:export_video_frame/export_video_frame.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image/image.dart' as img_lib;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/components/myDrawer.dart';

class IntensityCalculator extends StatefulWidget {
  const IntensityCalculator({super.key});

  @override
  State<IntensityCalculator> createState() => _IntensityCalculator();
}

class _IntensityCalculator extends State<IntensityCalculator> {
  XFile? videoFile;
  File? _selectedFile;
  bool _inProcess = false;
  double intensity = 0;
  String? imageName = "";
  bool _validate = false;
  final String title = "ECL Intensity calculator";
  final ImagePicker _picker = ImagePicker();

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile!,
        width: 255,
        height: 255,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'Assets/placeholder.jpg',
        width: 255,
        height: 255,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> cropImage(XFile? image) async {
    if (image == null) {
      return;
    }
    setState(() {
      _inProcess = true;
    });
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Colors.cyan,
          toolbarTitle: 'Cropper',
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    setState(() {
      _selectedFile = File(cropped!.path);
      _inProcess = false;
    });
  }

  getImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });

    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    cropImage(image);
    setState(() {
      _inProcess = false;
    });
  }

  void calculateEcl(File? file) {
    img_lib.Image? img = img_lib.decodeImage(file!.readAsBytesSync());
    int pixel = 0, red = 0, blue = 0, green = 0;
    for (int x = 0; x < img!.width; x++) {
      for (int y = 0; y < img.height; y++) {
        pixel = img.getPixel(x, y);
        Color pixelColor = getFlutterColor(pixel);
        red += pixelColor.red;
        blue += pixelColor.blue;
        green += pixelColor.green;
      }
    }
    int numberOfPixels = img.height * img.width;
    intensity = ((red / numberOfPixels) +
            (blue / numberOfPixels) +
            (green / numberOfPixels)) /
        3;

    // log()
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // availableCameras().then((value) => {log(value.toString())});
  //   // log(CameraDevice.values.toString());
  // }

  Color getFlutterColor(int abgr) {
    int r = (abgr >> 16) & 0xFF;
    int b = abgr & 0xFF;
    int argb = (abgr & 0xFF00FF00) | (b << 16) | r;
    return Color(argb);
  }

  Future<void> sendEmail() async {
    if (intensity == 0) {
      calculateEcl(_selectedFile);
    }
    await FlutterEmailSender.send(Email(
      body: 'Mean value: $intensity',
      subject: 'ECL Mean value',
      recipients: ['p20220023@hyderabad.bits-pilani.ac.in'],
      cc: ['f20221647@hyderabad.bits-pilani.ac.in'],
      bcc: [],
      attachmentPaths: [_selectedFile!.path],
      isHTML: false,
    ));
  }

  Future<void> save() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('saving...'),
      ),
    );
    if (intensity == 0) {
      calculateEcl(_selectedFile);
    }
    final storageRef = FirebaseStorage.instance.ref();
    final imageStorageRef = storageRef.child('images');
    final imagesRef =
        imageStorageRef.child("${imageName!} ${_selectedFile.hashCode}");
    String? filePath = _selectedFile?.path;
    File file = File(filePath!);
    try {
      await imagesRef.putFile(
          file,
          SettableMetadata(
              customMetadata: {"intensity": intensity.toString()}));
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future recordVideo() async {
    // var status = await Permission.accessMediaLocation.status
    // await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    // Permission.storage.request();

    // final String path =
    //     await getApplicationDocumentsDirectory().then((value) => value.path);
    // log(path);

    videoFile = await _picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 6));
    setState(() {
      _inProcess = true;
    });
    // videoFile.
    List<File> images =
        await ExportVideoFrame.exportImage(videoFile!.path, 360, 1);
    double first = 0;
    for (File img in images) {
      calculateEcl(img);
      if (intensity > first) {
        first = intensity;
        _selectedFile = img;
      }
    }
    cropImage(XFile(_selectedFile!.path));
    calculateEcl(_selectedFile);
    videoFile = null;
    images.clear();
    setState(() {
      _inProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer1(),
      appBar: AppBar(title: Text(title)),
      body: (_inProcess)
          ? Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.95,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(top: 50),
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onChanged: (text) {
                        imageName = text;
                      },
                      decoration: InputDecoration(
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'Image Name',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                            color: Colors.green,
                            child: const Text(
                              "Camera",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            }),
                        MaterialButton(
                            color: Colors.amber,
                            child: const Text(
                              "Burst",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              recordVideo().whenComplete(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Finished!'),
                                  ),
                                );
                              });
                            }),
                        MaterialButton(
                            color: Colors.deepOrange,
                            child: const Text(
                              "Device",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            }),
                      ],
                    ),
                    getImageWidget(),
                    MaterialButton(
                        color: Colors.cyan,
                        child: const Text(
                          "Measure",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          calculateEcl(_selectedFile);
                          setState(() {
                            intensity = intensity;
                          });
                        }),
                    Text(
                      'Mean:${intensity == 0 ? '0.0' : intensity.toString()}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(
                            Icons.mail,
                            color: Colors.blue,
                            size: 50.0,
                          ),
                          onPressed: () {
                            sendEmail();
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              imageName!.isNotEmpty
                                  ? {
                                      _validate = false,
                                      save().whenComplete(() {
                                        print("Saved!");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Saved!'),
                                          ),
                                        );
                                      })
                                    }
                                  : {
                                      _validate = true,
                                      print("error in valid name")
                                    };
                            });
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.blue,
                            size: 50.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            cropImage(XFile(_selectedFile!.path));
                          },
                          icon: const Icon(
                            Icons.crop_rotate_rounded,
                            color: Colors.blue,
                            size: 43.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
