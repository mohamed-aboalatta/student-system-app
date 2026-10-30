import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system/home/cubit/home_cubit.dart';

class AddStudentContent extends StatelessWidget {
  const AddStudentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Add your data",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.msg, style: TextStyle(fontSize: 20)),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<HomeCubit>(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 20,
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    controller: cubit.nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: cubit.ageController,
                    decoration: InputDecoration(
                      hintText: "Enter your age",
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: cubit.gradeController,
                    decoration: InputDecoration(
                      hintText: "Enter your grade",
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  state is HomeLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            fixedSize: Size(300, 50),
                          ),
                          onPressed: () async {
                            if (cubit.nameController.text.trim().isEmpty ||
                                cubit.ageController.text.trim().isEmpty ||
                                cubit.gradeController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                            await cubit.addStudentToServer();

                            if (!context.mounted) return;

                            if (cubit.state is AddStudentSuccess) {
                              Navigator.pop(context, true);
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
