import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/controllers/level_controller.dart';
import 'package:flutter_frontend/controllers/user_controller.dart';
import 'package:flutter_frontend/models/level.dart';
import 'package:flutter_frontend/models/user.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';


class EditUserScreen extends StatefulWidget {
  final UserModel user;
  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;
  String? _userImage;
  File? _image;
  int? _levelId;

  List<LevelModel> _levels = [];

  @override
  void initState() {
    super.initState();
    _fetchLevels();
    _name = widget.user.name;
    _email = widget.user.email;
    _password = widget.user.password;
    _levelId = widget.user.levelId;
    _userImage = widget.user.image != '' ? widget.user.image : '';
  }

  Future<void> _fetchLevels() async {
    try {
      final levels = await LevelController.getLevel();
      setState(() {
        _levels = levels;
      });
    } catch (e) {
      // Handle the error
      print('Error: $e');
    }
  }

  selectImageFromGallery() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedUser = UserModel(
        id: widget.user.id,
        name: _name,
        email: _email,
        password: _password,
        levelId: _levelId,
      );

      try {
        await UserController.updateUser(updatedUser, _image);
        print('User updated');

        // Navigate back to the previous screen
        if(context.mounted) Navigator.pop(context, true);
      } catch (e) {
        // Error occurred during user update
        print('Failed to update user: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
                onChanged: (val) {
                  setState(() => _name = val);
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
                onChanged: (val) {
                  setState(() => _email = val);
                },
              ),
              TextFormField(
                initialValue: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
                onChanged: (val) {
                  setState(() => _password = val);
                },
              ),
              DropdownButtonFormField(
                value: _levelId,
                items: _levels.map((level) {
                  return DropdownMenuItem(
                    value: level.id,
                    child: Text(level.name),
                  );
                }).toList(),
                onChanged: (int? value) => setState(() => _levelId = value),
              ),
              ElevatedButton(
                onPressed: selectImageFromGallery,
                child: const Text('Add image'),
              ),
              _image == null
                  ? SizedBox(
                width: 150,
                height: 150,
                child: ImageNetwork(
                  image: _userImage ?? '',
                  imageCache: CachedNetworkImageProvider(_userImage ?? ''),
                  height: 150,
                  width: 150,
                  duration: 1500,
                  curve: Curves.easeIn,
                  onPointer: true,
                  debugPrint: false,
                  fullScreen: false,
                  fitAndroidIos: BoxFit.cover,
                  fitWeb: BoxFitWeb.cover,
                  onLoading: const CircularProgressIndicator(
                    color: Colors.indigoAccent,
                  ),
                  onError: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              )
              : Container(
                width: 100,
                height: 100,
                child: Image.file(_image!),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

