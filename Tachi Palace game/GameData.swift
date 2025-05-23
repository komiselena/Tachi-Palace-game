//
//  GameData.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import Foundation
import SwiftUI

class GameData: ObservableObject {
    
    @Published var boughtSkinId: [Int] = [1]
    @Published var boughtBackgroundId: [Int] = [1]

    
    @Published var coins: Int {
        didSet {
            UserDefaults.standard.set(coins, forKey: "coins")
        }
    }
    
    init() {
        let savedCoins = UserDefaults.standard.integer(forKey: "coins")
        if savedCoins == 0 {
            self.coins = 0
            UserDefaults.standard.set(0, forKey: "coins")
        } else {
            self.coins = savedCoins
        }
    }

    
    func addCoins(_ amount: Int){
        coins += amount
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        } else {
            return false
        }
    }
}
