library image_carousel;

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ImageCarousel extends StatefulWidget {
  final List<CarouselImage> images;
  final double height;
  final TargetPlatform platform;

  // Images will shrink according to the value of [height]
  // If you prefer to use the Material or Cupertino style activity indicator set the [platform] parameter
  ImageCarousel(this.images, {this.height = 250.0, this.platform});

  @override
  State createState() => new _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> with SingleTickerProviderStateMixin {
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
        children: widget.images.map((CarouselImage ci) {
          return new CarouselImageWidget(widget, ci);
        }).toList(),
      ),
    );
  }
}

class CarouselImage {
  final ImageType type;
  final String uri;

  CarouselImage(this.type, this.uri);
}

class CarouselImageWidget extends StatefulWidget {
  final ImageCarousel carousel;
  final CarouselImage carouselImage;

  CarouselImageWidget(this.carousel, this.carouselImage);

  Image getImage() {
    switch (carouselImage.type) {
      case ImageType.network:
        return new Image.network(carouselImage.uri);
      default:
        return new Image.asset(carouselImage.uri);
    }
  }

  @override
  State createState() => new _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImageWidget> {
  Image _image;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _image = widget.getImage();

    if (widget.carouselImage.type == ImageType.network) {
      _image.image.resolve(new ImageConfiguration()).addListener((i, b) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: _loading
          ? widget.carousel.platform == TargetPlatform.android
              ? new CircularProgressIndicator()
              : new CupertinoActivityIndicator()
          : _image,
    );
  }
}

enum ImageType { asset, network }
