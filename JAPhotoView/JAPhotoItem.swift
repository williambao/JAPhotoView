//
//  JAPhotoItem.swift
//  JAPhotoView
//
//  Created by William on 18/01/2017.
//  Copyright © 2017 William. All rights reserved.
//

import UIKit

open class JAPhotoItem: UIView {
    open var cornerRadius: CGFloat = 0 {
        didSet {
            photoImageView.layer.cornerRadius = cornerRadius
        }
    }
    open var borderWidth: CGFloat = 0 {
        didSet {
            photoImageView.layer.borderWidth = borderWidth
        }
    }
    open var borderColor: UIColor? {
        didSet{
            photoImageView.layer.borderColor = borderColor?.cgColor
        }
    }
    
    private var photoWidth: CGFloat = 80
    private var photoHeight: CGFloat = 80
    private let textHeight:CGFloat = 25.0
    
    open dynamic var textColor: UIColor? {
        didSet{
            titleLabel.textColor = textColor
        }
    }
    open var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            titleLabel.font = textFont
        }
    }
    
    var deleteButtonImage: UIImage = UIImage() {
        didSet{
            deleteImageView.image = deleteButtonImage
        }
    }
    
    open var isShowText: Bool = false {
        didSet {
            frame = CGRect(x: 0, y: 0, width: photoWidth, height: photoHeight + (isShowText ? textHeight : 0))
        }
    }
    open var isEditable: Bool = false {
        didSet {
            deleteImageView.isHidden = !isEditable
        }
    }
    
    var itemPressed: ((JAPhotoItem) -> Void)?
    var deleteButtonPressed: ((JAPhotoItem) -> Void)?
    
    private var photo: UIImage?
    private var title: String = ""
    
    private var deleteImageView = UIImageView()
    private var photoImageView = UIImageView()
    private var titleLabel = UILabel()
    private var containerView = UIView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(photo: UIImage, title: String = "", width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect.zero)
        self.photo = photo
        self.title = title
        self.photoWidth = width
        self.photoHeight = height
        setupView()
    }
    
    private func setupView() {
        self.frame = CGRect(x: 0, y: 0, width: photoWidth, height: photoHeight + (isShowText ? textHeight : 0))
        
        photoImageView.image = photo
        photoImageView.layer.masksToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.frame = CGRect(x: 0, y: 0, width: photoWidth, height: photoHeight)
        self.addSubview(photoImageView)
        
        if isShowText {
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.frame = CGRect(x: 0, y: photoHeight, width: photoWidth, height: textHeight)
            self.addSubview(titleLabel)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoViewPressed))
        self.addGestureRecognizer(tap)
    }
    
    // MARK: - layout
    override open var intrinsicContentSize: CGSize {
        var size = self.frame.size
        size.height = photoHeight + (isShowText ? textHeight : 0)
        size.width = photoWidth
        return size
    }
    
    func photoViewPressed() {
        if let callback = itemPressed {
            callback(self)
        }
    }
}
