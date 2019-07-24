//
//  FirebaseManager.swift
//  WordGame
//
//  Created by Rajtharan G on 24/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseManagerDelegate: class {
    func reloadCollectionView(words: [String]?)
}

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    weak var delegate: FirebaseManagerDelegate?
    var totalTileSize: UInt = 25
    
    func listenToFirebaseDB(lastElementKey: String? = nil) {
        ref = Database.database().reference()
        refHandle = ref.queryLimited(toLast: totalTileSize).observe(DataEventType.value, with: { (snapshot) in
            self.handleResponse(snapshot: snapshot)
        })
    }
    
    func handleResponse(snapshot: DataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: Any] {
            var arrayOfWords = snapshotValue.values.map({$0}) as! [[String: Any]]
            arrayOfWords = arrayOfWords.sorted(by: {($0["timestamp"] as! Double) < ($1["timestamp"] as! Double)})
            let words = arrayOfWords.compactMap({$0["word"]}) as! [String]
            self.delegate?.reloadCollectionView(words: words)
        } else {
            self.delegate?.reloadCollectionView(words: nil)
        }
    }
    
    func updateWordToDB(words: [String]) {
        ref = Database.database().reference()
        for word in words {
            ref.childByAutoId().setValue(["word": word, "timestamp": ServerValue.timestamp()])
        }
    }
    
    func randomizeAvailableLetters(tileCount: Int) -> Array<String> {
        let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var availableTiles = [String]()
        for _ in 0..<tileCount {
            let rand = Int(arc4random_uniform(26))
            availableTiles.append(alphabet[rand])
        }
        return availableTiles
    }

}
