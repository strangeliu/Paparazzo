import UIKit

final class PhotoLibraryViewController: PaparazzoViewController, PhotoLibraryViewInput, ThemeConfigurable {
    
    typealias ThemeType = PhotoLibraryUITheme
    
    private let photoLibraryView = PhotoLibraryView()
    
    // MARK: - UIViewController
    
    override func loadView() {
        view = photoLibraryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        hideNavigationBarShadow()
        
        UIApplication.shared.setStatusBarHidden(true, with: animated ? .fade : .none)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - ThemeConfigurable
    
    func setTheme(_ theme: ThemeType) {
        self.theme = theme
        photoLibraryView.setTheme(theme)
    }
    
    // MARK: - PhotoLibraryViewInput
    
    var onItemSelect: ((PhotoLibraryItem) -> ())?
    var onViewDidLoad: (() -> ())?
    
    var onPickButtonTap: (() -> ())? {
        get { return photoLibraryView.onConfirmButtonTap }
        set { photoLibraryView.onConfirmButtonTap = newValue }
    }
    
    var onCancelButtonTap: (() -> ())? {
        get { return photoLibraryView.onDiscardButtonTap }
        set { photoLibraryView.onDiscardButtonTap = newValue }
    }
    
    var onAccessDeniedButtonTap: (() -> ())? {
        get { return photoLibraryView.onAccessDeniedButtonTap }
        set { photoLibraryView.onAccessDeniedButtonTap = newValue }
    }
    
    @nonobjc func setTitle(_ title: String) {
        self.title = title
    }
    
    func setCancelButtonTitle(_ title: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(onCancelButtonTap(_:))
        )
    }
    
    func applyChanges(_ changes: PhotoLibraryViewChanges, animated: Bool, completion: (() -> ())?) {
        photoLibraryView.applyChanges(changes, animated: animated, completion: completion)
    }
    
    func setCanSelectMoreItems(_ canSelectMoreItems: Bool) {
        photoLibraryView.canSelectMoreItems = canSelectMoreItems
    }
    
    func setDimsUnselectedItems(_ dimUnselectedItems: Bool) {
        photoLibraryView.dimsUnselectedItems = dimUnselectedItems
    }
    
    func deselectAllItems() {
        photoLibraryView.deselectAndAdjustAllCells()
    }
    
    func scrollToBottom() {
        photoLibraryView.scrollToBottom()
    }
    
    func setAccessDeniedViewVisible(_ visible: Bool) {
        photoLibraryView.setAccessDeniedViewVisible(visible)
    }
    
    func setAccessDeniedTitle(_ title: String) {
        photoLibraryView.setAccessDeniedTitle(title)
    }
    
    func setAccessDeniedMessage(_ message: String) {
        photoLibraryView.setAccessDeniedMessage(message)
    }
    
    func setAccessDeniedButtonTitle(_ title: String) {
        photoLibraryView.setAccessDeniedButtonTitle(title)
    }
    
    func setProgressVisible(_ visible: Bool) {
        photoLibraryView.setProgressVisible(visible)
    }
    
    // MARK: - Private
    
    private var theme: PhotoLibraryUITheme?
    
    @objc private func onCancelButtonTap(_ sender: UIBarButtonItem) {
        onCancelButtonTap?()
    }
    
    @objc private func onPickButtonTap(_ sender: UIBarButtonItem) {
        onPickButtonTap?()
    }
    
    private func hideNavigationBarShadow() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.backgroundColor = .white
        navigationBar?.shadowImage = UIImage()
    }
}
