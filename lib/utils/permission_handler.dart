
import 'package:flutter/material.dart';
import 'package:flutter_ar_project/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerDemo extends StatefulWidget {
  const PermissionHandlerDemo({super.key});

  @override
  _PermissionHandlerDemoState createState() => _PermissionHandlerDemoState();
}
var isPermission = false;

class _PermissionHandlerDemoState extends State<PermissionHandlerDemo> {
  Future<void> requestPermissions() async {
    // Request Camera and Storage permissions
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;

    if (cameraStatus.isDenied || storageStatus.isDenied) {
      // Request permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();

      if (statuses[Permission.camera]!.isGranted &&
          statuses[Permission.storage]!.isGranted) {
        print('Permissions granted');
        isPermission = true;
        HomePage();
      } else if (statuses[Permission.camera]!.isPermanentlyDenied ||
          statuses[Permission.storage]!.isPermanentlyDenied) {
        _showPermissionDialog();
      } else {
        print('Permissions denied');
      }
    }

  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Permissions Required'),
          content: Text(
              'This app requires camera and storage permissions to function properly. Please enable them in settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings
                Navigator.of(context).pop();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isPermission) {
      print('Permissions granted');
     return HomePage();
    }
    else {return Scaffold(
    appBar: AppBar(title: const Text('Permission Handler Demo')),
    body: Center(
    child: ElevatedButton(
    onPressed: requestPermissions,
    child: Text('Request Permissions'),
    ),
    ),
    );
    }
  }
}