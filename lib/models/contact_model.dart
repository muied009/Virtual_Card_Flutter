const String contactTable = "Contact_Table";
const String tblContactColId = "id";
const String tblContactColName = "name";
const String tblContactColMobile = "mobile";
const String tblContactColEmail = "email";
const String tblContactColCompanyName = "companyName";
const String tblContactColDesignation = "designation";
const String tblContactColWebsite = "website";
const String tblContactColImage = "image";
const String tblContactColAddress = "address";
const String tblContactColFavorite = "favorite";

class ContactModel {
  int id;
  String name;
  String email;
  String mobile;
  String companyName;
  String designation;
  String address;
  String website;
  String image;
  bool favorite;

  ContactModel(
      {this.id = -1,
      required this.name,
      required this.email,
      required this.mobile,
      this.companyName = "",
      this.designation = "",
      this.address = "",
      this.website = "",
      this.image = "images/person.png",
      this.favorite = false});

  ///helper function , rest api niye kaj korle toJson
  ///jokhoni contact model er 1ti obj er upore "toMap" call dibo
  ///tokhoni oi contact model er property gulo niye 1ta map pabo
  ///
  /// insert korar somoy toMap call dibo
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblContactColName: name,
      tblContactColEmail: email,
      tblContactColMobile: mobile,
      tblContactColAddress: address,
      tblContactColCompanyName: companyName,
      tblContactColDesignation: designation,
      tblContactColWebsite: website,
      tblContactColImage: image,
      tblContactColFavorite: favorite ? 1 : 0,///karon sqlite e true false rakhte parbo na, tai 1,0 store korsi
    };
    if (id > 0) {
      map[tblContactColId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, email: $email, mobile: $mobile, companyName: $companyName, designation: $designation, address: $address, website: $website, image: $image, favorite: $favorite}';
  }

  ///eibar map theke data retrive kore ui te show er jonno ways niche
  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        id: map[tblContactColId],
        name: map[tblContactColName],
        email: map[tblContactColEmail],
        mobile: map[tblContactColMobile],
        address: map[tblContactColAddress],
        companyName: map[tblContactColCompanyName],
        designation: map[tblContactColDesignation],
        website: map[tblContactColWebsite],
        image: map[tblContactColImage],
        favorite: map[tblContactColFavorite] == 1 ? true : false,
      );
}
