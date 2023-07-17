class Post {
  String user;
  String mkoa;
  String offerkat;
  String umri;
  String offering;
  String wishkat;
  String wishing;
  String datePosted;
  String email;
  String? postItself;
  String? postLocation;
  String postDesc;

  Post(
      {required this.user,
      required this.mkoa,
      required this.offerkat,
      required this.umri,
      required this.offering,
      required this.wishkat,
      required this.wishing,
      required this.datePosted,
      required this.email,
      required this.postDesc});

  Map<String, dynamic> toSamsWay() => {
        'user': user,
        'mkoa': mkoa,
        'offerkat': offerkat,
        'umri': umri,
        'offering': offering,
        'wishkat': wishkat,
        'wishing': wishing,
        'datePosted': datePosted,
        'email': email,
        'post_itself': postItself,
        'post_location': postLocation,
        'maelezo': postDesc
      };
}
