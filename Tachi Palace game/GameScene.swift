//
//  GameScene.swift
//  Game
//
//  Created by Mac on 25.04.2025.
//

import SwiftUI
import SpriteKit
import GameplayKit
import CoreImage

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundTiles = [SKSpriteNode]()
    let tileSize = CGSize(width: 1024, height: 1024) // Размер одного тайла фона
    var lastCameraPosition = CGPoint.zero
    var loadedTilePositions = Set<CGPoint>() 
    var backgroundTexture: SKTexture!
    
    var gameViewModel: GameViewModel?
    var gameData: GameData?

    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    
    var healthBarBackground: SKSpriteNode!
    var healthBar: SKSpriteNode!
    var health: CGFloat = 1.0 {
        didSet {
            updateHealthBar()
        }
    }

    var lastPlayerPositions = [CGPoint]()
    let maxPositionHistory = 10
    var bombs = [SKSpriteNode]()
    var arrows = [SKSpriteNode]()

    var lastUpdateTime: TimeInterval = 0

    // Уменьшаем частоту появления врагов
    let enemySpawnInterval: TimeInterval = 2.4 // Было 2.5
    let maxEnemiesOnScreen = 3 // Максимальное количество врагов на экране

    // Увеличиваем скорость врагов
    let enemySpeedMultiplier: CGFloat = 2.5 // Было 1.3

    
    let minEnemyDistance: CGFloat = 800  // Минимальная дистанция появления
    let maxEnemyDistance: CGFloat = 1200 // Максимальная дистанция
    let arrowSpawnInterval: TimeInterval = 4.0 // Стрелы тоже реже

    
    var enemySpawnTimer: TimeInterval = 0
    var arrowSpawnTimer: TimeInterval = 0

    
    // Настройки движения и камеры
    let cameraNode = SKCameraNode()
    let playerSpeed: CGFloat = 85
    var playerVelocity: CGVector = .zero
    
    // Для бесконечного поля
    var backgroundLayers = [SKSpriteNode]()
    let backgroundSize = CGSize(width: 2000, height: 2000)
    
    // Управление поворотом
    var moveUpPressed = false
    var moveDownPressed = false
    var moveLeftPressed = false
    var moveRightPressed = false
    var rotationTime: TimeInterval = 0
    let maxRotationSpeed: CGFloat = 0.15
    let minRotationSpeed: CGFloat = 0.05
    var leftButtonPressed = false
    var rightButtonPressed = false
    var forwardButtonPressed = false
    var backwardButtonPressed = false

    let rubinSpawnInterval: TimeInterval = 10.0 // Интервал появления рубинов
    var rubinSpawnTimer: TimeInterval = 0
    let rubinSize: CGFloat = 3.0
    let rubinLifetime: TimeInterval = 40.0
    var currentRubin: SKSpriteNode?

    let rotationSpeed: CGFloat = 0.007 // Скорость поворота
    
    // Угол поворота игрока (0 - смотрит вправо, π/2 - вверх, π - влево, 3π/2 - вниз)
    var playerRotation: CGFloat = 0 {
        didSet {
            // Ограничиваем угол поворота от 0 до 2π
            if playerRotation < 0 {
                playerRotation += 2 * .pi
            } else if playerRotation >= 2 * .pi {
                playerRotation -= 2 * .pi
            }
        }
    }

    
    let coinSpawnInterval: TimeInterval = 4.0
    var coinSpawnTimer: TimeInterval = 0
    let coinSize: CGFloat = 3.0
    let coinLifetime: TimeInterval = 30.0
    var currentCoin: SKSpriteNode?
    var coinIndicator: SKSpriteNode!

    var coinDisplay: SKShapeNode!
    var coinLabel: SKLabelNode!


    override func didMove(to view: SKView) {
        backgroundColor = .clear
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        backgroundTexture = SKTexture(imageNamed: gameViewModel?.backgroundImage ?? "bg")
        backgroundTexture.filteringMode = .linear
        
        setupInfiniteSeamlessBackground()
        physicsWorld.speed = 1.0
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(
            x: -size.width * 2,
            y: -size.height * 2,
            width: size.width * 5,
            height: size.height * 5
        ))
        
        addChild(cameraNode)
        camera = cameraNode
        
        setupCoinDisplay()
        setupHealthBar()

        setupPlayer()
        startSpawningEnemies()
        setupCoinIndicator()
        startSpawningRubins() // Запускаем спавн рубинов вместо птиц
    }


    func setupInfiniteSeamlessBackground() {
        // Удаляем старые тайлы если есть
        backgroundTiles.forEach { $0.removeFromParent() }
        backgroundTiles.removeAll()
        loadedTilePositions.removeAll()
        
        // Создаем начальные тайлы
        updateSeamlessBackground()
    }

    func updateSeamlessBackground() {
        let cameraTileX = Int(round(cameraNode.position.x / tileSize.width))
        let cameraTileY = Int(round(cameraNode.position.y / tileSize.height))
        
        // Определяем область 3x3 тайла вокруг камеры
        let loadRadius = 1
        var tilesToKeep = Set<CGPoint>()
        
        for x in (cameraTileX - loadRadius)...(cameraTileX + loadRadius) {
            for y in (cameraTileY - loadRadius)...(cameraTileY + loadRadius) {
                let tilePos = CGPoint(x: x, y: y)
                tilesToKeep.insert(tilePos)
                
                if !loadedTilePositions.contains(tilePos) {
                    addSeamlessTile(at: tilePos)
                    loadedTilePositions.insert(tilePos)
                }
            }
        }
        
        // Удаляем тайлы вне области видимости
        var tilesToRemove = [SKSpriteNode]()
        for tile in backgroundTiles {
            let tileX = Int(round(tile.position.x / tileSize.width))
            let tileY = Int(round(tile.position.y / tileSize.height))
            let tilePos = CGPoint(x: tileX, y: tileY)
            
            if !tilesToKeep.contains(tilePos) {
                tilesToRemove.append(tile)
                loadedTilePositions.remove(tilePos)
            }
        }
        
        tilesToRemove.forEach { $0.removeFromParent() }
        backgroundTiles.removeAll(where: { tilesToRemove.contains($0) })
    }

    func setupCoinDisplay() {
        // Создаем фиолетовый фон (прямоугольник с закругленными углами)
        let capsuleWidth: CGFloat = 100  // Немного уменьшил ширину
        let capsuleHeight: CGFloat = 40
        let capsule = SKShapeNode(rect: CGRect(x: -capsuleWidth/2, y: -capsuleHeight/2,
                                             width: capsuleWidth, height: capsuleHeight),
                             cornerRadius: capsuleHeight/2)
        capsule.fillColor = UIColor(hex: "#7B5A08")
        capsule.strokeColor = .clear
        
        // Позиция в правом верхнем углу
        capsule.position = CGPoint(x: size.width/2 - 70, y: size.height/2.5)
        capsule.zPosition = 1000
        cameraNode.addChild(capsule)
        coinDisplay = capsule
        
        // Добавляем иконку монеты (ближе к тексту)
        let coinIcon = SKSpriteNode(imageNamed: "coin")
        coinIcon.size = CGSize(width: 25, height: 25)
        coinIcon.position = CGPoint(x: -30, y: 0) // Сдвинул ближе к центру (было -40)
        coinIcon.zPosition = 1001
        capsule.addChild(coinIcon)
        
        // Добавляем счетчик монет (ближе к иконке)
        coinLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        coinLabel.fontSize = 16
        coinLabel.fontColor = .white
        coinLabel.text = "\(gameData?.coins ?? 0)"
        coinLabel.horizontalAlignmentMode = .right
        coinLabel.position = CGPoint(x: 25, y: -8) // Сдвинул ближе к иконке (было 35)
        coinLabel.zPosition = 1001
        capsule.addChild(coinLabel)
    }
    
    func setupHealthBar() {
        // Создаем контейнер для health bar
        let healthContainer = SKSpriteNode(color: .clear, size: CGSize(width: 220, height: 40))
        healthContainer.anchorPoint = CGPoint(x: 0, y: 0.5) // Якорь слева по центру
        healthContainer.position = CGPoint(x: -size.width/3.5, y: size.height/2 - 50)
        healthContainer.zPosition = 1000
        cameraNode.addChild(healthContainer)
        
        // Иконка сердца (теперь слева)
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.size = CGSize(width: 25, height: 25)
        heart.position = CGPoint(x: 15, y: 0) // Справа от якоря
        heart.zPosition = 3
        healthContainer.addChild(heart)
        
        // Фон health bar (с отступом от сердца)
        healthBarBackground = SKSpriteNode(color: UIColor(white: 0.4, alpha: 0.6), size: CGSize(width: 180, height: 20))
        healthBarBackground.position = CGPoint(x: 120 + heart.size.width/2, y: 0)
        healthBarBackground.zPosition = 1
        healthBarBackground.cornerRadius = 10
        healthContainer.addChild(healthBarBackground)

        // Сам health bar
        healthBar = SKSpriteNode(color: UIColor.red, size: CGSize(width: 175, height: 15))
        healthBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthBar.position = CGPoint(x: -healthBarBackground.size.width/2 + 2.5, y: 0)
        healthBar.zPosition = 2
        healthBar.cornerRadius = 7
        healthBarBackground.addChild(healthBar)
        
        // Белая рамка
        let border = SKShapeNode(rect: CGRect(x: -healthBarBackground.size.width/2,
                                             y: -healthBarBackground.size.height/2,
                                             width: healthBarBackground.size.width,
                                             height: healthBarBackground.size.height),
                                cornerRadius: 10)
        border.strokeColor = .white
        border.lineWidth = 1.5
        border.zPosition = 4
        healthBarBackground.addChild(border)
    }
    
    func updateHealthBar() {
        let maxWidth: CGFloat = 175
        let newWidth = max(0, min(maxWidth, maxWidth * health)) // Гарантируем, что не выйдем за пределы
        
        // Сначала сбрасываем цвет
        healthBar.removeAllActions()
        healthBar.color = .red
        
        // Затем анимируем изменение размера
        healthBar.run(SKAction.resize(toWidth: newWidth, duration: 0.2))
    }

    func addSeamlessTile(at tilePos: CGPoint) {
        let tile = SKSpriteNode(texture: backgroundTexture)
        tile.name = "backgroundTile"
        tile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tile.position = CGPoint(
            x: tilePos.x * tileSize.width,
            y: tilePos.y * tileSize.height
        )
        tile.size = tileSize
        tile.zPosition = -100
        
        // Ключевое изменение - делаем текстуру немного больше тайла
        let textureScale: CGFloat = 1.02 // 2% увеличение
        let textureRect = CGRect(
            x: 0.5 - 0.5/textureScale,
            y: 0.5 - 0.5/textureScale,
            width: 1/textureScale,
            height: 1/textureScale
        )
        tile.texture = SKTexture(rect: textureRect, in: backgroundTexture)
        
        addChild(tile)
        backgroundTiles.append(tile)
    }
    
    func setupCoinIndicator() {
        // Создаем белый прямоугольник
        coinIndicator = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 5))
        coinIndicator.zPosition = 100
        coinIndicator.alpha = 0.7 // Полупрозрачный
        coinIndicator.name = "coinIndicator"
        addChild(coinIndicator)
    }


    func spawnStaticCoin() {
        // Удаляем предыдущую монету, если она есть
        currentCoin?.removeFromParent()
        
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.name = "coin"
        coin.zPosition = 5
        coin.setScale(coinSize)
        
        // Физическое тело для точного определения столкновений
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width/2)
        coin.physicsBody?.categoryBitMask = PhysicsCategory.coin
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.player
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.isDynamic = false
        
        let angle = CGFloat.random(in: 0..<(.pi*2))
        let distance = size.width * 0.8
        let spawnPosition = CGPoint(
            x: cameraNode.position.x + cos(angle) * distance,
            y: cameraNode.position.y + sin(angle) * distance
        )
        
        coin.position = spawnPosition
        addChild(coin)
        
        // Анимация появления
        coin.alpha = 0
        coin.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.group([
                SKAction.fadeIn(withDuration: 0.5),
                SKAction.scale(to: coinSize, duration: 0.5)
            ])
        ]))
        
        currentCoin = coin
        
    }
    // Новый метод для удаления монеты
    func removeCoin(coin: SKSpriteNode) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        coin.run(fadeOut) {
            coin.removeFromParent()
            if self.currentCoin == coin {
                self.currentCoin = nil
            }
        }
    }


    func setupInfiniteBackground() {
        // Создаем 3 слоя фона для параллакс-эффекта
        for i in 0..<3 {
            let bg = SKSpriteNode(imageNamed: gameViewModel?.backgroundImage ?? "bg")
            bg.name = "background_\(i)"
            bg.texture?.filteringMode = .nearest

            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.position = CGPoint.zero
            bg.zPosition = CGFloat(-10 - i)
            bg.size = backgroundSize
            addChild(bg)
            backgroundLayers.append(bg)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Обновляем поворот
        if leftButtonPressed {
            playerRotation -= rotationSpeed
        }
        if rightButtonPressed {
            playerRotation += rotationSpeed
        }
        if forwardButtonPressed || backwardButtonPressed {
            let direction = forwardButtonPressed ? 1.0 : -1.0
            let velocity = CGVector(
                dx: sin(playerRotation) * playerSpeed * direction,
                dy: cos(playerRotation) * playerSpeed * direction
            )
            
            player.position.x += velocity.dx * CGFloat(1.0/60.0)
            player.position.y += velocity.dy * CGFloat(1.0/60.0)
        }
        
        var velocity = CGVector.zero
        
        if moveUpPressed {
            velocity.dy += playerSpeed
        }
        if moveDownPressed {
            velocity.dy -= playerSpeed
        }
        if moveLeftPressed {
            velocity.dx -= playerSpeed
            player.xScale = -abs(player.xScale) // Отражаем по горизонтали для движения влево
        }
        if moveRightPressed {
            velocity.dx += playerSpeed
            player.xScale = abs(player.xScale) // Возвращаем нормальный масштаб для движения вправо
        }
        
        // Нормализуем скорость, если нажато несколько кнопок
        let length = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
        if length > 0 {
            velocity.dx = velocity.dx / length * playerSpeed
            velocity.dy = velocity.dy / length * playerSpeed
        }
        
        player.position.x += velocity.dx * CGFloat(1.0/60.0)
        player.position.y += velocity.dy * CGFloat(1.0/60.0)

        
        // Применяем поворот к спрайту
        player.zRotation = -playerRotation


        lastPlayerPositions.insert(player.position, at: 0)
        if lastPlayerPositions.count > maxPositionHistory {
            lastPlayerPositions.removeLast()
        }
        let deltaTime = lastUpdateTime == 0 ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        enemySpawnTimer += 1.0 / 60.0
        arrowSpawnTimer += 1.0 / 60.0
        
        if enemySpawnTimer >= enemySpawnInterval {
            enemySpawnTimer = 0
            spawnSkull()
        }
        spawnbomb()

        updateplayerPosition(deltaTime: deltaTime)
        
        if let coin = currentCoin {
                   updateCoinIndicator(coinPosition: coin.position)
               } else {
                   coinIndicator.alpha = 0
               }
               
               // Спавн монет
               coinSpawnTimer += deltaTime
               if coinSpawnTimer >= coinSpawnInterval && currentCoin == nil {
                   coinSpawnTimer = 0
                   spawnStaticCoin()
               }
        
        // Спавн рубинов
        rubinSpawnTimer += deltaTime
        if rubinSpawnTimer >= rubinSpawnInterval && currentRubin == nil {
            rubinSpawnTimer = 0
            spawnRubin()
        }

        let cameraMovement = hypot(cameraNode.position.x - lastCameraPosition.x,
                                 cameraNode.position.y - lastCameraPosition.y)
        if cameraMovement > tileSize.width * 0.3 {
            updateSeamlessBackground()
            lastCameraPosition = cameraNode.position
        }
        
        updateRotation()
        updateplayerPosition()
        updateCameraAndBackground()
    }
    
    func updateRotation() {
        if leftButtonPressed || rightButtonPressed {
            rotationTime += 1.0 / 60.0
            let rotationSpeed = min(maxRotationSpeed, minRotationSpeed + CGFloat(rotationTime) * 0.02)
            
            if leftButtonPressed {
                playerRotation -= rotationSpeed
            }
            if rightButtonPressed {
                playerRotation += rotationSpeed
            }
        } else {
            rotationTime = 0
        }
    }


    func rotatePlayer(clockwise: Bool, start: Bool) {
        if clockwise {
            rightButtonPressed = start
        } else {
            leftButtonPressed = start
        }
    }
    
    func increaseHealth() {
        // Увеличиваем здоровье, но не больше 1.0
        health = min(health + 0.5, 1.0)
        
        // Анимация восстановления здоровья (зеленый цвет)
        healthBar.removeAllActions()
        healthBar.run(SKAction.sequence([
            SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2),
            SKAction.wait(forDuration: 0.3),
            SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.2)
        ]))
    }

    func addCoins(_ amount: Int) {
        gameData?.coins += amount
        coinLabel.text = "\(gameData?.coins ?? 0)"
        
        // Анимация получения монет
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        coinDisplay.run(SKAction.sequence([scaleUp, scaleDown]))
    }

    
    
    func movePlayer(forward: Bool, start: Bool) {
        forwardButtonPressed = forward && start
        backwardButtonPressed = !forward && start
    }

    
    func addBackgroundTile(at tilePos: CGPoint) {
        let texture = SKTexture(imageNamed: gameViewModel?.backgroundImage ?? "bg")
        texture.filteringMode = .linear // Для плавности
        
        let background = SKSpriteNode(texture: texture)
        background.name = "backgroundTile"
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(
            x: tilePos.x * tileSize.width,
            y: tilePos.y * tileSize.height
        )
        background.size = tileSize
        background.zPosition = -100
        
        // Добавляем небольшое смещение текстуры для разных тайлов
        let offsetX = CGFloat(Int(tilePos.x) % 2) * 0.5
        let offsetY = CGFloat(Int(tilePos.y) % 2) * 0.5
        
        // Создаем новую текстуру с учетом смещения
        let textureRect = CGRect(x: offsetX, y: offsetY, width: 0.5, height: 0.5)
        background.texture = SKTexture(rect: textureRect, in: texture)
        
        addChild(background)
        backgroundTiles.append(background)
    }
    


    func updateplayerPosition(deltaTime: TimeInterval) {
        guard player != nil else { return }
        
        let direction = CGVector(dx: sin(playerRotation), dy: cos(playerRotation))
        playerVelocity = CGVector(dx: direction.dx * playerSpeed,
                                dy: direction.dy * playerSpeed)
        
        // Используем реальный deltaTime
        player.position.x += playerVelocity.dx * CGFloat(deltaTime)
        player.position.y += playerVelocity.dy * CGFloat(deltaTime)
        
        player.zRotation = -playerRotation
    }
    
    func movePlayer(direction: Direction, start: Bool) {
        switch direction {
        case .up:
            moveUpPressed = start
        case .down:
            moveDownPressed = start
        case .left:
            moveLeftPressed = start
        case .right:
            moveRightPressed = start
        }
    }

    enum Direction {
        case up, down, left, right
    }

    
    // Метод для обновления индикатора
    func updateCoinIndicator(coinPosition: CGPoint) {
        let cameraRect = CGRect(
            x: cameraNode.position.x - size.width/2,
            y: cameraNode.position.y - size.height/2,
            width: size.width,
            height: size.height
        )
        
        // Если монета на экране - скрываем индикатор
        if cameraRect.contains(coinPosition) {
            coinIndicator.alpha = 0
            return
        }
        
        // Показываем индикатор
        coinIndicator.alpha = 0.7
        
        // Вычисляем направление к монете
        let direction = CGPoint(
            x: coinPosition.x - cameraNode.position.x,
            y: coinPosition.y - cameraNode.position.y
        )
        let angle = atan2(direction.y, direction.x)
        
        // Позиция на краю экрана
        let edgeMargin: CGFloat = 30
        let maxDistance = min(size.width/2, size.height/2) - edgeMargin
        let indicatorPosition = CGPoint(
            x: cameraNode.position.x + cos(angle) * maxDistance,
            y: cameraNode.position.y + sin(angle) * maxDistance
        )
        
        // Обновляем позицию и поворот
        coinIndicator.position = indicatorPosition
        coinIndicator.zRotation = angle
        
        
        let baseColor = UIColor.white
        coinIndicator.color = baseColor
    }
        
    func updateplayerPosition() {
        guard player != nil else { return }
        
        // Рассчитываем скорость на основе текущего угла
        let direction = CGVector(dx: sin(playerRotation), dy: cos(playerRotation))
        playerVelocity = CGVector(dx: direction.dx * playerSpeed,
                                dy: direction.dy * playerSpeed)
        
        // Применяем скорость к позиции орла
        let deltaTime = 1.0 / 60.0
        player.position.x += playerVelocity.dx * CGFloat(deltaTime)
        player.position.y += playerVelocity.dy * CGFloat(deltaTime)
        
        // Поворачиваем орла в направлении движения
        player.zRotation = -playerRotation
    }
    
    func updateCameraAndBackground() {
        // Плавное движение камеры за орлом
        cameraNode.position = player.position
        
        // Параллакс-эффект для фона
        for (index, bg) in backgroundLayers.enumerated() {
            let parallaxFactor = CGFloat(index + 1) * 0.3
            bg.position = CGPoint(
                x: player.position.x * parallaxFactor,
                y: player.position.y * parallaxFactor
            )
        }
    }
    func setupPlayer() {
        let playerImageName = gameViewModel?.skin ?? "skin1"
        player = SKSpriteNode(imageNamed: playerImageName)
        player.name = playerImageName
        
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.zPosition = 10
        player.setScale(1.7)
        
        // Начальный поворот - смотрит вправо
        player.zRotation = 0
        playerRotation = 0
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.bomb | PhysicsCategory.rubin | PhysicsCategory.coin
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.isDynamic = true
        
        addChild(player)
    }
        
    var lastHitTime: TimeInterval = 0
    let hitCooldown: TimeInterval = 0.5 // Защита от быстрых последовательных ударов

    func reduceHealth() {
            let now = CACurrentMediaTime()
            guard now - lastHitTime > hitCooldown else { return }
            lastHitTime = now
            
            health -= 0.05 // Уменьшаем здоровье на 5%
            
            // Эффект "мигания" при ударе
            let flashRed = SKAction.run {
                self.healthBar.color = .red
                self.healthBar.colorBlendFactor = 1.0
            }
            let restoreColor = SKAction.run {
                self.updateHealthBar() // Восстанавливаем правильный цвет
            }
            
            healthBar.run(SKAction.sequence([
                flashRed,
                SKAction.wait(forDuration: 0.1),
                restoreColor
            ]))
            
            if health <= 0 {
                gameOver()
            }
        }

    func gameOver() {
        guard gameViewModel?.isGameOver == false else { return }
        player.removeFromParent()
        DispatchQueue.main.async {
            self.gameViewModel?.isGameOver = true

        }
        health = 1
        score = 0

    }
    

    func startSpawningEnemies() {
        let spawn = SKAction.run {
            self.spawnArrow()

            self.spawnbomb()
        }
        let wait = SKAction.wait(forDuration: Double.random(in: 2.0...5.0))
        let sequence = SKAction.sequence([spawn, wait])
        run(SKAction.repeatForever(sequence))
    }
    
    func updatebombs() {
        for bird in bombs {
            // Дополнительная логика для птиц
            // Например, можно добавить случайные маневры
            if Int.random(in: 0...100) < 5 {
                let randomAngle = CGFloat.random(in: -0.3...0.3)
                let impulse = CGVector(dx: CGFloat.random(in: -50...50),
                                  dy: CGFloat.random(in: -50...50))
                bird.physicsBody?.applyImpulse(impulse)
            }
        }
    }
    
    func startSpawningRubins() {
        let spawn = SKAction.run { [weak self] in
            self?.spawnRubin()
        }
        let wait = SKAction.wait(forDuration: Double.random(in: rubinSpawnInterval-1...rubinSpawnInterval+1))
        let sequence = SKAction.sequence([spawn, wait])
        run(SKAction.repeatForever(sequence), withKey: "rubinSpawning")
    }


    func spawnbomb() {
        let currentEnemies = children.filter { $0.name == "bomb" }.count
        if currentEnemies >= maxEnemiesOnScreen {
            return
        }
        
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.name = "bomb"
        bomb.zPosition = 5
        bomb.setScale(1.7)
        
        bomb.physicsBody = SKPhysicsBody(texture: bomb.texture!, size: bomb.size)
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.bomb
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.player
        bomb.physicsBody?.collisionBitMask = 0
        bomb.physicsBody?.isDynamic = false // Бомбы не двигаются
        
        // Появление на пути игрока с небольшим отклонением
        let playerDirection = CGVector(dx: sin(playerRotation), dy: cos(playerRotation))
        let distance = CGFloat.random(in: 200...400) // Дистанция перед игроком
        let deviation = CGFloat.random(in: -100...100) // Отклонение в стороны
        
        bomb.position = CGPoint(
            x: player.position.x + playerDirection.dx * distance + playerDirection.dy * deviation,
            y: player.position.y + playerDirection.dy * distance - playerDirection.dx * deviation
        )
        
        // Анимация внезапного появления
        bomb.alpha = 0
        bomb.setScale(0.1)
        let appearAction = SKAction.group([
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.scale(to: 1.7, duration: 0.2)
        ])
        
        // Исчезание через 2-4 секунды
        let disappearAction = SKAction.sequence([
            SKAction.wait(forDuration: Double.random(in: 2...4)),
            SKAction.group([
                SKAction.fadeOut(withDuration: 0.3),
                SKAction.scale(to: 0.1, duration: 0.3)
            ]),
            SKAction.removeFromParent()
        ])
        
        addChild(bomb)
        bomb.run(SKAction.sequence([appearAction, disappearAction]))
    }
    
    func spawnRubin() {
        // Удаляем предыдущий рубин, если он есть
        currentRubin?.removeFromParent()
        
        let rubin = SKSpriteNode(imageNamed: "rubin")
        rubin.name = "rubin"
        rubin.zPosition = 5
        rubin.setScale(rubinSize)
        
        // Физическое тело для точного определения столкновений
        rubin.physicsBody = SKPhysicsBody(circleOfRadius: rubin.size.width/2)
        rubin.physicsBody?.categoryBitMask = PhysicsCategory.rubin
        rubin.physicsBody?.contactTestBitMask = PhysicsCategory.player
        rubin.physicsBody?.collisionBitMask = 0
        rubin.physicsBody?.isDynamic = false
        
        // Позиция в случайном месте на карте
        let angle = CGFloat.random(in: 0..<(.pi*2))
        let distance = size.width * 0.8
        let spawnPosition = CGPoint(
            x: cameraNode.position.x + cos(angle) * distance,
            y: cameraNode.position.y + sin(angle) * distance
        )
        
        rubin.position = spawnPosition
        addChild(rubin)
        
        // Анимация появления
        rubin.alpha = 0
        rubin.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.group([
                SKAction.fadeIn(withDuration: 0.5),
                SKAction.scale(to: rubinSize, duration: 0.5)
            ])
        ]))
        
        // Удаление через время жизни
        rubin.run(SKAction.sequence([
            SKAction.wait(forDuration: rubinLifetime),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ])) { [weak self] in
            if self?.currentRubin == rubin {
                self?.currentRubin = nil
            }
        }
        
        currentRubin = rubin
    }


    func spawnArrow() {
        let arrow = SKSpriteNode(imageNamed: "bomb")
        arrow.zPosition = 5
        arrow.name = "bomb"
        
        // Физическое тело
        arrow.physicsBody = SKPhysicsBody(texture: arrow.texture!, size: arrow.size)
        arrow.physicsBody?.categoryBitMask = PhysicsCategory.bomb
        arrow.physicsBody?.contactTestBitMask = PhysicsCategory.player
        arrow.physicsBody?.collisionBitMask = 0
        arrow.physicsBody?.isDynamic = true
        
        // Стартовая позиция - случайная точка в радиусе 1000px от орла
        let angle = CGFloat.random(in: 0..<(.pi * 2))
        let distance: CGFloat = 1000
        let startPosition = CGPoint(
            x: player.position.x + cos(angle) * distance,
            y: player.position.y + sin(angle) * distance
        )
        
        arrow.position = startPosition
        
        // Направление не точно в орла, а с небольшим отклонением
        let deviation = CGFloat.random(in: -0.2...0.2)
        let targetPosition = CGPoint(
            x: player.position.x + cos(angle + .pi + deviation) * 200,
            y: player.position.y + sin(angle + .pi + deviation) * 200
        )
        
        // Поворот стрелы
        let dx = targetPosition.x - startPosition.x
        let dy = targetPosition.y - startPosition.y
        arrow.zRotation = atan2(dy, dx)
        
        addChild(arrow)
        
        // Движение стрелы
        let speed: CGFloat = 400
        let distanceToTarget = hypot(dx, dy)
        let duration = TimeInterval(distanceToTarget / speed)
        
        let moveAction = SKAction.move(to: targetPosition, duration: duration)
        let removeAction = SKAction.removeFromParent()
        arrow.run(SKAction.sequence([moveAction, removeAction]))
    }

    func spawnSkull() {
        // Проверяем количество уже существующих врагов
        let currentEnemies = children.filter { $0.name == "boom" }.count
        if currentEnemies >= maxEnemiesOnScreen {
            return
        }
        
        let bird = SKSpriteNode(imageNamed: "boom")
        bird.name = "boom"
        bird.zPosition = 5
        bird.setScale(1.7)
        
        bird.physicsBody = SKPhysicsBody(texture: bird.texture!, size: bird.size)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.boom
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.player
        bird.physicsBody?.collisionBitMask = 0
        bird.physicsBody?.isDynamic = true
        
        // Выбираем сторону появления (лево или право)
        let side: CGFloat = Bool.random() ? 1 : -1
        
        // Стартовая позиция - сбоку от орла на некотором расстоянии
        let baseAngle = atan2(playerVelocity.dy, playerVelocity.dx)
        let sideAngle = baseAngle + (side * .pi/2) // 90 градусов влево или вправо
        
        // Расстояние появления
        let distance = CGFloat.random(in: minEnemyDistance...maxEnemyDistance)
        
        bird.position = CGPoint(
            x: player.position.x + cos(sideAngle) * distance,
            y: player.position.y + sin(sideAngle) * distance
        )
        
        // Начальный поворот
        bird.zRotation = baseAngle - .pi/2
        
        addChild(bird)
        
        // Переменные для управления поведением
        var currentDirection = CGVector(dx: sin(baseAngle), dy: cos(baseAngle))
        var targetDirection = currentDirection
        var lastBehaviorUpdate = 0.0
        var lastDirectionChange = 0.0
        var currentSpeed = playerSpeed * enemySpeedMultiplier * CGFloat.random(in: 0.8...1.2)
        
        bird.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run { [weak self, weak bird] in
                guard let self = self, let bird = bird else { return }
                
                // Время с последнего обновления
                lastBehaviorUpdate += 1.0/60.0
                lastDirectionChange += 1.0/60.0
                
                // Обновляем цель каждые 0.5-1.5 секунды
                if lastDirectionChange >= Double.random(in: 0.5...1.5) {
                    lastDirectionChange = 0
                    
                    // Рассчитываем базовое направление к игроку
                    let toPlayer = CGVector(
                        dx: self.player.position.x - bird.position.x,
                        dy: self.player.position.y - bird.position.y
                    )
                    
                    // Нормализуем вектор
                    let distanceToPlayer = hypot(toPlayer.dx, toPlayer.dy)
                    let normalizedDirection = CGVector(
                        dx: toPlayer.dx/distanceToPlayer,
                        dy: toPlayer.dy/distanceToPlayer
                    )
                    
                    // Добавляем случайное отклонение
                    let randomAngle = CGFloat.random(in: -.pi/3 ... .pi/3)
                    targetDirection = CGVector(
                        dx: normalizedDirection.dx * cos(randomAngle) - normalizedDirection.dy * sin(randomAngle),
                        dy: normalizedDirection.dx * sin(randomAngle) + normalizedDirection.dy * cos(randomAngle)
                    )
                    
                    // Плавное изменение скорости
                    currentSpeed = self.playerSpeed * self.enemySpeedMultiplier * CGFloat.random(in: 0.8...1.2)
                }
                
                // Плавное изменение направления (интерполяция)
                let interpolationFactor: CGFloat = 0.1 // Меньше значение = плавнее поворот
                currentDirection.dx = currentDirection.dx * (1 - interpolationFactor) + targetDirection.dx * interpolationFactor
                currentDirection.dy = currentDirection.dy * (1 - interpolationFactor) + targetDirection.dy * interpolationFactor
                
                // Нормализуем вектор направления
                let length = sqrt(currentDirection.dx * currentDirection.dx + currentDirection.dy * currentDirection.dy)
                if length > 0 {
                    currentDirection.dx /= length
                    currentDirection.dy /= length
                }
                
                // Применяем движение
                bird.position.x += currentDirection.dx * currentSpeed * CGFloat(1.0/60.0)
                bird.position.y += currentDirection.dy * currentSpeed * CGFloat(1.0/60.0)
                
                // Плавный поворот птицы в направлении движения
                let targetAngle = atan2(currentDirection.dy, currentDirection.dx)
                let angleDifference = (targetAngle - bird.zRotation - .pi/2).truncatingRemainder(dividingBy: .pi * 2)
                let shortestAngle = angleDifference > .pi ? angleDifference - .pi * 2 :
                                   angleDifference < -.pi ? angleDifference + .pi * 2 : angleDifference
                
                let rotationSpeed: CGFloat = 0.05 // Меньше значение = плавнее поворот
                bird.zRotation += shortestAngle * rotationSpeed
                
                // Удаляем, если слишком далеко от игрока
                let currentDistance = hypot(self.player.position.x - bird.position.x,
                                          self.player.position.y - bird.position.y)
                if currentDistance > self.maxEnemyDistance * 2 {
                    bird.removeFromParent()
                }
            },
            SKAction.wait(forDuration: 1.0/60.0)
        ])))
    }


    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.player {
            if secondBody.categoryBitMask == PhysicsCategory.rubin,
               let rubin = secondBody.node as? SKSpriteNode {
                
                // Эффект сбора рубина
                let collectAction = SKAction.sequence([
                    SKAction.group([
                        SKAction.fadeOut(withDuration: 0.3),
                        SKAction.scale(to: 0.1, duration: 0.3)
                    ]),
                    SKAction.removeFromParent()
                ])
                
                rubin.run(collectAction)
                
                // Награда за рубин
                addCoins(2)
                increaseHealth()
                
                if currentRubin == rubin {
                    currentRubin = nil
                    rubinSpawnTimer = 0
                }
            }
            else if secondBody.categoryBitMask == PhysicsCategory.bomb ||
                        secondBody.categoryBitMask == PhysicsCategory.boom {
                reduceHealth()
                secondBody.node?.removeFromParent()
            } else if secondBody.categoryBitMask == PhysicsCategory.coin,
                      let coin = secondBody.node as? SKSpriteNode, coin == currentCoin {
                
                let collectAction = SKAction.sequence([
                    SKAction.group([
                        SKAction.fadeOut(withDuration: 0.3),
                        SKAction.scale(to: 0.1, duration: 0.3)
                    ]),
                    SKAction.removeFromParent()
                ])
                
                gameData?.coins += 1
                coinLabel.text = "\(gameData?.coins ?? 0)"
                coin.run(collectAction)
                currentCoin = nil
                coinSpawnTimer = 0
            }
            
        }
    }
    
}
extension CGPoint {
    func lerp(to point: CGPoint, factor: CGFloat) -> CGPoint {
        return CGPoint(
            x: self.x + (point.x - self.x) * factor,
            y: self.y + (point.y - self.y) * factor
        )
    }
}



enum PhysicsCategory {
    static let player: UInt32 = 0x1 << 0
    static let bomb: UInt32 = 0x1 << 1
    static let rubin: UInt32 = 0x1 << 2
    static let coin: UInt32 = 0x1 << 3
    static let boom: UInt32 = 0x1 << 4
    
}

extension SKSpriteNode {
    var cornerRadius: CGFloat {
        get { return 0 }
        set {
            let shape = SKShapeNode(rectOf: size, cornerRadius: newValue)
            shape.fillColor = self.color
            shape.strokeColor = .clear
            let textureView = SKView()
            let texture = textureView.texture(from: shape)
            self.texture = texture
        }
    }
}
extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx*dx + dy*dy)
        return length > 0 ? CGVector(dx: dx/length, dy: dy/length) : .zero
    }
}

extension CGPoint {
    func normalized() -> CGPoint {
        let length = sqrt(x * x + y * y)
        return length > 0 ? CGPoint(x: x / length, y: y / length) : .zero
    }
}
