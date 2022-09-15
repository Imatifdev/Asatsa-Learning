class IntroHelper {
  getImage(int i) {
    return 'assets/images/intro${i + 1}.png';
  }

  geTitle(int i) {
    List title = [
      "House Cleaning Service",
      "Repairing Services",
      "Home Shifting Service"
    ];
    return title[i];
  }

  geSubTitle(int i) {
    List subTitle = [
      "Get house cleaning services from expert cleaners",
      "Get repaired anything from our thousands of experts",
      "Take our home shifting service to get best service"
    ];
    return subTitle[i];
  }
}
