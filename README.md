# AsyncResizableImage

A SwiftUI view that asynchronously downloads, cache and optionally resizes an image from a URL

## Features

- Asynchronously fetches an image from a URL
- Optionally resizes the image to a given size
- Caches the downloaded image
- Fully customizable placeholder and image rendering

## Installation

Add the following to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/YOUR_USERNAME/AsyncResizableImage.git", from: "1.0.0")
```

Then add `"AsyncResizableImage"` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        "AsyncResizableImage"
    ]
)
```

## Usage

```swift
import AsyncResizableImage
import SwiftUI

struct ContentView: View {
    var body: some View {
        AsyncResizableImage(
            url: URL(string: "https://example.com/image.jpg"),
            targetSize: CGSize(width: 200, height: 200),
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            },
            placeholder: {
                ProgressView()
            }
        )
    }
}
```

## License

MIT License. See [LICENSE](LICENSE) for details.
