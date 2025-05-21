//
//  MazeGame.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI

class MazeGameScene: SKScene, ObservableObject {
    @Published var isWon = false
    
    private var mazeBackground: SKShapeNode!
    private var wallsNode: SKSpriteNode!
    private var playerNode: SKShapeNode!
    private var flagNode: SKSpriteNode! // Нода для флага
    private var trailNodes = [SKShapeNode]() // Массив для следов
    private var mazeCGImage: CGImage?
    private let playerRadius: CGFloat = 4
    let moveStep: CGFloat = 3
    private let startPoint = CGPoint(x: 10, y: 186)
    private let exitPoint = CGPoint(x: 186, y: 10)
    var onGameWon: (() -> Void)?
    
    // Настройки следа
    private let trailSquareSize: CGFloat = 6
    private let trailSpacing: CGFloat = 3
    private var lastTrailPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        mazeBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 196, height: 196))
        mazeBackground.fillColor = SKColor(hex: "DFA6F2")
        mazeBackground.strokeColor = .purple
        mazeBackground.lineWidth = 2
        mazeBackground.position = CGPoint(x: 0, y: 0)
        addChild(mazeBackground)
        
        // 2. Векторные стены
        wallsNode = SKSpriteNode(imageNamed: "maze")
        wallsNode.anchorPoint = CGPoint(x: 0, y: 0)
        wallsNode.position = CGPoint(x: 0, y: 0)
        wallsNode.size = CGSize(width: 196, height: 196)
        addChild(wallsNode)
        
        // 3. Флаг в правом нижнем углу
        flagNode = SKSpriteNode(imageNamed: "flag")
        flagNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        flagNode.position = exitPoint // Используем exitPoint
        flagNode.zPosition = 1
        flagNode.size = CGSize(width: 20, height: 20)
        addChild(flagNode)
        
        // 4. Получаем CGImage для проверки стен
        if let img = UIImage(named: "maze")?.cgImage {
            mazeCGImage = img
        }
        
        // 5. Создаем игрока
        playerNode = SKShapeNode(circleOfRadius: playerRadius)
        playerNode.fillColor = .white
        playerNode.strokeColor = .clear
        playerNode.position = startPoint
        playerNode.zPosition = 2
        addChild(playerNode)
        
        // 6. Белая рамка вокруг шарика
        let squareOutline = SKShapeNode(rectOf: CGSize(width: playerRadius*3, height: playerRadius*3))
        squareOutline.strokeColor = .purple
        squareOutline.lineWidth = 1
        squareOutline.fillColor = .purple
        squareOutline.zPosition = -1
        playerNode.addChild(squareOutline)
    }
    
    func resetGame() {
        playerNode.position = startPoint
        // Удаляем все следы
        isWon = false
        trailNodes.forEach { $0.removeFromParent() }
        trailNodes.removeAll()
        lastTrailPosition = nil
    }
    
    
    func movePlayer(dx: CGFloat, dy: CGFloat) {
        let newPos = CGPoint(x: playerNode.position.x + dx, y: playerNode.position.y + dy)
        
        // Проверка выхода за пределы лабиринта
        guard mazeBackground.frame.contains(newPos) else { return }
        
        // Проверка столкновения со стенами
        if isWall(at: newPos) { return }
        
        // Проверка по точкам вокруг игрока
        let offsets: [CGPoint] = [
            CGPoint(x: playerRadius, y: 0), CGPoint(x: -playerRadius, y: 0),
            CGPoint(x: 0, y: playerRadius), CGPoint(x: 0, y: -playerRadius),
            CGPoint(x: playerRadius * 0.7, y: playerRadius * 0.7),
            CGPoint(x: -playerRadius * 0.7, y: playerRadius * 0.7),
            CGPoint(x: playerRadius * 0.7, y: -playerRadius * 0.7),
            CGPoint(x: -playerRadius * 0.7, y: -playerRadius * 0.7)
        ]
        
        for offset in offsets {
            if isWall(at: CGPoint(x: newPos.x + offset.x, y: newPos.y + offset.y)) {
                return
            }
        }
        
        // Обновляем позицию игрока
        playerNode.position = newPos
        
        // Добавляем след
        addTrail(at: newPos)
        
        // Проверка достижения флага
        if playerNode.position.distance(to: flagNode.position) < 15 {
            isWon = true
            print("is won \(isWon)")
            onGameWon?()
        }
    }
    
    private func addTrail(at position: CGPoint) {
        // Проверяем расстояние от последней точки следа
        if let lastPos = lastTrailPosition, position.distance(to: lastPos) < trailSpacing {
            return
        }
        
        // Создаем новый квадратик следа
        let trailDot = SKShapeNode(rectOf: CGSize(width: playerRadius*3, height: playerRadius*3))
        trailDot.position = position
        trailDot.fillColor = .purple
        trailDot.strokeColor = .clear
        trailDot.zPosition = 0 // Между фоном и игроком
        
        addChild(trailDot)
        trailNodes.append(trailDot)
        lastTrailPosition = position
    }
    
    private func isWall(at point: CGPoint) -> Bool {
        guard let mazeCGImage = mazeCGImage else { return false }
        
        let scaleX = CGFloat(mazeCGImage.width) / wallsNode.size.width
        let scaleY = CGFloat(mazeCGImage.height) / wallsNode.size.height
        
        let imgX = Int(point.x * scaleX)
        let imgY = Int((wallsNode.size.height - point.y) * scaleY)
        
        guard imgX >= 0, imgX < mazeCGImage.width, imgY >= 0, imgY < mazeCGImage.height else {
            return true
        }
        
        guard let dataProvider = mazeCGImage.dataProvider,
              let pixelData = dataProvider.data,
              let data = CFDataGetBytePtr(pixelData) else {
            return true
        }
        
        let bytesPerPixel = mazeCGImage.bitsPerPixel / 8
        let bytesPerRow = mazeCGImage.bytesPerRow
        let pixelIndex = bytesPerRow * imgY + imgX * bytesPerPixel
        
        let totalBytes = CFDataGetLength(pixelData)
        guard pixelIndex >= 0, pixelIndex + 2 < totalBytes else {
            return true
        }
        
        let r = CGFloat(data[pixelIndex]) / 255.0
        let g = CGFloat(data[pixelIndex + 1]) / 255.0
        let b = CGFloat(data[pixelIndex + 2]) / 255.0
        
        // Цвет фона #DFA6F2 в RGB: (223, 166, 242)
        let isBackground = (r >= 0.87 && r <= 0.88) &&  // 223/255 ≈ 0.8745
                           (g >= 0.65 && g <= 0.66) &&  // 166/255 ≈ 0.6509
                           (b >= 0.94 && b <= 0.96)     // 242/255 ≈ 0.9490
        let playerColor = (r == 0.0 && g == 0.0 && b == 0.0)
        print("Color at \(point): R:\(r) G:\(g) B:\(b)")
        return !isBackground && !playerColor
    }
    
    
    private func isWall1(at point: CGPoint) -> Bool {
        guard let mazeCGImage = mazeCGImage else { return false }
        
        let scaleX = CGFloat(mazeCGImage.width) / wallsNode.size.width
        let scaleY = CGFloat(mazeCGImage.height) / wallsNode.size.height
        
        let imgX = Int(point.x * scaleX)
        let imgY = Int((wallsNode.size.height - point.y) * scaleY)
        
        guard imgX >= 0, imgX < mazeCGImage.width, imgY >= 0, imgY < mazeCGImage.height else {
            return true
        }
        
        guard let dataProvider = mazeCGImage.dataProvider,
              let pixelData = dataProvider.data,
              let data = CFDataGetBytePtr(pixelData) else {
            return true
        }
        
        let bytesPerPixel = mazeCGImage.bitsPerPixel / 8
        let bytesPerRow = mazeCGImage.bytesPerRow
        let pixelIndex = bytesPerRow * imgY + imgX * bytesPerPixel
        
        let totalBytes = CFDataGetLength(pixelData)
        guard pixelIndex >= 0, pixelIndex + 3 < totalBytes else {
            return true
        }
        
        let r = CGFloat(data[pixelIndex]) / 255.0
        let g = CGFloat(data[pixelIndex + 1]) / 255.0
        let b = CGFloat(data[pixelIndex + 2]) / 255.0
        let a = bytesPerPixel > 3 ? CGFloat(data[pixelIndex + 3]) / 255.0 : 1.0
        
        // Проверка на прозрачность (если есть альфа-канал)
        if a < 0.9 {
            return false
        }

        // Более широкие диапазоны для цветов стен
        let isDarkPurple = (r < 0.35) && (g < 0.2) && (b > 0.25) && (b < 0.65)
        let isMediumPurple = (r > 0.3) && (r < 0.6) && (g > 0.1) && (g < 0.4) && (b > 0.3) && (b < 0.7)
        
        let isWall = isDarkPurple || isMediumPurple
        if isWall {
            print("Wall detected at \(point) - color: \(r), \(g), \(b), \(a)")
        }
        return isWall

        return isDarkPurple || isMediumPurple
    }
}

// Расширение для вычисления расстояния между точками
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

