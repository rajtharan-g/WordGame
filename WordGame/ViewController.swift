//
//  ViewController.swift
//  WordGame
//
//  Created by Rajtharan G on 24/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wordCollectionView: UICollectionView!
    
    var layout: CustomLayout!
    var words: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = CustomLayout()
        wordCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseManager.shared.listenToFirebaseDB()
        FirebaseManager.shared.delegate = self
    }

    
    // MARK: - IBAction methods
    
    @IBAction func addRandomWord(_ sender: Any) {
        let words = FirebaseManager.shared.randomizeAvailableLetters(tileCount: 1)
        FirebaseManager.shared.updateWordToDB(words: words)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordCollectionViewCell
        let word = words[indexPath.item]
        cell.wordLabel.text = word
        cell.wordLabel.backgroundColor = UIColor.white
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            let loading = UIActivityIndicatorView()
            loading.style = .gray
            loading.translatesAutoresizingMaskIntoConstraints = false
            loading.tintColor = UIColor.gray
            view.addSubview(loading)
            return view
        }
        return UICollectionReusableView()
    }
    
}

extension ViewController: FirebaseManagerDelegate {

    func reloadCollectionView(words: [String]?) {
        if let words = words {
            self.words = words
        }
        wordCollectionView.reloadData()
    }
    
}
