import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visiting_card/providers/contact_provider.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = "/contactDetails";
  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {

  int id = 0;/*
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
          builder: (context, provider, child) =>
              FutureBuilder(
                future: provider.getContactById(id),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    final contact = snapshot.data!;
                    return ListView(
                      children: [
                        Image.asset(contact.image, width: double.infinity,height: 250,fit: BoxFit.cover,),
                        ListTile(
                          title: Text(contact.name),
                        ),
                        ListTile(
                          title: Text(contact.mobile),
                        ),
                      ],
                    );
                  }
                  if(snapshot.hasError){
                    return const Center(child: Text("Failed to fetch data"),);
                  }
                  return const Center(child: Text("Please wait..."),);
                },
              )
      ),
    );
  }
}
