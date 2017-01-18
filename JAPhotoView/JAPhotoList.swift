//
//  JAPhotoList.swift
//  tablexx
//
//  Created by William on 30/12/2016.
//  Copyright © 2016 William. All rights reserved.
//

import UIKit

open class JAPhotoList: UIView {
    
    open dynamic var cornerRadius: CGFloat = 0 {
        didSet {
            for item in photoViews {
                item.cornerRadius = cornerRadius
            }
            rearrangeViews()
        }
    }
    
    open dynamic var borderWidth: CGFloat = 0 {
        didSet {
            for item in photoViews {
                item.borderWidth = borderWidth
            }
            rearrangeViews()
        }
    }
    
    open dynamic var borderColor: UIColor? {
        didSet {
            for item in photoViews {
                item.borderColor = borderColor
            }
            rearrangeViews()
        }
    }
    
    open dynamic var textColor: UIColor? {
        didSet {
            for item in photoViews {
                item.textColor = textColor
            }
            rearrangeViews()
        }
    }
    open dynamic var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            for item in photoViews {
                item.textFont = textFont
            }
            rearrangeViews()
        }
    }
    
    open dynamic var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    open dynamic var marginY: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }

    open dynamic var photoWidth: CGFloat = 80 {
        didSet {
            rearrangeViews()
        }
    }
    open dynamic var photoHeight: CGFloat = 80 {
        didSet {
            rearrangeViews()
        }
    }
    
    // 0: not limit
    open dynamic var maxPhotoCount = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc public enum Alignment: Int {
        case left
        case center
        case right
    }
    @IBInspectable open var alignment: Alignment = .left {
        didSet {
            rearrangeViews()
        }
    }
    
    // show all photos in single line with scrolls
    open dynamic var isSingleLine: Bool = false {
        didSet {
            rearrangeViews()
        }
    }
    
    open dynamic var isShowText: Bool = false {
        didSet {
            rearrangeViews()
        }
    }
    
    // show all photos in single line with scrolls
    open dynamic var isEditable: Bool = false {
        didSet {
            rearrangeViews()
        }
    }
    
    open dynamic var addButtonImage: UIImage = UIImage(named: "cE5DqwlD7K2tC1viSoCitgIwdeSnecOw.png")! {
        didSet {
            rearrangeViews()
        }
    }
    
    open private(set) var photoViews: [JAPhotoItem] = []
    
    var photoPressed: ((_ index: Int, _ item: JAPhotoItem) -> Void)?
    var addButtonPressed: (() -> Void)?
    
    var removeButtonPressed: ((_ index: Int, _ item: JAPhotoItem) -> Void)?
    
    private var containerView = UIScrollView()
    private(set) var rowViews: [UIScrollView] = []
    private(set) var photoViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        rearrangeViews()
    }
    
    private func rearrangeViews() {
        
        for view in photoViews {
            view.removeFromSuperview()
        }
        for view in rowViews {
            for subView in view.subviews {
                subView.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIScrollView!
        var currentRowPhotoCount = 0
        var currentRowWidth: CGFloat = 0
        
        // 
        var addtional: [JAPhotoItem] = []
        if isEditable && (maxPhotoCount == 0 || photoViews.count < maxPhotoCount) && addtional.isEmpty {
            let addButton = createNewPhotoView(photo: addButtonImage, title: "")
            addButton.itemPressed = { _ in
                if let callback = self.addButtonPressed {
                    callback()
                }
            }
            addtional.append(addButton)
        }

        // callback event
        for (index, photoView) in photoViews.enumerated() {
            photoView.itemPressed = { item in
                self.itemPressed(at: index, sender: photoView)
            }
        }
        
        for (_, photoView) in  (photoViews + addtional).enumerated() {
            photoView.frame.size = photoView.intrinsicContentSize
            photoViewHeight = photoView.frame.height
            
            //print("\(index)-\(currentRow)-\(currentRowWidth)-\(photoView.frame.width)-\(frame.width)")
            
            if currentRowPhotoCount == 0 || (!isSingleLine && currentRowWidth + photoView.frame.width > frame.width) {

                currentRow += 1
                currentRowWidth = 0
                currentRowPhotoCount = 0
                currentRowView = UIScrollView()
                //currentRowView.backgroundColor = UIColor.lightGray
                currentRowView.isScrollEnabled = isSingleLine
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (photoViewHeight + marginY)
                currentRowView.frame.size = CGSize(width: frame.size.width, height: photoViewHeight)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)
            }
            
            photoView.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            currentRowView.addSubview(photoView)
            
            currentRowPhotoCount += 1
            currentRowWidth += photoView.frame.width + marginX
            
            switch alignment {
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frame.width - (currentRowWidth - marginX)) / 2
            case .right:
                currentRowView.frame.origin.x = frame.width - (currentRowWidth - marginX)
            }

            
            currentRowView.frame.size.height = max(photoViewHeight, currentRowView.frame.height)
            currentRowView.contentSize = CGSize(width: currentRowWidth, height: currentRowView.frame.size.height)
            

        }
        
        rows = currentRow
        
        invalidateIntrinsicContentSize()
        
//        layoutIfNeeded()
    }
    
    override open var intrinsicContentSize: CGSize {
        
        var height = CGFloat(rows) * (photoViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        //print("rows: \(rows), height: \(height)")
        return CGSize(width: frame.width, height: height)
    }
    
    private func createNewPhotoView(photo: UIImage, title: String) -> JAPhotoItem {
        let item = JAPhotoItem(photo: photo, title: title, width: photoWidth, height: photoHeight)
        item.textFont = textFont
        item.textColor = textColor
        item.borderWidth = borderWidth
        item.borderColor = borderColor
        item.isShowText = isShowText
        item.isEditable = isEditable
        
        return item
    }
    
    @discardableResult
    open func addPhotos(photos: [UIImage]) -> [JAPhotoItem] {
        var list: [JAPhotoItem] = []
        for item in photos {
            list.append(createNewPhotoView(photo: item, title: ""))
        }
        return addPhotoItems(list)
    }
    
    open func addPhotoItems(_ items: [JAPhotoItem]) -> [JAPhotoItem] {
        for item in items {
            photoViews.append(item)
        }
        rearrangeViews()
        return items
    }
    
    @discardableResult
    open func addPhoto(photo: UIImage) -> JAPhotoItem {
        return addPhoto(photo: photo, title: "")
    }
    
    @discardableResult
    open func addPhoto(photo: UIImage, title: String) -> JAPhotoItem {
        return addPhotoItem(createNewPhotoView(photo: photo, title: title))
    }
    
    @discardableResult
    open func addPhotoItem(_ item: JAPhotoItem) -> JAPhotoItem {
        photoViews.append(item)
        rearrangeViews()
        return item
    }
    
    open func insertPhoto(_ photo: UIImage, at index: Int) -> JAPhotoItem {
        return insertPhotoItem(createNewPhotoView(photo: photo, title: ""), at: index)
    }
    
    open func insertPhoto(_ photo: UIImage, title: String, at index: Int) -> JAPhotoItem {
        return insertPhotoItem(createNewPhotoView(photo: photo, title: title), at: index)
    }
    
    @discardableResult
    open func insertPhotoItem(_ item: JAPhotoItem, at index: Int) -> JAPhotoItem {
        photoViews.insert(item, at: index)
        rearrangeViews()
        return item
    }
    
    open func remove(at index: Int) {
        if photoViews.count <= index {
            return
        }
        remove(item: photoViews[index])
    }
    
    open func remove(item: JAPhotoItem) {
        item.removeFromSuperview()
        if let index = photoViews.index(of: item) {
            photoViews.remove(at: index)
        }
        
        rearrangeViews()
    }
    
    open func removeAll() {
        for view in photoViews {
            view.removeFromSuperview()
        }
        for rowView in rowViews {
            for view in rowView.subviews {
                view.removeFromSuperview()
            }
            rowView.removeFromSuperview()
        }
        photoViews = []
        rowViews = []
        rearrangeViews()
    }
    

    fileprivate func itemPressed(at index: Int, sender: JAPhotoItem!) {
        if let callback = photoPressed {
            callback(index, sender)
        }
    }
}
