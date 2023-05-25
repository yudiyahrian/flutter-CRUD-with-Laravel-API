import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/controllers/user_controller.dart';
import 'package:flutter_frontend/models/user.dart';
import 'package:image_network/image_network.dart';

class UserDetailPage extends StatelessWidget {
  final int? userId;

  const UserDetailPage({super.key, required this.userId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: FutureBuilder<UserModel>(
        future: UserController.getUserById(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to fetch user details'));
          }

          final user = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: const Text('ID'),
                subtitle: Text(user?.id.toString() ?? ''),
              ),
              ListTile(
                title: const Text('Name'),
                subtitle: Text(user?.name ?? ''),
              ),
              ListTile(
                title: const Text('Email'),
                subtitle: Text(user?.email ?? ''),
              ),
              SizedBox(
                width: 150,
                height: 150,
                child: ImageNetwork(
                  image: user?.image ?? '',
                  imageCache: CachedNetworkImageProvider(user?.image ?? ''),
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
              // Add more ListTile widgets for other user details
            ],
          );
        },
      ),
    );
  }
}
