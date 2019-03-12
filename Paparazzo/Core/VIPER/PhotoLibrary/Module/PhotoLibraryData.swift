import UIKit

public struct PhotoLibraryData {
    public let selectedItems: [PhotoLibraryItem]
    public let maxSelectedPhotosCount: Int?
    public let maxSelectedVideosCount: Int?
    
    public init(
        selectedItems: [PhotoLibraryItem] = [],
        maxSelectedPhotosCount: Int? = nil,
        maxSelectedVideosCount: Int? = nil)
    {
        self.selectedItems = selectedItems
        self.maxSelectedPhotosCount = maxSelectedPhotosCount
        self.maxSelectedVideosCount = maxSelectedVideosCount
    }
}
