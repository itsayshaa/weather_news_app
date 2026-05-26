import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/news_model.dart';

class NewsCard
    extends StatelessWidget {

  final NewsModel news;

  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.news,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        child: ClipRRect(

          borderRadius:
          BorderRadius.circular(
            28,
          ),

          child: BackdropFilter(

            filter: ImageFilter.blur(
              sigmaX: 8,
              sigmaY: 8,
            ),

            child: Container(

              decoration: BoxDecoration(

                color:
                Colors.white
                    .withOpacity(
                  0.12,
                ),

                borderRadius:
                BorderRadius.circular(
                  28,
                ),

                border: Border.all(
                  color:
                  Colors.white24,
                ),
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Hero(

                    tag: news.imageUrl,

                    child:
                    CachedNetworkImage(

                      imageUrl:
                      news.imageUrl,

                      height: 220,

                      width:
                      double.infinity,

                      fit: BoxFit.cover,

                      placeholder:
                          (
                          context,
                          url,
                          ) =>
                          Container(
                            height: 220,

                            alignment:
                            Alignment
                                .center,

                            child:
                            const CircularProgressIndicator(),
                          ),

                      errorWidget:
                          (
                          context,
                          url,
                          error,
                          ) =>
                          Container(
                            height: 220,

                            color:
                            Colors.grey,

                            child:
                            const Icon(
                              Icons.broken_image,
                              color:
                              Colors.white,
                              size: 50,
                            ),
                          ),
                    ),
                  ),

                  Padding(

                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.blue,

                            borderRadius:
                            BorderRadius.circular(
                              30,
                            ),
                          ),

                          child: Text(
                            news.source,

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize:
                              12,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Text(
                          news.title,

                          maxLines: 2,

                          overflow:
                          TextOverflow
                              .ellipsis,

                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          news.description,

                          maxLines: 3,

                          overflow:
                          TextOverflow
                              .ellipsis,

                          style:
                          const TextStyle(
                            color:
                            Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}