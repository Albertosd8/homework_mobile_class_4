import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //ScreenshotController screenshotController = ScreenshotController();
  final _controller = ScreenshotController();

  Future<void> shareScreenshot() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final String localPath =
        //'${directory!.path+'/lib/ss'}.png';
        '${directory!.path}/${DateTime.now().toIso8601String()}.png';

    final image = await _controller.capture();
    await _controller.captureAndSave(localPath);

    await Future.delayed(Duration(seconds: 1));

    await FlutterShare.shareFile(
      title: 'Imagen',
      filePath: localPath,
      fileType: 'image/png'
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    Screenshot(
    controller: _controller,
    child:
    Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Compartir pantalla",
            onPressed: shareScreenshot,
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: 
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<PictureBloc, PictureState>(
                  listener: (context, state) {
                    if (state is PictureErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${state.errorMsg}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PictureSelectedState) {
                      return CircleAvatar(
                        backgroundImage: FileImage(state.picture!),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 122, 113, 113),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Bienvenido",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text("Usuario${UniqueKey()}"),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularButton(
                      textAction: "Ver tarjeta",
                      iconData: Icons.credit_card,
                      bgColor: Color(0xff123b5e),
                      action: null,
                    ),
                    CircularButton(
                      textAction: "Cambiar foto",
                      iconData: Icons.camera_alt,
                      bgColor: Colors.orange,
                      action: () {
                        BlocProvider.of<PictureBloc>(context).add(
                          ChangeImageEvent(),
                        );
                      },
                    ),
                    CircularButton(
                      textAction: "Ver tutorial",
                      iconData: Icons.play_arrow,
                      bgColor: Colors.green,
                      action: null,
                    ),
                  ],
                ),
                SizedBox(height: 48),
                CuentaItem(),
                CuentaItem(),
                CuentaItem(),
              ],
            ),
          ),
      ),
    )
    ); //all

  }
}

Future<dynamic> ShowCapturedWidget(
    BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }