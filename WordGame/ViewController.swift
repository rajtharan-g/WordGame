//
//  ViewController.swift
//  WordGame
//
//  Created by Rajtharan G on 06/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var wordCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = GameHelper.shared.loadNewGame()
        GameHelper.shared.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            GameHelper.shared.onTouchStarted()
            let start = touch.location(in: wordCollectionView)
            GameHelper.shared.addTouchIndex(x: start.x, y: start.y, collectionViewBounds: wordCollectionView.bounds)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let ticklePoint = touch.location(in: wordCollectionView)
            GameHelper.shared.addTouchIndex(x: ticklePoint.x, y: ticklePoint.y, collectionViewBounds: wordCollectionView.bounds)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let end = touch.location(in: wordCollectionView)
            GameHelper.shared.addTouchIndex(x: end.x, y: end.y, collectionViewBounds: wordCollectionView.bounds)
        }
        GameHelper.shared.onTouchEnded()
        wordCollectionView.reloadData()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let cancel = touch.location(in: wordCollectionView)
            print(cancel)
        }
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordCollectionViewCell
        let word = GameHelper.shared.fullWordArray[indexPath.row]
        cell.wordLabel.text = word
        cell.wordLabel.backgroundColor = UIColor.white
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width / 5.0) - 5.0, height:  (collectionView.bounds.size.height / 6.0) - 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
}

extension ViewController: GameHelperDelegate {
    
    func updateSelectedWord(index: Int) {
        if let cell = wordCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? WordCollectionViewCell {
            cell.wordLabel.backgroundColor = UIColor.gray
        }
    }
    
    func updateUnSelectedWord(index: Int) {
        if let cell = wordCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? WordCollectionViewCell {
            cell.wordLabel.backgroundColor = UIColor.white
        }
    }
    
    func resetUI() {
        /*var replacedUndexPath: [IndexPath] = []
        for index in GameHelper.shared.formedWordIndex {
            replacedUndexPath.append(IndexPath(row: index, section: 0))
        }
        wordCollectionView.reloadItems(at: replacedUndexPath)*/
        wordCollectionView.reloadData()
    }
    
}
