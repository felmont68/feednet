import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feednet/services/profile_service.dart';
import 'package:feednet/services/user_service.dart';
import 'package:feednet/utils/custom_dialog.dart';
import 'package:feednet/utils/routes.dart';
import 'package:feednet/widgets/profile_stat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _uploadProfilePicture(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función para cargar foto no implementada')),
    );
  }

  void _deleteAccount(BuildContext context) async {
    bool? result = await customDialog(
      context,
      'Inactivar cuenta',
      '¿Estás seguro de que deseas inactivar tu cuenta?',
    );

    if (result != null && result) {
      bool isUpdated = await Provider.of<ProfileService>(context)
          .updateStatus(context);
      if (isUpdated) {
        await Provider.of<UserService>(context, listen: false).clearUserData();
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cuenta inactivada',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print("Error al actualizar el status");
      }
    }
  }

  void _logout(BuildContext context) async {
    bool? result = await customDialog(
      context,
      'Cerrar sesión',
      '¿Estás seguro de que deseas cerrar sesión?',
    );

    if (result != null && result) {
      await Provider.of<UserService>(context, listen: false).clearUserData();
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        leading: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: Provider.of<ProfileService>(context).getUserData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar datos'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No se encontraron datos'));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData['picture'] ??
                          const Icon(Icons.person,
                              size: 50, color: Colors.grey)),
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _uploadProfilePicture(context),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  '${userData['first_name']} ${userData['last_name']}',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    profileStat('Seguidores', userData['followers']),
                    profileStat('Seguidos', userData['followed']),
                    profileStat('Publicaciones', 15),
                  ],
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  onPressed: () => _deleteAccount(context),
                  child: const Text(
                    'Inactivar cuenta',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  onPressed: () => _logout(context),
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
