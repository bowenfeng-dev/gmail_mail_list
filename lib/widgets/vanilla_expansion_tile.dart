import 'package:flutter/material.dart';

class VanillaExpansionTile extends StatefulWidget {
  /// The primary content of the list item.
  final Widget title;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  final List<Widget> children;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  const VanillaExpansionTile({
    Key key,
    this.title,
    this.children = const <Widget>[],
    this.onExpansionChanged,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  _VanillaExpansionTileState createState() => _VanillaExpansionTileState();
}

class _VanillaExpansionTileState extends State<VanillaExpansionTile> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: _handleTap,
          child: widget.title,
        ),
      ]..addAll(_isExpanded ? widget.children : []),
    );
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
