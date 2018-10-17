public protocol PhotoLibraryUITheme: AccessDeniedViewTheme {
    
    var photoLibraryTitleFont: UIFont { get }
    var photoLibraryAlbumsDisclosureIcon: UIImage? { get }
    
    var photoLibraryItemSelectionColor: UIColor { get }
    var photoCellBackgroundColor: UIColor { get }
    
    var iCloudIcon: UIImage? { get }
    var photoLibraryDiscardButtonIcon: UIImage? { get }
    var photoLibraryConfirmButtonIcon: UIImage? { get }
    var photoLibraryAlbumCellFont: UIFont { get }
    var photoLibraryPlaceholderFont: UIFont { get }
    var photoLibraryPlaceholderColor: UIColor { get }
    
    var photoLibraryBackgroundColor: UIColor { get }
    var photoLibraryTopbarBackgroundColor: UIColor { get }
    var photoLibraryTopbarTitleColor: UIColor { get }
    var photoLibraryAlbumBackgroundColor: UIColor { get }
    var photoLibraryAlbumListDefaultTextColor: UIColor { get }
    var photoLibraryAlbumListSelectedTextColor: UIColor { get }
}
