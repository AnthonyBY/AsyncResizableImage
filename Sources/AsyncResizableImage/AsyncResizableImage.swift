//
//  AsyncResizableImage.swift
//
//  Created by Anton Marchanka on 5/7/25.
//

import SwiftUI

/// A SwiftUI view that asynchronously downloads and optionally resizes an image from a URL.
///
/// - Parameters:
///   - url: The image URL to load from.
///   - targetSize: Optional size to which the image should be resized. If `nil`, no resizing occurs.
///   - content: A closure that takes the downloaded `Image` and returns a custom `View` to display.
///   - placeholder: A closure that returns a placeholder `View` shown while loading.
///
/// - Example:
/// ```
/// AsyncResizableImage(
///     url: URL(string: "https://example.com/image.jpg"),
///     targetSize: CGSize(width: 200, height: 200),
///     content: { image in
///         image
///             .resizable()
///             .aspectRatio(contentMode: .fit)
///     },
///     placeholder: {
///         ProgressView()
///     }
/// )
/// ```
///
@MainActor
public struct AsyncResizableImage<ImageView: View, PlaceholderView: View>: View {
    public var url: URL?
    public var targetSize: CGSize?

    @ViewBuilder public var content: (Image) -> ImageView
    @ViewBuilder public var placeholder: () -> PlaceholderView

    @State public var image: UIImage? = nil

    public init(
        url: URL?,
        targetSize: CGSize? = nil,
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView
    ) {
        self.url = url
        self.targetSize = targetSize
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        VStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            image = await downloadImage()
                        }
                    }
            }
        }
    }

    private func downloadImage() async -> UIImage? {
          guard let url else { return nil }

          if let cached = URLCache.shared.cachedResponse(for: .init(url: url)) {
              return resizeIfNeeded(data: cached.data)
          }

          do {
              let (data, response) = try await URLSession.shared.data(from: url)
              URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
              return resizeIfNeeded(data: data)
          } catch {
              print("Error downloading: \(error)")
              return nil
          }
      }

    private func resizeIfNeeded(data: Data) -> UIImage? {
        guard let targetSize else {
            return UIImage(data: data)
        }

        let scale = UIScreen.main.scale
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache : false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize : max(targetSize.width, targetSize.height) * scale
        ]
        guard
            let src = CGImageSourceCreateWithData(data as CFData, nil),
            let cg = CGImageSourceCreateThumbnailAtIndex(src, 0, options as CFDictionary)
        else { return nil }

        return UIImage(cgImage: cg)
    }
}
