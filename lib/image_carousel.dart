library image_carousel;

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:zoomable_image/zoomable_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<CarouselImage> images;
  final double height;
  final TargetPlatform platform;
  final Duration interval;
  final bool allowZoom;

  // Images will shrink according to the value of [height]
  // If you prefer to use the Material or Cupertino style activity indicator set the [platform] parameter
  // Set [interval] to let the carousel loop through each photo automatically
  // Pinch to zoom will be turned on by default
  ImageCarousel(this.images,
      {this.height = 250.0,
      this.platform,
      this.interval,
      this.allowZoom = true});

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

    if (widget.interval != null) {
      new Timer.periodic(widget.interval, (_) {
        _tabController.animateTo(
            _tabController.index == _tabController.length - 1
                ? 0
                : ++_tabController.index);
      });
    }
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

  Widget _getIndicator(TargetPlatform platform) {
    if (platform == TargetPlatform.iOS) {
      return new CupertinoActivityIndicator();
    } else {
      return new CircularProgressIndicator();
    }
  }

  void _toZoomRoute() {
    Widget scaffold = new Scaffold(
      body: new Center(
        child: new ZoomableImage(
          _image.image,
          scale: 16.0,
        ),
      ),
    );

    Navigator.of(context).push(
          defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoPageRoute(
                  builder: (BuildContext context) => scaffold)
              : new MaterialPageRoute(
                  builder: (BuildContext context) => scaffold),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: _loading
          ? _getIndicator(widget.carousel.platform == null
              ? defaultTargetPlatform
              : widget.carousel.platform)
          : new GestureDetector(
              child: _image,
              onTap: () {
                if (widget.carousel.allowZoom) {
                  _toZoomRoute();
                }
              },
            ),
    );
  }
}

enum ImageType { asset, network }
