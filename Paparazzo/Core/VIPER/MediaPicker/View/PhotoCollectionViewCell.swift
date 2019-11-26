import ImageSource
import UIKit

class PhotoCollectionViewCell: UIImageSourceCollectionViewCell {
    
    var selectedBorderThickness: CGFloat = 4
    
    var selectedBorderColor: UIColor? = .blue {
        didSet {
            adjustBorderColor()
        }
    }
    
    private let tagButton = UIButton()
    
    // MARK: - UICollectionViewCell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        adjustBorderColor()
        
        tagButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        tagButton.setTitleColor(UIColor.darkText, for: .normal)
        tagButton.backgroundColor = UIColor(white: 1, alpha: 0.95)
        tagButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        tagButton.isUserInteractionEnabled = false
        contentView.addSubview(tagButton)
        tagButton.layer.cornerRadius = 5
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
            if asset.isVideo {
                tagButton.setTitle("Video", for: .normal)
                tagButton.isHidden = false
            } else if asset.isGif {
                tagButton.setTitle("Gif", for: .normal)
                tagButton.isHidden = false
            } else {
                tagButton.isHidden = true
            }
            if !tagButton.isHidden {
                tagButton.sizeToFit()
                let edge: CGFloat = isSelected ? 10 : 5
                tagButton.frame = CGRect(x: contentView.bounds.width - tagButton.bounds.width - edge, y: contentView.bounds.height - tagButton.bounds.height - edge, width: tagButton.bounds.width, height: tagButton.bounds.height)
            }
        }
    }
}
