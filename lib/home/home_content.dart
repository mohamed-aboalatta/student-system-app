import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system/add_student/add_student_screen.dart';
import 'package:student_system/home/cubit/home_cubit.dart';
import 'package:student_system/home/delete_dialog.dart';
import 'package:student_system/home/edit_dialog.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );

          if (!context.mounted) return;

          if (result == true) {
            await context.read<HomeCubit>().getStudentFromServer();

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Student added successfully",
                  style: TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        backgroundColor: Colors.orange,
        label: Text(
          "Add Student",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "All Students",
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
          if (state is UpdateStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Student edited successfully",
                  style: TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is DeleteStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Student deleted successfully",
                  style: TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },

        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }
          if (state is GetStudentSuccess) {
            if (state.students.isEmpty) {
              return Center(child: Text("There is no students"));
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Name: ${state.students[index]["name"]}"),
                  subtitle: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text("Age: ${state.students[index]["age"]}"),
                      Text("Grade: ${state.students[index]["grade"]}"),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      final cubit = BlocProvider.of<HomeCubit>(context);
                      if (value == "edit") {
                        final updated = await showEditDialog(
                          context: context,
                          cubit: cubit,
                          id: state.students[index].id,
                          student: state.students[index].data(),
                        );
                        if (updated == true) {
                          await cubit.getStudentFromServer();
                        }
                      }
                      if (value == "delete") {
                        if (!context.mounted) return;
                        final deleted = await showDeleteDialog(
                          context: context,
                          cubit: cubit,
                          id: state.students[index].id,
                        );
                        if (deleted == true) {
                          await cubit.getStudentFromServer();
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(value: "edit", child: Text("Edit")),
                      PopupMenuItem<String>(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: state.students.length,
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
