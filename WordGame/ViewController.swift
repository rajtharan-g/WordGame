//
//  ViewController.swift
//  WordGame
//
//  Created by Rajtharan G on 06/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wordCollectionView: UICollectionView!
    
    var layout: InvertedStackLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = InvertedStackLayout()
        wordCollectionView.collectionViewLayout = layout
        _ = GameHelper.shared.loadNewGame()
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        self.layout.numOfCells = self.layout.numOfCells + 1
        print("Counter --> \(self.layout.numOfCells - 1)")
        self.wordCollectionView.reloadItems(at: [IndexPath(item: self.layout.numOfCells - 1, section: 0)])
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordCollectionViewCell
        let word = GameHelper.shared.fullWordArray[indexPath.row]
        cell.wordLabel.text = word
        cell.wordLabel.backgroundColor = UIColor.white
        return cell
    }
    
}
