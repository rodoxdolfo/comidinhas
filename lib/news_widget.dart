import 'dart:async';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Post> fetchPost() async {
  final response =
  await http.get('https://rss.app/feeds/pPgftAX0ceQBr4Gi.xml');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromXml(xml.parse(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Post {
  final List<Item> items;

  Post({this.items});

  factory Post.fromXml(xml.XmlDocument xml) {
    return Post(
        items: xml.findAllElements('item').map((x) => new Item(
            x.findAllElements('title').first.text,
            x.findAllElements('link').first.toString(),
            x.findAllElements('description').first.text,
            (x.findAllElements('media:content').length > 0 ? x.findAllElements('media:content').first.getAttribute('url') : ''),
            (x.findAllElements('media:content').length > 0 ? double.parse(x.findAllElements('media:content').first.getAttribute('width')) : 0),
            (x.findAllElements('media:content').length > 0 ? double.parse(x.findAllElements('media:content').first.getAttribute('height')) : 0)),
        ).toList());
  }
}

class Item {

  final String title;
  final String link;
  final String description;
  final String mediaUrl;
  final double mediaWidth;
  final double mediaHeight;

  Item (this.title, this.link, this.description, this.mediaUrl, this.mediaWidth, this.mediaHeight);
}

class News extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _NewsState();
  }
}
class _NewsState extends State<News> {
  Future<Post> post;

  @override
  void initState() {
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Post>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.items.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data.items[index];
                    return new ListTile(
                        title:  Text(item.title == "No title" ? "" : item.title ),
                        subtitle: ( item.mediaUrl == '' ?  Html(
                            data: item.description,
                            onLinkTap: (url) {
                              _launchURL(url);
                            }) : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Expanded (child: Html(
                                  data: item.description,
                                  onLinkTap: (url) {
                                    _launchURL(url);
                                  })),
                              Expanded (child: Image.network(item.mediaUrl)),
                            ]
                        )
                        ));
                  }
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}