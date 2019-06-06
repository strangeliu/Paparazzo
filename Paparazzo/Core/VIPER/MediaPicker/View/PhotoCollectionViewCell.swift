import ImageSource
import UIKit

class PhotoCollectionViewCell: UIImageSourceCollectionViewCell {
    
    var selectedBorderThickness: CGFloat = 4
    
    var selectedBorderColor: UIColor? = .blue {
        didSet {
            adjustBorderColor()
        }
    }
    
    private let videoTag = UIButton()
    
    // MARK: - UICollectionViewCell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        adjustBorderColor()
        
        videoTag.setTitle("Video", for: .normal)
        videoTag.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        videoTag.setTitleColor(UIColor.darkText, for: .normal)
        videoTag.backgroundColor = UIColor(white: 1, alpha: 0.95)
        videoTag.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        videoTag.isUserInteractionEnabled = false
        contentView.addSubview(videoTag)
        videoTag.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? selectedBorderThickness : 0            
        }
    }
    
    // MARK: - Private
    
    private func adjustBorderColor() {
        layer.borderColor = selectedBorderColor?.cgColor
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds.inset(by: imageViewInsets)
        
        if let imageSource = imageSource as? PHAssetImageSource {
            let asset = imageSource.asset
            if asset.mediaType == .video {
                videoTag.isHidden = false
                videoTag.sizeToFit()
                let edge: CGFloat = isSelected ? 10 : 5
                videoTag.frame = CGRect(x: contentView.bounds.width - videoTag.bounds.width - edge, y: contentView.bounds.height - videoTag.bounds.height - edge, width: videoTag.bounds.width, height: videoTag.bounds.height)
            } else {
                videoTag.isHidden = true
            }
        }
    }
}
