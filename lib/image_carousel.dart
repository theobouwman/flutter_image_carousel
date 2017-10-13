library image_carousel;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<CarouselImage> images;
  final double height;

  ImageCarousel(this.images, {this.height = 200.0});

  @override
  State createState() => new _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: widget.images.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: widget.height,
      child: new TabBarView(
        controller: _tabController,
        children: widget.images,
      ),
    );
  }
}

class CarouselImage extends StatelessWidget {
  final String title;
  final ImageType type;
  final String uri;

  CarouselImage(this.type, this.uri, {this.title});

  ImageProvider _getImage() {
    switch (type) {
      case ImageType.asset:
        return new AssetImage(uri);
      case ImageType.network:
        return new NetworkImage(uri);
      default:
        return new AssetImage(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DecoratedBox(
      decoration: new BoxDecoration(
        image: new DecorationImage(image: _getImage()),
      ),
    );
  }
}

enum ImageType { asset, network }
