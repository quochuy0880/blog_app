import 'dart:convert';

import 'package:blog_app/models/blog_post.dart';
import 'package:blog_app/screens/blog_post_details_screen.dart';
import 'package:blog_app/services/blog_post_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BlogPostService _blogPostService = BlogPostService();

  Future<List<BlogPost>> _getAllBlogPosts() async {
    var result = await _blogPostService.getAllBlogPosts();
    List<BlogPost> _list = List<BlogPost>();
    if (result != null) {
      var blogPosts = json.decode(result.body);
      //print(json.decode(result.body));
      blogPosts.forEach((blogPost) {
        var model = BlogPost();
        model.title = blogPost['title'];
        model.detail = blogPost['detail'];
        model.featuredImageUrl = blogPost['featured_image_url'];
        model.category = blogPost['category']['name'];
        model.createdAt = blogPost['created_at'];
        setState(() {
          _list.add(model);
        });
      });
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
      ),
      body: FutureBuilder<List<BlogPost>>(
        future: _getAllBlogPosts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BlogPost>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.network(
                                snapshot.data[index].featuredImageUrl),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BlogPostDetailsScreen(
                                              blogPost: snapshot.data[index],
                                            )));
                              },
                              child: Text(
                                snapshot.data[index].title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  snapshot.data[index].category,
                                  style: TextStyle(
                                      backgroundColor: Colors.black12,
                                      fontSize: 16.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  DateFormat("dd-MMM-yyyy").format(
                                      DateTime.parse(
                                          snapshot.data[index].createdAt)),
                                  style: TextStyle(
                                      backgroundColor: Colors.black12,
                                      fontSize: 16.0),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Container(
              child: Text('Loading ...'),
            );
          }
        },
      ),
    );
  }
}
