import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visiting_card/models/contact_model.dart';
import 'package:visiting_card/pages/home_page.dart';
import 'package:visiting_card/providers/contact_provider.dart';

import '../utils/extensions.dart';

class FormPage extends StatefulWidget {
  static const String routeName = "/form";

  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  ///state obj "State<FormPage>' ta distroy hoy gele any kind of controller gulo o distroy korte hobe to prevent memory leak
  ///to do this we need to override = dispose method
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final designationController = TextEditingController();
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final formKey =
      GlobalKey<FormState>(); // ei golobal key tha dharon korbe form er state k
  late ContactModel contactModel;

  @override
  void didChangeDependencies() {
    contactModel = ModalRoute.of(context)!.settings.arguments as ContactModel;
    nameController.text = contactModel.name;
    mobileController.text = contactModel.mobile;
    emailController.text = contactModel.email;
    designationController.text = contactModel.designation;
    companyNameController.text = contactModel.companyName;
    addressController.text = contactModel.address;
    websiteController.text = contactModel.website;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _savedContact, icon: const Icon(Icons.save))
        ],
        title: const Text("New Contact"),
        elevation: 1,
      ),
      body: Form(
        // ei form er child/state gulo k access korar jonno kora hoise(kichuta obj reference hisebe kaj korbe)
        key: formKey,
        //input view k validate korar jonno Form widget
        //TextFormField use kore validator function pabo
        //ja normal TextField e pabo na
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  /*hintText: "Name",*/
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field must not be empty";
                  }
                  if (value.length > 20) {
                    return "Name should not be longer than 20 characters";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  /*hintText: "Name",*/
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field must not be empty";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                      .hasMatch(value)) {
                    return "Invalid email address";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: mobileController,
                decoration: const InputDecoration(
                  /*hintText: "Name",*/
                  labelText: "Mobile",
                  prefixIcon: Icon(Icons.call),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field must not be empty";
                  }
                  /*
                  if (!RegExp(r"^[0-9]{12}$").hasMatch(value)) {
                    return "Invalid mobile number";
                  }*/
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  labelText: "Company Name",
                  prefixIcon: Icon(Icons.account_balance),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: designationController,
                decoration: const InputDecoration(
                  labelText: "Designation",
                  prefixIcon: Icon(Icons.label),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  prefixIcon: Icon(Icons.house_rounded),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.url,
                controller: websiteController,
                decoration: const InputDecoration(
                  labelText: "Web",
                  prefixIcon: Icon(Icons.web),
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 1 kind of lifecycle method
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    designationController.dispose();
    companyNameController.dispose();
    addressController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  void _savedContact() async {
    if (formKey.currentState!.validate()) {
      ///validate() ei 1ta method diye jotttto gula validator ase sobari null return check korbe
      ///jodi null ase tahole true return korbe noile jekono 1ta null na asle false return korbe
      ///
      ///textInput theke data gulo niye 1ta model/data class e dhukabo
      ///jate kore oi model class er obj k kaj e lagae map hisebe local db te dhukay dite parbo
      ///map er key guloi hobe column name

      contactModel.name = nameController.text;
      contactModel.email = emailController.text;
      contactModel.mobile = mobileController.text;
      contactModel.address = addressController.text;
      contactModel.companyName = companyNameController.text;
      contactModel.designation = designationController.text;
      contactModel.website = websiteController.text;
      contactModel.image = contactModel.image;

      //false karon ui update korbona sudu methode call dibo ,,,,,,tai
      Provider.of<ContactProvider>(context, listen: false)
          .insertContact(contactModel)
          .then((rowId) {
        if (rowId > 0) {
          showMsg(context, 'Saved');
          Navigator.popUntil(context,ModalRoute.withName(HomePage.routeName));//homepage na asa porjonto pop korte thakbe
        }
      });
    }
  }
}
