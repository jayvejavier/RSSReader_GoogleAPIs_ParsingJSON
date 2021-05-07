//
//  EntryCell.swift
//  RSSReader_GoogleAPIs_ParsingJSON
//
//  Created by Mospeng Research Lab Philippines on 5/25/20.
//  Copyright © 2020 Mospeng Research Lab Philippines. All rights reserved.
//

import UIKit

class EntryCell: BaseCell {
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        
        addSubview(createdAtLabel)
        addSubview(titleTextView)
        addSubview(dividerView)
    
        addContraintsWithFormat("H:|-8-[v0]-8-|", views: createdAtLabel)
        addContraintsWithFormat("H:|-24-[v0]-3-|", views: titleTextView)
        addContraintsWithFormat("H:|-8-[v0]|", views: dividerView)
        
        addContraintsWithFormat("V:|-8-[v0(20)]-8-[v1][v2(0.5)]|", views: createdAtLabel, titleTextView, dividerView)
        
    }
    
    // This method provdes you to ability to set the frame on the window
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes

        let desiredHeight = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        attributes.frame.size.height = desiredHeight
        
        return attributes
    }
}

extension UIView {
    func addContraintsWithFormat(_ format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: .init(), metrics: nil, views: viewDictionary))
    }
}
