import 'dart:math';
import 'package:flutter/material.dart';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 5.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 15.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class PaintingDetailPage extends StatefulWidget {
  @override
  _PaintingDetailPageState createState() => _PaintingDetailPageState();
}

class _PaintingDetailPageState extends State<PaintingDetailPage> {



  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new FlutterLogo(textColor: Colors.blue),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new FlutterLogo(
          style: FlutterLogoStyle.stacked, textColor: Colors.red),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new FlutterLogo(
          style: FlutterLogoStyle.horizontal, textColor: Colors.green),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: new Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left,
              color: Colors.black87,
              ),
          ),
          title: Text('Painting',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white70,
        ),
        body: new IconTheme(
          data: new IconThemeData(color: _kArrowColor),
          child: new Stack(
            children: <Widget>[

                 SizedBox(
                   height: 250,
                   child: PageView.builder(
                      physics: new AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        return _pages[index % _pages.length];
                      },
                    ),
                 ),
              new Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: new Container(
                  color: Colors.grey[800].withOpacity(0.5),
                  padding: const EdgeInsets.all(20.0),
                  child: new Center(
                    child: new DotsIndicator(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageSelected: (int page) {
                        _controller.animateToPage(
                          page,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}