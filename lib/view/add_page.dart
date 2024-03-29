// ignore_for_file: sort_child_properties_last, use_super_parameters, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:crud_firebase/controller/add_provider.dart';
import 'package:crud_firebase/view/home_page.dart';
import 'package:crud_firebase/widget/text_formfield.dart';
import 'package:crud_firebase/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addProvider = Provider.of<AddProvider>(context, listen: false);
    // final mediaQuery = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: textTitle(data: 'Add Donor', size: 25),
        backgroundColor: const Color.fromARGB(255, 217, 29, 29),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (addProvider.selectedImage == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox(
                                child: Image.asset('assets/image-profile.png'),
                                height: 200,
                                width: double.infinity,
                              )),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Consumer<AddProvider>(
                            builder: (context, value, child) => ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(value.selectedImage!.path),
                                height: 100,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 217, 29, 29)),
                            onPressed: () {
                              addProvider.setImage(ImageSource.camera);
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            label: textPoppins(
                              data: 'Camera',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 217, 29, 29)),
                            onPressed: () {
                              addProvider.setImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.photo, color: Colors.white),
                            label: textPoppins(
                                data: 'Gallery', color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      customTextFormField(
                          controller: addProvider.nameController,
                          labelText: 'Name',
                          message: 'Enter the name'),
                      const SizedBox(height: 20),
                      dropDown(addProvider),
                      const SizedBox(height: 20),
                      customTextFormField(
                          controller: addProvider.phoneController,
                          labelText: 'Phone no ',
                          message: 'Enter the phone number',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxlength: 10,
                          keyboardType: TextInputType.number),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 217, 29, 29)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            addProvider.addStudent(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                            addProvider.selectedImage = null;
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                textPoppins(data: 'ADD', color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
