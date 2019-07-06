//
//  GameHelper.swift
//  WordGame
//
//  Created by Rajtharan G on 06/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

protocol GameHelperDelegate {
    func updateSelectedWord(index: Int)
    func updateUnSelectedWord(index: Int)
    func resetUI()
}

class GameHelper: NSObject {
    
    static let shared = GameHelper()
    
    var delegate: GameHelperDelegate?
    var fullWordArray: [String] = []
    var formedWordArray: [String] = []
    var formedWordIndex: [Int] = []
    
    func loadNewGame() -> [String] {
        fullWordArray = randomizeAvailableLetters(tileCount: 30)
        return fullWordArray
    }
    
    func onTouchStarted() {
        formedWordArray.removeAll()
        formedWordIndex.removeAll()
    }
    
    func onTouchEnded() {
        for index in formedWordIndex {
            formedWordArray.append(fullWordArray[index])
        }
        let isWordCorrect = GameHelper.shared.evaluate(word: formedWordArray)
        if isWordCorrect {
            for index in formedWordIndex {
                fullWordArray[index] = ""
            }
            replaceNewWords()
        } else {
            print("Wrong word")
        }
        delegate?.resetUI()
    }
    
    func replaceNewWords() {
        if let lastEmptyIndex = self.fullWordArray.lastIndex(of: "") {
            if lastEmptyIndex - 5 >= 0 {
                if !fullWordArray[lastEmptyIndex - 5].isEmpty {
                    fullWordArray[lastEmptyIndex] = fullWordArray[lastEmptyIndex - 5]
                    fullWordArray[lastEmptyIndex - 5] = ""
                } else {
                    var index = lastEmptyIndex - 5
                    while index >= 0 {
                        if !fullWordArray[index].isEmpty {
                            fullWordArray[lastEmptyIndex] = fullWordArray[index]
                            fullWordArray[index] = ""
                            break
                        }
                        index = index - 5
                    }
                    if fullWordArray[lastEmptyIndex].isEmpty {
                        fullWordArray[lastEmptyIndex] = GameHelper.shared.generateNewTiles(tileCount: 1).first ?? "*"
                    }
                }
            } else {
                fullWordArray[lastEmptyIndex] = GameHelper.shared.generateNewTiles(tileCount: 1).first ?? "*"
            }
            replaceNewWords()
        }
    }
    
    func getTopWordfrom(index: Int) -> Int? {
        var index = index - 5
        while index > 0 {
            let topWord = fullWordArray[index]
            if !topWord.isEmpty {
                return index
            }
            index = index - 5
        }
        return nil
    }
    
    func addTouchIndex(x: CGFloat, y: CGFloat, collectionViewBounds: CGRect) {
        let row = (y / (collectionViewBounds.height / 6))
        let col = (x / (collectionViewBounds.width / 5))
        let intRow = Int(row)
        let intCol = Int(col)
        let diffRow = row - CGFloat(intRow)
        let diffCol = col - CGFloat(intCol)
        if diffRow < 0.85 && diffCol < 0.85 && diffRow > 0.15 && diffCol > 0.15 {
            let index = (Int(row) * 5) + Int(col)
            if !formedWordIndex.contains(index) {
                formedWordIndex.append(index)
                delegate?.updateSelectedWord(index: index)
            } else {
                if formedWordIndex.last != index {
                    delegate?.updateUnSelectedWord(index: formedWordIndex.last!)
                    formedWordIndex.removeLast()
                }
            }
        }
    }
    
    func evaluate(word: [String]) -> Bool {
        if word.count > 1 {
            return true
        }
        return false
    }
    
    func generateNewTiles(tileCount: Int) -> [String] {
        return randomizeAvailableLetters(tileCount: tileCount)
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
