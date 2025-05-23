//
//  GameViewModel.swift
//  Potawatomi tribe game
//
//  Created by Mac on 13.05.2025.
//

import Foundation


class GameViewModel: ObservableObject {
    @Published var backgroundImage: String = "bg"
    @Published var skin: String = "skin1"
    
    @Published var isGameOver: Bool = false
    @Published var restartGame: Bool = false
    
    @Published var played10Times: Bool = false
    @Published var collected100Coins: Bool = false
    @Published var unlockedAllBattleFields: Bool = false
    @Published var accumulated1000Coins: Bool = false
    @Published var unlockedAllKings: Bool = false

    
    @Published var hidePlayed10Times = false
    @Published var hideCcollected100Coins = false
    @Published var hideUnlockedAllBattleFields = false
    @Published var hideUnlockedAllKings = false
    @Published var hideAccumulated = false

}
