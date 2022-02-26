import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'picture_event.dart';
part 'picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PictureInitial()) {
    on<ChangeImageEvent>(_onChangeImage);
  }

  void _onChangeImage(ChangeImageEvent event, Emitter emit) async {
    try {
      File? img = await _pickImage();
      if (img != null)
        emit(PictureSelectedState(picture: img));
      else
        throw Exception();
    } catch (e) {
      emit(PictureErrorState(errorMsg: "No se pudo cargar imagen"));
    }
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final XFile? chosenImage = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    return chosenImage != null ? File(chosenImage.path) : null;
  }
}