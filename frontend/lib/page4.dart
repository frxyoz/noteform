import 'package:flutter/material.dart';
import "video_view.dart";

class Page4 extends StatefulWidget {
  const Page4({super.key, required this.title});
  final String title;

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Container(
              height: 20,
              child: Image.asset("assets/yt_logo_rgb_dark.png")
          ),

          actions: [
            IconButton(
              icon: Icon(Icons.connected_tv_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            Container(
              height: 26,
              width: 26,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.thewrap.com%2Fwp-content%2Fuploads%2F2017%2F09%2FLeBron-James.jpg&f=1&nofb=1&ipt=4bc2b65abcfece448d37d798cc6270e14222e91a169ba361b3b197fadf0d47af&ipo=images",
                // This can be any image
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
        body: const Wrap(
          direction: Axis.horizontal,
          children: [
            VideoView(
                thumbnail: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Forlandodispatch.com%2Fwp-content%2Fuploads%2F2021%2F03%2Fmarch-madness-highlights-zags-stay-undefeated-with-win-over-usc.jpg&f=1&nofb=1&ipt=d6e271245d543d52d35fd361987dd9e87a2792f1c21f6a115a497dacf83c384f&ipo=images",
                title: "March Madness 2023 Highlights",
                authorProfilePic: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2Fbc%2F00%2F2a%2Fbc002a253f769c3f6241425cf009fba5.jpg&f=1&nofb=1&ipt=bd5ac5a69aaa2a13554ebff29a1035746021b48e4a0b7334ff0a91b4f163280e&ipo=images",
                author: "Basketball Fan",
                views: "3.8K",
                duration: "15:00",
                time: "2 months"
            ),
            VideoView(
                thumbnail: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmotorsportmagazine.b-cdn.net%2Fdatabase%2Fwp-content%2Fuploads%2Fsites%2F2%2F2021%2F12%2FMax-Verstappen-overtakes-Lewis-Hamilton-in-the-2021-Abu-Dhabi-Grand-Prix-1-1600x900.jpg&f=1&nofb=1&ipt=0367a92bc2e20562da276f38a7b08e6cdaa12ff4c34d025da5e3becf9722a665&ipo=images",
                title: "F1 2021 Abu Dhabi Grand Prix | The Championship Finale",
                authorProfilePic: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fs1.cdn.autoevolution.com%2Fimages%2Fnews%2Flewis-hamilton-doesnt-really-care-about-being-knighted-151615_1.jpg&f=1&nofb=1&ipt=bf978d1ac91895732bc0bff873d8c927a1ed9ad3bda983fe232bc6ab7996812d&ipo=images",
                author: "car_person",
                views: "401K",
                duration: "38:21",
                time: "2 years"
            ),
            VideoView(
                thumbnail: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fassets.khelnow.com%2Fnews%2Fuploads%2F2022%2F11%2FSPAIN-VS-JAPAN-scaled.jpg&f=1&nofb=1&ipt=dfdfe1ad877cc33d14a5d7eb9670aae0b8b1e7d8ba44b2bd2d4016228f18afcd&ipo=images",
                title: "Recap of FIFA World Cup 2022 | Group E | Japan vs. Spain",
                authorProfilePic: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2Fbc%2F00%2F2a%2Fbc002a253f769c3f6241425cf009fba5.jpg&f=1&nofb=1&ipt=bd5ac5a69aaa2a13554ebff29a1035746021b48e4a0b7334ff0a91b4f163280e&ipo=images",
                author: "Soccer Fan",
                views: "1.2M",
                duration: "10:00",
                time: "6 months"
            )
          ],
        )
    );
  }
}