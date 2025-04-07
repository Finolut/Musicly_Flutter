import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart'; // Tambahkan ini
import 'package:spotify/auth/pages/signup_or_siginin.dart';


import '../../choose_mode/bloc/theme_cubit.dart'; // Ganti sesuai lokasi ThemeCubit kamu

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  File? _image;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || user == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pics')
          .child('${user!.uid}.jpg');

      await storageRef.putFile(_image!);

      String downloadURL = await storageRef.getDownloadURL();

      await user!.updatePhotoURL(downloadURL);
      await user!.reload();
      setState(() {
        user = FirebaseAuth.instance.currentUser;
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: user != null
            ? SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user!.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : _image != null
                        ? FileImage(_image!)
                        : null,
                    child: user!.photoURL == null && _image == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  if (_isUploading) const CircularProgressIndicator(),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Change Profile Picture"),
              ),
              const SizedBox(height: 10),
              Text(
                user!.displayName ?? "No Name",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                user!.email ?? "No Email",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const SignupOrSigninPage()),
                        (route) => false,
                  );
                },
                child: const Text("Logout"),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const Text("Theme Mode", style: TextStyle(fontSize: 18)),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text("Light Mode"),
                onTap: () {
                  context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                onTap: () {
                  context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                },
              ),
            ],
          ),
        )
            : const Text("No user logged in"),
      ),
    );
  }
}
