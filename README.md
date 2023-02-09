# Text Highlight Rounded

## Description

A custom widget which provides rounded highlighted text, made with painter

## Example



```dart
HighlightText(
    text: "This is example",
    textAlign: TextAlign.center,
    bold: 5,
    radius: 5,
    markColor: Colors.amber,
    isAllCornerRound : true,
    style: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
        color: Colors.black,
    ),
),
```
## Parameter
- `String` text
- `TextStyle` style;
- `double`? maxWidth;
- `double` radius;
- `Color` markColor;
- `TextAlign` textAlign;
- `double` bold;
- `bool` isAllCornerRound;