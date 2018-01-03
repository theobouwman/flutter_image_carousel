# flutter_image_carousel

A flutter package for image carousels.

Supports both Asset and Network images.

## Example

```dart
new ImageCarousel(
  <ImageProvider>[
    new NetworkImage('http://www.hilversum.ferraridealers.com/siteasset/ferraridealer/54f07ac8c35b6/961/420/selected/0/0/0/54f07ac8c35b6.jpg'),
    new NetworkImage('http://auto.ferrari.com/en_EN/wp-content/uploads/sites/5/2017/08/ferrari-portofino-reveal-2017-featured-new.jpg'),
    new NetworkImage('http://www.hilversum.ferraridealers.com/siteasset/ferraridealer/54f07ac8c35b6/961/420/selected/0/0/0/54f07ac8c35b6.jpg'),
  ],
  interval: new Duration(seconds: 1),
)
```

## Showcase

![](https://github.com/theobouwman/flutter_image_carousel/blob/master/show_case_gif.gif)
