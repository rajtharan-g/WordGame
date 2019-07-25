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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var words: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        FirebaseManager.shared.listenToFirebaseDB()
        FirebaseManager.shared.delegate = self
    }

    override public var traitCollection: UITraitCollection {
        // Size class is same for iPad in landscape and portrait. So to differentiate we override the case for iPad in landscape
        if UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .regular),UITraitCollection(verticalSizeClass: .compact)])
        }
        return super.traitCollection
    }
    
    
    // MARK: - IBAction methods
    
    @IBAction func addRandomEmoji(_ sender: Any) {
        let emoji = GameHelper.randomEmoji()
        FirebaseManager.shared.updateEmojiToDB(emoji: emoji)
    }
    
    @IBAction func deleteAllEmojis(_ sender: Any) {
        FirebaseManager.shared.deleteAllEmojis()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordCollectionViewCell
        if let word = words?[indexPath.item] {
            cell.wordLabel.text = word
        } else {
            cell.wordLabel.text = GameHelper.randomEmoji()
        }
        cell.wordLabel.backgroundColor = UIColor.white
        return cell
    }
    
}

extension ViewController: FirebaseManagerDelegate {

    func reloadCollectionView(words: [String]?) {
        activityIndicator.stopAnimating()
        self.words = words
        wordCollectionView.reloadData()
    }
    
}
