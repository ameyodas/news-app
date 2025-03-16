import 'package:news_app/news.dart';

class INApi {
  static List<INNews> getNews() {
    return const [
      INNews(
          headline: "Urban green boosts biodiversity",
          content:
              "A study highlights how cities integrating green roofs, vertical gardens, and urban forests are experiencing a surge in biodiversity, attracting rare bird and butterfly species while reducing urban heat.",
          imageUrl: 'https://www.climateaction.org/images/made/images/uploads/carousel/acities_1000_668_80.jpg',
          tags: ['Urban', 'Eco']),
      INNews(
          headline: "Webb unravels a new era in cosmology",
          content:
              "A groundbreaking smart jersey for athletes debuted, featuring sensors that monitor vitals and optimize training schedules. Early trials show a 20% improvement in endurance.",
          //imageUrl: 'https://i2.wp.com/www.bwallpaperhd.com/wp-content/uploads/2018/09/JamesWebbSpaceTelescope-1280x1080.jpg',
          tags: ['Sports', 'Sci']),
      INNews(
        headline: "Urban green boosts biodiversity",
        content:
            "A study highlights how cities integrating green roofs, vertical gardens, and urban forests are experiencing a surge in biodiversity, attracting rare bird and butterfly species while reducing urban heat.",
        imageUrl:
            'https://i2.wp.com/www.bwallpaperhd.com/wp-content/uploads/2018/09/JamesWebbSpaceTelescope-1280x1080.jpg',
        //tags: ['Urban', 'Eco']
      ),
    ];
  }
}
