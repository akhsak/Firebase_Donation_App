import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/controller/home_donor_provider.dart';
import 'package:crud_firebase/model/donor_model.dart';
import 'package:crud_firebase/view/add_page.dart';
import 'package:crud_firebase/view/detail_page.dart';
import 'package:crud_firebase/view/edit_page.dart';
import 'package:crud_firebase/widget/text_style.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textTitle(data: 'Home', size: 25),
        backgroundColor: const Color.fromARGB(255, 217, 29, 29),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 10),
          ),
          Expanded(
            child: Consumer<DonorProvider>(
              builder: (context, value, child) => StreamBuilder(
                stream: value.getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Snapshot has error'));
                  } else {
                    List<QueryDocumentSnapshot<DonorModel>> donorDoc =
                        snapshot.data?.docs ?? [];
                    return ListView.builder(
                      itemCount: donorDoc.length,
                      itemBuilder: (context, index) {
                        final data = donorDoc[index].data();
                        final id = donorDoc[index].id;
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(
                              data.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Group: ${data.group}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 26, 58, 118),
                                  ),
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 26, 58, 118),
                              backgroundImage: NetworkImage(data.image!),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 26, 58, 118),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScreen(
                                          id: id,
                                          bloodgp: data,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    bool deleted = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Donor'),
                                          content: const Text(
                                              'Are you sure you want to delete this donor?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (deleted) {
                                      value.deleteStudent(id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Successfully deleted'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(donor: data),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 217, 29, 29),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
