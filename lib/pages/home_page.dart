import 'dart:io';

import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_project/core/config.dart';
import 'package:flutter_ar_project/data/filters_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DeepArController? deepArController;

  Future<void> initializeController() async {
    if (deepArController == null) {
      deepArController = DeepArController();
      try {
        await deepArController?.initialize(
          androidLicenseKey: Config.androidKey,
          iosLicenseKey: Config.androidKey,
          resolution: Resolution.high,
        );
      } catch (e) {
        throw("Error Error initializing DeepAR: $e");
      }
    }
  }

  Widget buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: deepArController?.flipCamera,
          icon: const Icon(
            Icons.flip_camera_ios_outlined,
            size: 34,
            color: Colors.white,
          ),
        ),
        FilledButton(
          onPressed: deepArController?.takeScreenshot,
          child: const Icon(
            Icons.camera,
          ),
        ),
        IconButton(
          onPressed: deepArController?.toggleFlash,
          icon: const Icon(
            Icons.flash_on,
            size: 34,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildCameraPreview() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.82,
      child: Transform.scale(
        scale: 1.5,
        child: DeepArPreview(deepArController!),
      ),
    );
  }

  Widget buildFilters() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Make the list horizontal
        itemCount: filters.length,
        itemBuilder: (BuildContext context, int index) {
          final filter = filters[index];
          final effectFile = File('assets/filters/${filter.filtersPath}').path;
          return InkWell(
            onTap: () {
              try {
                // Apply the filter
                deepArController?.switchEffect(effectFile);

              } catch (e) {
                if (kDebugMode) {
                  print("Error applying filter: $e");
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/previews/${filter.imagePath}'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // initializeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initializeController(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: buildCameraPreview(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        buildButton(),
                        buildFilters(),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    deepArController?.destroy();
    deepArController = null; // Reset the controller
    super.dispose();
  }
}
