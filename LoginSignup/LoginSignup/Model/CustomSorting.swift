//
//  CustomSorting.swift
//  LoginSignup
//
//  Created by Vetaliy Poltavets on 3/20/18.
//  Copyright © 2018 vpoltave. All rights reserved.
//

import Foundation

struct SortManager {
    
    func customSort(_ c1: Character, _ c2: Character) -> Bool {
        if determineSymboly(c1, c2) {
            return c1 < c2 ? true : false
        }
        return c1 > c2 ? true : false
    }
    
    private func determineSymboly(_ c1: Character, _ c2: Character) -> Bool { // _ c1: Character, _ c2: Character
        let letters = CharacterSet.letters
        var letterCount = 0
        
        for u in c1.unicodeScalars {
            if letters.contains(u) {
                letterCount += 1
            }
        }
        for u in c2.unicodeScalars {
            if letters.contains(u) {
                letterCount += 1
            }
        }
        return (letterCount == 0 || letterCount == 2) ? true : false
    }
    
    
}
