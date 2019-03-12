import Foundation
import ImageSource

final class PhotoLibraryInteractorImpl: PhotoLibraryInteractor {
    
    // MARK: - State
    private var maxSelectedPhotosCount: Int?
    private var maxSelectedVideosCount: Int?
    private var onAlbumEvent: ((PhotoLibraryAlbumEvent, PhotoLibraryItemSelectionState) -> ())?
    
    // MARK: - Dependencies
    private let photoLibraryItemsService: PhotoLibraryItemsService
    
    // MARK: - Init
    
    init(
        selectedItems: [PhotoLibraryItem],
        maxSelectedPhotosCount: Int? = nil,
        maxSelectedVideosCount: Int? = nil,
        photoLibraryItemsService: PhotoLibraryItemsService)
    {
        self.selectedItems = selectedItems
        self.maxSelectedPhotosCount = maxSelectedPhotosCount
        self.maxSelectedVideosCount = maxSelectedVideosCount
        self.photoLibraryItemsService = photoLibraryItemsService
    }
    
    // MARK: - PhotoLibraryInteractor
    private(set) var currentAlbum: PhotoLibraryAlbum?
    private(set) var selectedItems = [PhotoLibraryItem]()
    
    private var selectedPhotos: [PhotoLibraryItem] {
        return selectedItems.filter({ !$0.isVideo })
    }
    
    private var selectedVideos: [PhotoLibraryItem] {
        return selectedItems.filter({ $0.isVideo })
    }
    
    func observeAuthorizationStatus(handler: @escaping (_ accessGranted: Bool) -> ()) {
        photoLibraryItemsService.observeAuthorizationStatus(handler: handler)
    }
    
    func observeAlbums(handler: @escaping ([PhotoLibraryAlbum]) -> ()) {
        photoLibraryItemsService.observeAlbums { [weak self] albums in
            if let currentAlbum = self?.currentAlbum {
                // Reset current album if it has been removed, otherwise refresh it (title might have been changed).
                self?.currentAlbum = albums.first { $0 == currentAlbum }
            }
            handler(albums)
        }
    }
    
    func observeCurrentAlbumEvents(handler: @escaping (PhotoLibraryAlbumEvent, PhotoLibraryItemSelectionState) -> ()) {
        onAlbumEvent = handler
    }
    
    func isSelected(_ item: PhotoLibraryItem) -> Bool {
        return selectedItems.contains(item)
    }
    
    func selectItem(_ item: PhotoLibraryItem) -> PhotoLibraryItemSelectionState {
        if canSelectMoreItems() {
            selectedItems.append(item)
        }
        return selectionState()
    }
    
    func deselectItem(_ item: PhotoLibraryItem) -> PhotoLibraryItemSelectionState {
        if let index = selectedItems.index(of: item) {
            selectedItems.remove(at: index)
        }
        return selectionState()
    }
    
    func prepareSelection() -> PhotoLibraryItemSelectionState {
        let state = selectionState()
        switch state.selectionMode {
        case .none:
            return state
        case .photos:
            if maxSelectedPhotosCount == 1 {
                selectedItems.removeAll()
                return selectionState(preSelectionAction: .deselectAll)
            } else {
                return state
            }
        case .videos:
            if maxSelectedVideosCount == 1 {
                selectedItems.removeAll()
                return selectionState(preSelectionAction: .deselectAll)
            } else {
                return state
            }
        }
    }
    
    func setCurrentAlbum(_ album: PhotoLibraryAlbum) {
        guard album != currentAlbum else { return }
        
        currentAlbum = album
        
        photoLibraryItemsService.observeEvents(in: album) { [weak self] event in
            guard let strongSelf = self else { return }
            
            // TODO: (ayutkin) find a way to remove items in `selectedItems` that refer to removed assets
            
            if let onAlbumEvent = strongSelf.onAlbumEvent {
                dispatch_to_main_queue {
                    onAlbumEvent(event, strongSelf.selectionState())
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func canSelectMoreItems() -> Bool {
        if selectedPhotos.isEmpty {
            return maxSelectedVideosCount.flatMap { selectedVideos.count < $0 } ?? true
        } else {
            return maxSelectedPhotosCount.flatMap { selectedPhotos.count < $0 } ?? true
        }
    }
    
    private func selectionState(preSelectionAction: PhotoLibraryItemSelectionState.PreSelectionAction = .none) -> PhotoLibraryItemSelectionState {
        let selectionMode: PhotoLibraryItemSelectionMode
        if selectedItems.isEmpty {
            selectionMode = .none
        } else {
            selectionMode = selectedVideos.isEmpty ? .photos : .videos
        }
        return PhotoLibraryItemSelectionState(
            isAnyItemSelected: selectedItems.count > 0,
            selectionMode: selectionMode,
            canSelectMoreItems: canSelectMoreItems(),
            preSelectionAction: preSelectionAction
        )
    }
}
