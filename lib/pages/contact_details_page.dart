import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:visiting_card/providers/contact_provider.dart';
import 'package:visiting_card/utils/extensions.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = "/contactDetails";

  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  int id = 0;

  /*
  late ContactModel contactModel;*/

  @override
  void didChangeDependencies() {
    ///home page e jei id ta pathaisilam ta nicher code diye ei page e niye aslam
    id = ModalRoute.of(context)?.settings.arguments as int;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
        elevation: 1,
      ),
      body: Consumer<ContactProvider>(
          builder: (context, provider, child) => FutureBuilder(
                future: provider.getContactById(id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final contact = snapshot.data!;
                    return ListView(
                      children: [
                        Image.asset(
                          contact.image,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        ListTile(
                          title: Text(contact.name),
                        ),
                        ListTile(
                          title: Text(contact.mobile),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _smsContact(contact.mobile);
                                  },
                                  icon: const Icon(Icons.sms)),
                              IconButton(
                                  onPressed: () {
                                    _callContact(contact.mobile);
                                  },
                                  icon: const Icon(Icons.call))
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(contact.email.isEmpty
                              ? "Not-Found"
                              : contact.email),
                          trailing: const Icon(Icons.email),

                          ///jodi null hoy tahole ontap kaj korbe na
                          onTap: contact.email.isEmpty
                              ? null
                              : () => _emailSend(contact.email),
                        ),
                        ListTile(
                          title: Text(contact.address.isEmpty
                              ? "Not-Found"
                              : contact.address),
                          trailing: const Icon(Icons.map),
                          onTap: contact.address.isEmpty
                              ? null
                              : () => _openMap(contact.address),
                        ),
                        ListTile(
                          title: Text(contact.companyName.isEmpty
                              ? "Not-Found"
                              : contact.companyName),
                          subtitle: Text(contact.designation.isEmpty
                              ? "Designation : Not-Found"
                              : contact.designation),
                          trailing: const Icon(Icons.account_balance),
                        ),
                        ListTile(
                          title: Text(contact.website.isEmpty
                              ? "Not-Found"
                              : contact.website),
                          trailing: const Icon(Icons.web),
                          onTap: contact.website.isEmpty
                              ? null
                              : () => _openBrowser(contact.website),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Failed to fetch data"),
                    );
                  }
                  return const Center(
                    child: Text("Please wait..."),
                  );
                },
              )),
    );
  }

  void _smsContact(String mobile) async {
    final url = "sms:$mobile";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, "Can not perform this task");
    }
  }

  void _callContact(String mobile) async {
    final url = "tel:$mobile";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, "Can not perform this task");
    }
  }

  void _emailSend(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _openBrowser(String website) async {
    final url = 'https://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _openMap(String address) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'http://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }
}
