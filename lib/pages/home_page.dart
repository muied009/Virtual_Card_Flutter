import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visiting_card/pages/contact_details_page.dart';
import 'package:visiting_card/pages/from_page.dart';
import 'package:visiting_card/pages/scan_page.dart';
import 'package:visiting_card/providers/contact_provider.dart';

import '../models/contact_model.dart';
import '../utils/extensions.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    }
    isFirst = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Contacts"),
        elevation: 1,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, ScanPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          currentIndex: selectedIndex,
          backgroundColor: Colors.white60,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "All"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Favourite"),
          ],
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, _) {
          if (provider.contactList.isEmpty) {
            return const Center(
              child: Text("Nothing to show"),
            );
          } else {
            return ListView.builder(
                itemCount: provider.contactList.length,
                itemBuilder: (context, index) {
                  final contact = provider.contactList[index];
                  return Dismissible(
                    ///for swipable delete
                    key: ValueKey(contact.id),
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: _showConfirmationDialog,
                    onDismissed: (direction) async {
                      ///onDismissed tokhoni call hobe jokhon "_showConfirmationDialog" eta true return kobe
                      await provider.deleteContact(contact.id);
                      showMsg(context, 'Deleted');
                    },
                    direction: DismissDirection.endToStart,
                    child: ListTile(
                      ///navigator = (context, kun page e jabo, ki niye jabo parameter hisebe)
                      onTap: () => Navigator.pushNamed(
                          context, ContactDetailsPage.routeName,
                          arguments: contact.id),
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        contact.mobile,
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          provider.updateContactField(
                              contact, tblContactColFavorite);
                        },
                        icon: Icon(contact.favorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Contact'),
              content: const Text('Are you sure to delete this contact?'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('NO'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('YES'),
                ),
              ],
            ));
  }
}
