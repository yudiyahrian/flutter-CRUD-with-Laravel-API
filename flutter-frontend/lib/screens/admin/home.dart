import 'package:flutter/material.dart';
import 'package:flutter_frontend/controllers/auth_controller.dart';
import 'package:flutter_frontend/controllers/user_controller.dart';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/models/user.dart';
import 'package:flutter_frontend/screens/admin/create_user.dart';
import 'package:flutter_frontend/screens/admin/detail.dart';
import 'package:flutter_frontend/screens/admin/edit_user.dart';
import 'package:flutter_frontend/services/auth_provider.dart';
import 'package:flutter_frontend/shared/dialog.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await UserController.getUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      // Handle the error
      print('Error: $e');
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      final users = await UserController.deleteUser(id);
      _fetchUsers();
    } catch (e) {
      // Handle the error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    void logout() async {
      try {
        await AuthController.logout();
        authProvider.updateAuthStatus(false, 0);
        if (context.mounted && !authProvider.isLoggedIn) {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MyApp()));
        }
      } catch (e) {
        // Handle login error
        print(e);
      }
    }

    return Material(
      child: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name!),
                  subtitle: Text(user.email!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => EditUserScreen(user: user))).then((result) {
                            if (result == true) {
                              _fetchUsers();
                            }
                          }
                        );
                        },
                        icon: Icon(Icons.edit)),
                      IconButton(onPressed: () {
                        DialogUtils.showDeleteConfirmationDialog(context, () {
                          _deleteUser(user.id!); // Call the delete function
                        });
                      }, icon: Icon(Icons.delete))
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailPage(userId: user.id)),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: logout,
            child: Text('Logout'),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CreateUserScreen())).then((result) {
                if (result == true) {
                  _fetchUsers();
                }
              }
              );
            },
            child: Text('Create user'),
          ),
        ],
      ),
    );
  }
}
