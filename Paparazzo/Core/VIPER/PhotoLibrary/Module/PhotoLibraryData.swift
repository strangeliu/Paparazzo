import UIKit

public struct PhotoLibraryData {
    public let selectedItems: [PhotoLibraryItem]
    public let maxSelectedPhotosCount: Int?
    public let maxSelectedGifCount: Int?
    public let maxSelectedVideosCount: Int?
    
    public init(
        selectedItems: [PhotoLibraryItem] = [],
        maxSelectedPhotosCount: Int? = nil,
        maxSelectedGifCount: Int? = nil,
        maxSelectedVideosCount: Int? = nil)
    {
        self.selectedItems = selectedItems
        self.maxSelectedPhotosCount = maxSelectedPhotosCount
        self.maxSelectedGifCount = maxSelectedGifCount
        self.maxSelectedVideosCount = maxSelectedVideosCount
    }
}
