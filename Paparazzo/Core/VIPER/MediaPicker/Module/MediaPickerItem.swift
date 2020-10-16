import ImageSource
import MobileCoreServices

/// Главная модель, представляющая фотку в пикере
public final class MediaPickerItem: Equatable {
    
    public enum Source {
        case camera
        case photoLibrary
    }
 
    public let image: ImageSource
    public let source: Source
    
    let originalItem: MediaPickerItem?
    
    public init(
        image: ImageSource,
        source: Source,
        originalItem: MediaPickerItem? = nil)
    {
        self.image = image
        self.source = source
        self.originalItem = originalItem
    }
    
    public convenience init(_ photoLibraryItem: PhotoLibraryItem) {
        self.init(
            image: photoLibraryItem.image,
            source: .photoLibrary,
            originalItem: nil
        )
    }
    
    public static func ==(item1: MediaPickerItem, item2: MediaPickerItem) -> Bool {
        return item1.image == item2.image
            // Let's hope we will not shoot ourselves in a foot by this
            || item1.originalItem?.image == item2.image
            || item2.originalItem?.image == item1.image
    }
}

extension MediaPickerItem {
    
    var isVideo: Bool {
        guard let image = image as? PHAssetImageSource else {
            return false
        }
        return image.asset.isVideo
    }
    
    var isGif: Bool {
        guard let image = image as? PHAssetImageSource else {
            return false
        }
        return image.asset.isGif
    }
}

extension Array where Element == MediaPickerItem {
    
    var hasVideo: Bool {
        return !filter({ $0.isVideo }).isEmpty
    }
    
    var hasGif: Bool {
        return !filter({ $0.isGif }).isEmpty
    }
}
