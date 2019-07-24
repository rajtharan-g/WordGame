//
//  GameHelper.swift
//  WordGame
//
//  Created by Rajtharan G on 24/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseManagerDelegate: class {
    func reloadCollectionView(words: [String])
}

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    weak var delegate: FirebaseManagerDelegate?
    
    func listenToFirebaseDB() {
        ref = Database.database().reference()
        refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let arrayOfWords = snapshot.value as! [String]
            self.delegate?.reloadCollectionView(words: arrayOfWords)
        })
    }
    
}
