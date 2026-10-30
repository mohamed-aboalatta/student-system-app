import 'package:flutter/material.dart';
import 'package:student_system/home/cubit/home_cubit.dart';

Future<bool?> showEditDialog({
  required BuildContext context,
  required HomeCubit cubit,
  required String id,
  required Map<String, dynamic> student,
}) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      cubit.nameController.text = student["name"];
      cubit.ageController.text = student["age"];
      cubit.gradeController.text = student["grade"];

      return AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            spacing: 15,
            children: [
              TextFormField(
                controller: cubit.nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              TextFormField(
                controller: cubit.ageController,
                decoration: InputDecoration(
                  hintText: "Enter your age",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              TextFormField(
                controller: cubit.gradeController,
                decoration: InputDecoration(
                  hintText: "Enter your grade",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              if (cubit.nameController.text.trim().isEmpty ||
                  cubit.ageController.text.trim().isEmpty ||
                  cubit.gradeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please fill all fields",
                      style: TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              await cubit.updateStudentOnServer(id);

              if (!dialogContext.mounted) return;

              if (cubit.state is UpdateStudentSuccess) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
