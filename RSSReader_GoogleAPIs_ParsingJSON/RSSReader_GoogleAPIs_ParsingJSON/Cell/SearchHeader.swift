//
//  SearchHeader.swift
//  RSSReader_GoogleAPIs_ParsingJSON
//
//  Created by Mospeng Research Lab Philippines on 5/25/20.
//  Copyright © 2020 Mospeng Research Lab Philippines. All rights reserved.
//

import UIKit

class SearchHeader: BaseCell {
    
    var searchFeedCollectionViewController: SearchFeedCollectionViewController?
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search for RSS Feeds.."
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.borderWidth = 1
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        searchTextField.delegate = self
        
        addSubview(searchTextField)
        addSubview(searchButton)
        addSubview(dividerView)
        
        addContraintsWithFormat("H:|-8-[v0][v1(80)]|", views: searchTextField, searchButton)
        addContraintsWithFormat("H:|[v0]|", views: dividerView)
        
        addContraintsWithFormat("V:|[v0]|", views: searchButton)
        addContraintsWithFormat("V:|[v0][v1(0.5)]|", views: searchTextField, dividerView)
    }
    
    // When user taps search button
    @objc func search() {
        searchFeedCollectionViewController?.performSearchForText(searchTextField.text!)
    }
}

extension SearchHeader: UITextFieldDelegate {
    
    // When user taps return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFeedCollectionViewController?.performSearchForText(searchTextField.text!)
        return true
    }
}
