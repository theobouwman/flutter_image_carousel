# flutter_image_carousel

A flutter package for image carousels.

Supports both Asset and Network images.

## Example

```dart
new ImageCarousel(
  [
    new CarouselImage(ImageType.asset, "assets/car1.jpg"),
    new CarouselImage(ImageType.network, "http://urbantrunk.com/wp-content/uploads/2016/06/volkswagen-pink-beetle-thumbnail-1-990x667.jpg"),
    new CarouselImage(ImageType.cachedNetwork, "http://cached-images.com/image1.jpg"),
  ],
  interval: new Duration(seconds: 1),
)
```

## Showcase

![](https://github.com/theobouwman/flutter_image_carousel/blob/master/show_case_gif.gif)
