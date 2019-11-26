import UIKit

public final class PhotoLibraryAssemblyImpl: BasePaparazzoAssembly, PhotoLibraryAssembly {
    
    public func module(
        data: PhotoLibraryData,
        configure: (PhotoLibraryModule) -> ())
        -> UIViewController
    {
        let photoLibraryItemsService = PhotoLibraryItemsServiceImpl()
        
        let interactor = PhotoLibraryInteractorImpl(
            selectedItems: data.selectedItems,
            maxSelectedPhotosCount: data.maxSelectedPhotosCount,
            maxSelectedGifsCount: data.maxSelectedGifCount,
            maxSelectedVideosCount: data.maxSelectedVideosCount,
            photoLibraryItemsService: photoLibraryItemsService
        )
        
        let viewController = PhotoLibraryViewController()
        
        let router = PhotoLibraryUIKitRouter(viewController: viewController)
        
        let presenter = PhotoLibraryPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        viewController.setTheme(theme)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
