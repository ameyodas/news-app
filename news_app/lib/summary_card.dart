import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String summary;
  final double height;
  final double roundness;

  const SummaryCard(
      {Key? key,
      required this.summary,
      this.height = 178.0,
      this.roundness = 24.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.roundness), // Rounded corners
        side: BorderSide(
            color: Colors.white24, width: 1), // Border color and width
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(
        children: [
          // Image Section
          Stack(
            children: [
              // Background Image
              Container(
                height: this.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        //'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Frsamorim.azurewebsites.net%2Fwp-content%2Fuploads%2F2020%2F05%2F68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f3830302f312a5471364375495f494a306b5838443274546f556554512e676966.gif&f=1&nofb=1&ipt=0eb71e440ecac5b73424ed6dc6d1a970aa880d6d18048b9ed12903fcc5864fe4&ipo=images'),
                        'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwallpaperaccess.com%2Ffull%2F741758.jpg&f=1&nofb=1&ipt=18a6447fc02ec4d3280ed588e9c6ef4cd60828cdafc1a2232b1649c99793f21a&ipo=images'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                height: this.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              // Text Content over Image
              Container(
                padding: const EdgeInsets.all(22.0),
                width: double.infinity,
                height: this.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rapid Fire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(1, 1)),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        summary,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(1, 1)),
                          ],
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
