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
    
    public let identifier: String
    
    let originalItem: MediaPickerItem?
    
    public init(
        identifier: String = NSUUID().uuidString,
        image: ImageSource,
        source: Source,
        originalItem: MediaPickerItem? = nil)
    {
        self.identifier = identifier
        self.image = image
        self.source = source
        self.originalItem = originalItem
    }
    
    public static func ==(item1: MediaPickerItem, item2: MediaPickerItem) -> Bool {
        return item1.identifier == item2.identifier
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
