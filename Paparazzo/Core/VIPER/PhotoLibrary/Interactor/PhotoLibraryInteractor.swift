import Foundation
import Photos
import ImageSource
import MobileCoreServices

protocol PhotoLibraryInteractor: class {
    
    var currentAlbum: PhotoLibraryAlbum? { get }
    var selectedItems: [PhotoLibraryItem] { get }
    
    func observeAuthorizationStatus(handler: @escaping (_ accessGranted: Bool) -> ())
    func observeAlbums(handler: @escaping ([PhotoLibraryAlbum]) -> ())
    func observeCurrentAlbumEvents(handler: @escaping (PhotoLibraryAlbumEvent, PhotoLibraryItemSelectionState) -> ())
    
    func isSelected(_: PhotoLibraryItem) -> Bool
    func selectItem(_: PhotoLibraryItem) -> PhotoLibraryItemSelectionState
    func deselectItem(_: PhotoLibraryItem) -> PhotoLibraryItemSelectionState
    func prepareSelection() -> PhotoLibraryItemSelectionState
    
    func setCurrentAlbum(_: PhotoLibraryAlbum)
}

public struct PhotoLibraryItem: Equatable {
    
    public var image: ImageSource
    
    public init(image: ImageSource) {
        self.image = image
    }
    
    public static func ==(item1: PhotoLibraryItem, item2: PhotoLibraryItem) -> Bool {
        return item1.image == item2.image
    }
    
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

struct PhotoLibraryItemSelectionState {
    
    enum PreSelectionAction {
        case none
        case deselectAll
    }
    
    var isAnyItemSelected: Bool
    var selectionMode: PhotoLibraryItemSelectionMode
    var canSelectMoreItems: Bool
    var preSelectionAction: PreSelectionAction
}

enum PhotoLibraryItemSelectionMode {
    
    case none
    case photos
    case videos
    case gifs
}

enum PhotoLibraryAlbumEvent {
    case fullReload([PhotoLibraryItem])
    case incrementalChanges(PhotoLibraryChanges)
}

struct PhotoLibraryChanges {
    
    // Changes must be applied in that order: remove, insert, update, move.
    // Indexes are provided based on this order of operations.
    let removedIndexes: IndexSet
    let insertedItems: [(index: Int, item: PhotoLibraryItem)]
    let updatedItems: [(index: Int, item: PhotoLibraryItem)]
    let movedIndexes: [(from: Int, to: Int)]
    
    let itemsAfterChanges: [PhotoLibraryItem]
}

extension Array where Element == PhotoLibraryItem {
    
    var hasVideo: Bool {
        return !filter({ $0.isVideo }).isEmpty
    }
    
    var hasGif: Bool {
        return !filter({ $0.isGif }).isEmpty
    }
}

extension PHAsset {
    
    public var isVideo: Bool {
        return mediaType == .video
    }
    
    public var isGif: Bool {
        if #available(iOS 11, *) {
            return playbackStyle == .imageAnimated
        } else {
            if let imageType = self.value(forKey: "uniformTypeIdentifier") as? String {
                return imageType == kUTTypeGIF as String
            } else {
                return false
            }
        }
    }
}
