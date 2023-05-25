import 'package:flutter/material.dart';
import 'package:flutter_frontend/controllers/level_controller.dart';
import 'package:flutter_frontend/controllers/user_controller.dart';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/models/level.dart';
import 'package:flutter_frontend/models/user.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CreateUserScreen extends StatefulWidget {

  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;
  File? _image;
  int? _levelId;

  List<LevelModel> _levels = [];

  @override
  void initState() {
    super.initState();
    _fetchLevels();
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

  selectImageFromGallery() async
  {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if(imageFile != null)
    {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newUser = UserModel(
        name: _name,
        email: _email,
        password: _password,
        levelId: _levelId,
      );

      try {
        final response = await UserController.createUser(newUser, _image);
        // User created successfully
        if(context.mounted) Navigator.pop(context, true);
        print('User created');
      } catch (e) {
        // Error occurred during user creation
        print('Failed to create user: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
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
                      child: Text(level.name)
                  );
                }).toList(),
                onChanged: (int? value) => setState(() => _levelId = value!),
              ),
              ElevatedButton(
                onPressed: selectImageFromGallery,
                child: const Text('Add image'),
              ),
              // _image != null ? Text(_image!.path) : Text('No image'),
              _image != null ? Container(
                width: 100,
                height: 100,
                child: Image.file(_image!),
              ) : const SizedBox(height: 1.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}