class ConcentricModel {
  String imagess;
  String title;
  String subtitle;
  ConcentricModel({
    required this.imagess,
    required this.title,
    required this.subtitle,
  });
}

List<ConcentricModel> concentric = [
  ConcentricModel(
    imagess: "assets/images/dark1.png",
    title: "Find Favorite Items",
    subtitle: "Find your favorite products that you want to buy easily",
  ),
  ConcentricModel(
    imagess: "assets/images/dark02.png",
    title: "Greate Services",
    subtitle: "Save time and money while enjoying your life to the max!",
  ),
  ConcentricModel(
    imagess: "assets/images/dark2.png",
    title: "Product Delivery",
    subtitle: "Your product is delivered to your home safely and securely",
  ),
];
