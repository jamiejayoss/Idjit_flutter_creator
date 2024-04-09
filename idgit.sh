#!/bin/bash

# Function to create a Flutter app
kickstart() {
    flutter create "$1"
}

# Function to navigate to the Flutter app directory
cd_to_flutter_app() {
    cd "$1"
}

# Function to add dependencies to pubspec.yaml
add_dependencies() {
    while [ "$#" -gt 0 ]; do
        echo "Adding dependency: $1"
        flutter pub add "$1"
        shift
    done
}

# Function to create folders and files in lib directory
setup_lib() {
    mkdir -p lib/apis lib/features lib/core lib/extensions lib/responsive lib/common lib/features/home/mobile lib/features/home/web
    cat <<EOT > lib/extensions/string_extension.dart
extension StringExtentension on String {
  String get removeAllWhiteSpace => splitMapJoin(' ');
  int get toInt => int.parse(this);
    log({String? name}) {
    dev.log(this, name: name ?? 'Log');
  }
}

EOT
cat <<EOT > lib/extensions/context_extension.dart
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  showSnackbar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}

EOT

cat <<EOT > lib/main.dart
import 'package:flutter/material.dart';

import 'responsive/responsive_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveView();
  }
}

EOT

cat <<EOT > lib/responsive/responsive_view.dart

import 'package:flutter/material.dart';

import '../features/home/mobile/mobile_home_view.dart';
import '../features/home/web/web_home_view.dart';

class ResponsiveView extends StatelessWidget {
  const ResponsiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.constrainWidth() < 450) {
          return const MobileHomeView();
        } else {
          return const WebHomeView();
        }
      },
    );
  }
}


EOT

cat <<EOT > lib/features/home/mobile/mobile_home_view.dart
import 'package:flutter/material.dart';

class MobileHomeView extends StatelessWidget {
  const MobileHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


EOT

cat <<EOT > lib/features/home/web/web_home_view.dart
import 'package:flutter/material.dart';

class WebHomeView extends StatelessWidget {
  const WebHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


EOT

cat <<EOT > lib/common/common.dart
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorText(text: text),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loader(),
    );
  }
}

EOT
}

# Function to open Visual Studio Code
open_vscode() {
    code .
}

download_vscode(){
 sudo snap install code --classic
}

# Check if flutter command is available
if ! command -v flutter &> /dev/null; then
    echo "BALLS!!! Flutter SDK is not installed or not in PATH. Please install Flutter."
    exit 1
fi

# Check if VSCode is installed
if ! command -v code &> /dev/null; then
    echo "BALLS!!! Visual Studio Code is not installed or not in PATH. Please install VSCode."
    exit 1
fi

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "You need to provide app name you idjit"
    exit 1
fi

# First argument is the app name
app_name="$1"
shift

# Create Flutter app
kickstart "$app_name"

# Navigate to app directory
cd_to_flutter_app "$app_name"

# Add specified dependencies
if [ "$#" -gt 0 ]; then
    add_dependencies "$@"
fi

# Setup lib directory
setup_lib

echo "Flutter app '$app_name' created with specified dependencies."

# Open VSCode in the app directory
open_vscode
