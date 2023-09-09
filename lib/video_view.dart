import 'package:flutter/material.dart';


class VideoView extends StatelessWidget {

  final String thumbnail;
  final String title;
  final String authorProfilePic;
  final String author;
  final String duration;
  final String views;
  final String time;

  const VideoView(
      {super.key, required this.thumbnail, required this.title, required this.authorProfilePic, required this.author, required this.duration, required this.views, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack( // Stack allows you to position things on the z-axis; this is to add a duration tag on top of the video thumbnail
            children: [
              Image.network(
                thumbnail,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "$duration",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  )
              )
            ],
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(authorProfilePic),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          Text(
                            "$authorãƒ»$views viewsãƒ»$time ago",
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 24,
                      height: 20,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert, color: Colors.white)
                      ),
                    )
                  ]
              )
          )
        ],
      ),
    );
  }
}