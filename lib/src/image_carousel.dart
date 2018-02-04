import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoomable_image/zoomable_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<ImageProvider> imageProviders;
  final double height;
  final TargetPlatform platform;
  final Duration interval;
  final bool allowZoom;
  final TabController tabController;

  // Images will shrink according to the value of [height]
  // If you prefer to use the Material or Cupertino style activity indicator set the [platform] parameter
  // Set [interval] to let the carousel loop through each photo automatically
  // Pinch to zoom will be turned on by default
  ImageCarousel(this.imageProviders,
      {this.height = 250.0, this.platform, this.interval, this.allowZoom = true, this.tabController});

  @override
  State createState() => new _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController ?? new TabController(vsync: this, length: widget.imageProviders.length);

    if (widget.interval != null) {
      new Timer.periodic(widget.interval, (_) {
        _tabController.animateTo(_tabController.index == _tabController.length - 1 ? 0 : ++_tabController.index);
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
        children: widget.imageProviders.map((ImageProvider provider) {
          return new CarouselImageWidget(widget, provider);
        }).toList(),
      ),
    );
  }
}

class CarouselImageWidget extends StatefulWidget {
  final ImageCarousel carousel;
  final ImageProvider imageProvider;

  CarouselImageWidget(this.carousel, this.imageProvider);

  @override
  State createState() => new _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImageWidget> {
  bool _loading = true;

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
          widget.imageProvider,
          scale: 16.0,
        ),
      ),
    );

    Navigator.of(context).push(
          defaultTargetPlatform == TargetPlatform.iOS
              ? new CupertinoPageRoute(builder: (BuildContext context) => scaffold)
              : new MaterialPageRoute(builder: (BuildContext context) => scaffold),
        );
  }

  @override
  void initState() {
    super.initState();

    widget.imageProvider.resolve(new ImageConfiguration()).addListener((i, b) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: _loading
          ? _getIndicator(widget.carousel.platform == null ? defaultTargetPlatform : widget.carousel.platform)
          : new GestureDetector(
              child: new Image(image: widget.imageProvider),
              onTap: () {
                if (widget.carousel.allowZoom) {
                  _toZoomRoute();
                }
              },
            ),
    );
  }
}
