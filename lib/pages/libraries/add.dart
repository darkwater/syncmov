// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncmov/models/library.dart';
import 'package:syncmov/widgets/async_button.dart';

class LibraryAddPage extends StatefulWidget {
  const LibraryAddPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LibraryAddPage(),
      fullscreenDialog: true,
    );
  }

  @override
  State<LibraryAddPage> createState() => _LibraryAddPageState();
}

class _LibraryAddPageState extends State<LibraryAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Library"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Field(
              label: "Name",
              controller: _nameController,
            ),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: "Host",
                    controller: _hostController,
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: _Field(
                    label: "Port",
                    isPort: true,
                    controller: _portController,
                  ),
                ),
              ],
            ),
            _Field(
              label: "Username",
              controller: _usernameController,
            ),
            _Field(
              label: "Password",
              isPassword: true,
              controller: _passwordController,
            ),
            _Field(
              label: "Path",
              controller: _pathController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: AsyncButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return false;
                    }

                    final library = Library(
                      id: Random().nextInt(1000000).toString(),
                      name: _nameController.text,
                      host: _hostController.text,
                      port: int.parse(_portController.text),
                      username: _usernameController.text,
                      password: _passwordController.text,
                      path: _pathController.text,
                    );

                    final res = await library.test();

                    if (context.findRenderObject() == null) {
                      return false;
                    }

                    if (res.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res),
                        ),
                      );
                      return false;
                    }

                    library.save();

                    Navigator.pop(context);
                    return true;
                  },
                  label: "Save",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final bool isPort;
  final bool isPassword;
  final TextEditingController controller;

  const _Field({
    super.key,
    required this.label,
    required this.controller,
    this.isPort = false,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      textInputAction: TextInputAction.next,
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a value";
        }

        if (isPort && int.tryParse(value) == null) {
          return "Please enter a valid port";
        }

        return null;
      },
    );
  }
}
