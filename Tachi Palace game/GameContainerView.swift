//
//  GameContainerView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 25.04.2025.
//

import SwiftUI
import SpriteKit

struct GameContainerView: View {
    @State private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var gameData: GameData
    @Environment(\.dismiss) var dismiss
    
    // Состояния для джойстика
    @State private var joystickLocation: CGPoint = .zero
    @State private var joystickActive = false
    private let joystickRadius: CGFloat = 60
    private let thumbRadius: CGFloat = 20
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
                    .environmentObject(gameViewModel)
                
                VStack {
                    HStack(spacing: 0) {
                        Button {
                            dismiss()
                        } label: {
                                BackButton()
                            }
                            .padding()
                        Spacer()
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        // Панель управления
                        ZStack {
                            // Большой круг джойстика
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: g.size.width * 0.22, height: g.size.width * 0.22)
                            
                            // Маленький красный кружок
                            Circle()
                                .fill(Color.red)
                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                .offset(x: joystickLocation.x, y: joystickLocation.y)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let distance = hypot(value.translation.width, value.translation.height)
                                            let limitedDistance = min(distance, joystickRadius - thumbRadius)
                                            
                                            let angle = atan2(value.translation.height, value.translation.width)
                                            let x = limitedDistance * cos(angle)
                                            let y = limitedDistance * sin(angle)
                                            
                                            joystickLocation = CGPoint(x: x, y: y)
                                            joystickActive = true
                                            
                                            // Определяем направление по квадрантам
                                            let deadZone: CGFloat = 10
                                            
                                            // Сбрасываем все направления перед установкой новых
                                            gameScene.movePlayer(forward: false, start: false)
                                            gameScene.movePlayer(forward: true, start: false)
                                            gameScene.rotatePlayer(clockwise: true, start: false)
                                            gameScene.rotatePlayer(clockwise: false, start: false)
                                            
                                            // Определяем основной квадрант
                                            if abs(x) > abs(y) {
                                                // Горизонтальное движение (поворот)
                                                if x > deadZone {
                                                    gameScene.rotatePlayer(clockwise: true, start: true)
                                                } else if x < -deadZone {
                                                    gameScene.rotatePlayer(clockwise: false, start: true)
                                                }
                                            }
                                            
                                            if abs(y) > deadZone {
                                                // Вертикальное движение (вперед/назад)
                                                if y > deadZone {
                                                    gameScene.movePlayer(forward: false, start: true)
                                                } else {
                                                    gameScene.movePlayer(forward: true, start: true)
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            withAnimation {
                                                joystickLocation = .zero
                                            }
                                            joystickActive = false
                                            // Сбрасываем все направления при отпускании
                                            gameScene.movePlayer(forward: true, start: false)
                                            gameScene.movePlayer(forward: false, start: false)
                                            gameScene.rotatePlayer(clockwise: true, start: false)
                                            gameScene.rotatePlayer(clockwise: false, start: false)
                                        }
                                )
                            
                            // Стрелки направления
                            Group {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .offset(y: -(g.size.width * 0.09))
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .offset(y: g.size.width * 0.09)
                                
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .offset(x: -(g.size.width * 0.09))
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .offset(x: g.size.width * 0.09)
                            }
                        }
                    }
                }
                .blur(radius: gameViewModel.isGameOver ? 10 : 0)
                .frame(width: g.size.width, height: g.size.height)
                .overlay {
                    if gameViewModel.isGameOver {
                        ZStack {
                            Color.black
                                .opacity(0.5)
                                .blur(radius: 10)
                                .ignoresSafeArea()
                            VStack(spacing: 20) {
                                Text("Game Over")
                                    .foregroundStyle(.white)
                                    .font(.title.weight(.bold))
                                HStack {
                                    Image("coin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                    Text("\(gameData.coins)")
                                        .foregroundStyle(.white)
                                        .font(.title2.weight(.bold))
                                }
                                HStack {
                                    Button {
                                        gameViewModel.isGameOver = false
                                        dismiss()
                                        gameViewModel.restartGame = true
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "house")
                                                .foregroundStyle(.white)
                                                .font(.title2.weight(.bold))
                                        }
                                    }
                                    .padding()
                                    Button {
                                        gameViewModel.isGameOver = false
                                        dismiss()
                                        gameViewModel.restartGame = true
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "arrow.counterclockwise")
                                                .foregroundStyle(.white)
                                                .font(.title2.weight(.bold))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                setupGameScene()
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    private func setupGameScene() {
        let newScene = GameScene(size: UIScreen.main.bounds.size)
        newScene.scaleMode = .resizeFill
        newScene.gameViewModel = gameViewModel
        newScene.gameData = gameData
        gameScene = newScene
    }
}
