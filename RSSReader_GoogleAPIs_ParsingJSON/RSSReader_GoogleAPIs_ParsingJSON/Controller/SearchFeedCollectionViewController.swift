//
//  SearchFeedCollectionViewController.swift
//  RSSReader_GoogleAPIs_ParsingJSON
//
//  Created by Mospeng Research Lab Philippines on 5/25/20.
//  Copyright © 2020 Mospeng Research Lab Philippines. All rights reserved.
//

import UIKit

class SearchFeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

//    var entries: [Entry]? = [
//        Entry(title: "Sample Title 1", content: "Example Content 1", url: nil),
//        Entry(title: "Sample Title 2", content: "Example Content 2", url: nil),
//        Entry(title: "Sample Title 3", content: "Example Content 3", url: nil)
//    ]
    var entries: [Entry]?
    
    let headerId = "headerId"
    let entryCellId = "entryCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "RSS Reader"
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        registerCells()
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
            layout.estimatedItemSize = CGSize(width: view.frame.width, height: 100)
        }
    }

    func registerCells() {
        
        collectionView?.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(EntryCell.self, forCellWithReuseIdentifier: entryCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          
          if let count = entries?.count{
              return count
          }
          return 0
      }
    
    // - - - Header - - -
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SearchHeader
        searchHeader.searchFeedCollectionViewController = self
        return searchHeader
    }
    // Use 'UICollectionViewDelegateFlowLayout' to provide size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    // - - - Header - - -
    
    
    // - - - Cell - - -
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entry = entries?[indexPath.item]
        
        let entryCell = collectionView.dequeueReusableCell(withReuseIdentifier: entryCellId, for: indexPath) as! EntryCell
        entryCell.createdAtLabel.text = entry?.created_at
//        entryCell.titleTextView.text = entry?.title
        
        //change from html to plain text
        let data = entry?.title?.data(using: String.Encoding.unicode)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlText = try(NSAttributedString(data: data!, options: options, documentAttributes: nil))
            entryCell.titleTextView.attributedText = htmlText
        }
        catch let error {
            print(error)
        }
        
        return entryCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    // - - - Cell - - -
    
    func performSearchForText(_ text: String) {
            print("Performing search for '\(text)', please wait...")
                        
        let urlString = "https://hn.algolia.com/api/v1/search?tags=front_page&query=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let url  = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error: \(error!)")
                    return
                }
                
//                let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("string: \(string!)")
                
                do {
                    let json = try(JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())) as? NSDictionary
                    if let hits = json?["hits"] as? [NSDictionary] {
                        self.entries = [Entry]() // entries needs to re-initialize
                        for hit in hits {
                            let created_at = hit["created_at"] as! String
                            let title = hit["title"] as! String
                            let url = hit["url"] as! String
                            self.entries?.append(Entry(created_at: created_at, title: title, url: url))
                        }
                    }
                    // To prevent crashing on background thread
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                catch let error {
                    print(error)
                }
            }.resume()

        }
    }
}

