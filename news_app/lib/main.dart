import 'package:flutter/material.dart';
import 'news_card.dart';
import 'summary_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark, // Enables dark theme
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent, // Accent color
          secondary: Colors.teal, // Secondary color
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // General text color
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      leadingWidth: 64,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
        child: Text("Ci",
            style: TextStyle(
              fontFamily: 'UnifrakturMaguntia',
              fontSize: 36.0,
            )),
      ),
      actions: <Widget>[
        Container(
          width: 128,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white10, // Background color for the search bar
            borderRadius: BorderRadius.circular(20), // Circular edges
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://images.pexels.com/photos/20787/pexels-photo.jpg?cs=srgb&dl=animal-cat-adorable-20787.jpg&fm=jpg',
            ), // Replace with your image URL
            radius: 16, // Adjust the size as needed
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: buildAppBar(context),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(left: 8.0),
              //   child: Text('Good Evening!',
              //       style: TextStyle(
              //           fontFamily: 'Inter',
              //           fontWeight: FontWeight.bold,
              //           fontSize: 16.0,
              //           color: Colors.white60)),
              // ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              const SummaryCard(
                summary:
                    """Quantum chips revolutionize AI. EcoSpace goes carbon-neutral. Urban green boosts biodiversity. AI restores artifacts. Smart jerseys aid athletes. Pacific cleanup revives marine life. Fusion food trends soar. Arctic research deepens. VR eases PTSD. E-sports hits billion-dollar mark.""",
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('For you',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white.withOpacity(0.9))),
              ),
              const SizedBox(
                height: 4.0,
              ),

              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    NewsCard(
                        headline: "Urban green boosts biodiversity",
                        description:
                            "A study highlights how cities integrating green roofs, vertical gardens, and urban forests are experiencing a surge in biodiversity, attracting rare bird and butterfly species while reducing urban heat.",
                        imageUrl:
                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIF.vQL2Cv7%252b5j85dxxqO%252bLVKQ%26pid%3DApi&f=1&ipt=83ca7f01de8673c3b5f588f5700b4d2b0655f42062e5771696039c596b0bb883&ipo=images'),
                    NewsCard(
                        headline: "Smart jerseys aid athletes",
                        description:
                            "A groundbreaking smart jersey for athletes debuted, featuring sensors that monitor vitals and optimize training schedules. Early trials show a 20% improvement in endurance.",
                        imageUrl:
                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.JnvTmikLXw8NyoSWMfvCFgHaEb%26pid%3DApi&f=1&ipt=85203083afa0e908b68bb6d20664b84a2f522cf463bead9a0b5ce76db98784c3&ipo=images'),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
