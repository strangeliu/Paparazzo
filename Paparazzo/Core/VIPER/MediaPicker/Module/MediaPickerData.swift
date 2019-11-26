import UIKit

public struct MediaPickerData {
    public let items: [MediaPickerItem]
    public let autocorrectionFilters: [Filter]
    public let selectedItem: MediaPickerItem?
    public let maxPhotosCount: Int?
    public let maxGifCount: Int?
    public let maxVideosCount: Int?
    public let cropEnabled: Bool
    public let autocorrectEnabled: Bool
    public let hapticFeedbackEnabled: Bool
    public let cropCanvasSize: CGSize
    public let initialActiveCameraType: CameraType
    public let cameraEnabled: Bool
    public let photoLibraryEnabled: Bool
    
    public init(
        items: [MediaPickerItem] = [],
        autocorrectionFilters: [Filter] = [],
        selectedItem: MediaPickerItem? = nil,
        maxPhotosCount: Int? = nil,
        maxGifCount: Int? = nil,
        maxVideosCount: Int? = nil,
        cropEnabled: Bool = true,
        autocorrectEnabled: Bool = false,
        hapticFeedbackEnabled: Bool = false,
        cropCanvasSize: CGSize = CGSize(width: 1280, height: 960),
        initialActiveCameraType: CameraType = .back,
        cameraEnabled: Bool = true,
        photoLibraryEnabled: Bool = true)
    {
        self.items = items
        self.autocorrectionFilters = autocorrectionFilters
        self.selectedItem = selectedItem
        self.maxPhotosCount = maxPhotosCount
        self.maxGifCount = maxGifCount
        self.maxVideosCount = maxVideosCount
        self.cropEnabled = cropEnabled
        self.autocorrectEnabled = autocorrectEnabled
        self.hapticFeedbackEnabled = hapticFeedbackEnabled
        self.cropCanvasSize = cropCanvasSize
        self.initialActiveCameraType = initialActiveCameraType
        self.cameraEnabled = cameraEnabled
        self.photoLibraryEnabled = photoLibraryEnabled
    }
}
