import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final bool isRichText;

  const ExpandableText({
    Key? key,
    required this.text,
    this.style,
    this.maxLines = 5,
    this.isRichText = false,
  }) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _isExpandable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfExpandable();
    });
  }

  void _checkIfExpandable() {
    final span = TextSpan(text: widget.text, style: widget.style);
    final tp = TextPainter(
      text: span,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width - 100);

    if (tp.didExceedMaxLines) {
      setState(() {
        _isExpandable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRichText) {
      return _buildRichText();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: Text(
            widget.text,
            style: widget.style,
            maxLines: _isExpanded ? null : widget.maxLines,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
        ),
        if (_isExpandable) _buildButton(),
      ],
    );
  }

  Widget _buildRichText() {
    final List<InlineSpan> children = [];
    final regex = RegExp(r'\*(.*?)\*');
    final matches = regex.allMatches(widget.text);

    int currentIndex = 0;
    for (final match in matches) {
      if (match.start > currentIndex) {
        children.add(
          TextSpan(
            text: widget.text.substring(currentIndex, match.start),
          ),
        );
      }

      children.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < widget.text.length) {
      children.add(TextSpan(
        text: widget.text.substring(currentIndex),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: RichText(
            maxLines: _isExpanded ? null : widget.maxLines,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            text: TextSpan(
              children: children,
              style: widget.style ??
                  const TextStyle(
                    fontSize: 14.0,
                    height: 22 / 14,
                    color: Colors.black,
                  ),
            ),
          ),
        ),
        if (_isExpandable) _buildButton(),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      transform: Matrix4.translationValues(-12, 0, 0),
      child: TextButton(
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isExpanded ? 'Show less' : 'Show more',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4.0),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 16.0,
              color: Colors.blue.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
