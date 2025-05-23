//
//  MazeView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI
import SpriteKit

struct MazeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scene: MazeGameScene

    @ObservedObject var gameData: GameData
    @State private var timeLeft = 90
    @State private var timer: Timer?
    @State private var showWin = false
    @ObservedObject var gameViewModel: GameViewModel

    init(gameData: GameData, gameViewModel: GameViewModel) {
        self.gameData = gameData
        self.gameViewModel = gameViewModel
        let scene = MazeGameScene(size: CGSize(width: 196, height: 196))
        scene.onGameWon = {
            scene.isWon = true
        }
        self._scene = StateObject(wrappedValue: scene)
    }

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 0) {
                    HStack(spacing: 0){
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
//                        .padding(.horizontal,20)
                        
                        Text("Labyrinth")
                            .foregroundStyle(.white)
                            .font(.title2.weight(.bold))
                        Spacer()

                        ZStack{

                            Capsule()
                                .foregroundStyle(.black)
                                .opacity(0.5)
                                .frame(width: g.size.width * 0.16, height: g.size.width * 0.06)

                            HStack{
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.04, height: g.size.width * 0.04)

                                Text("\(gameData.coins)")
                                    .foregroundStyle(.white)
                                    .font(.title3)

                            }
                            .frame(width: g.size.width * 0.17, height: g.size.width * 0.06)

                        }
                    }
                    .frame(width: g.size.width , height: g.size.height * 0.1)
                    Spacer()

                    if scene.isWon {
                        ZStack{
                            Image("bg")
                                .resizable()
                                .ignoresSafeArea()
                            ZStack{
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundStyle(.black)
                                        .opacity(0.3)
                                        .frame(width: g.size.width * 0.7, height: g.size.height * 0.7)

                                VStack(){
                                    Image("stars")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.4, height: g.size.height * 0.3)
                                    
                                    Text("You Win!")
                                        .foregroundStyle(.white)
                                        .font(.title)
                                    HStack{
                                        Button {
                                            dismiss()
                                        } label: {
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "house")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                            
                                        }
                                        
                                    }
                                }
                                .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)
                            }
                            
                        }
                    } else{
                        
                        HStack(spacing: 30){
                            Spacer()
                            SpriteView(scene: scene)
                                .frame(width: g.size.width * 0.4, height: g.size.width * 0.4)
                                .border(Color.white)
                            //                            .padding(.leading, 20)
                            
                            Spacer()
                            VStack(spacing: 0){
                                // up
                                Button(action: { scene.movePlayer(dx: 0, dy: scene.moveStep) }) {
                                    ZStack{
                                        Circle()
                                            .frame(width: g.size.width * 0.1 , height: g.size.width * 0.1 )
                                            .foregroundStyle(.red)
                                        Image(systemName: "arrowtriangle.up.fill")
                                            .foregroundStyle(.white)
                                            .font(.title.weight(.bold))
                                        
                                    }
                                }
                                HStack(spacing: 0) {
                                    //left
                                    Button(action: { scene.movePlayer(dx: -scene.moveStep, dy: 0) }) {
                                        ZStack{
                                            Circle()
                                                .frame(width: g.size.width * 0.1 , height: g.size.width * 0.1 )
                                                .foregroundStyle(.red)

                                            Image(systemName: "arrowtriangle.left.fill")
                                                .foregroundStyle(.white)
                                                .font(.title.weight(.bold))
                                            
                                        }
                                    }
                                    //down
                                    Button(action: {  }) {
                                        ZStack{
                                            Circle()
                                                .frame(width: g.size.width * 0.1 , height: g.size.width * 0.1 )
                                                .foregroundStyle(.red)
                                                .opacity(0.0)

                                            Image(systemName: "arrowtriangle.down.fill")
                                                .foregroundStyle(.white)
                                                .font(.title.weight(.bold))
                                                .opacity(0.0)

                                        }
                                    }
                                    // right
                                    Button(action: { scene.movePlayer(dx: scene.moveStep, dy: 0) }) {
                                        ZStack{
                                            Circle()
                                                .frame(width: g.size.width * 0.1 , height: g.size.width * 0.1 )
                                                .foregroundStyle(.red)

                                            Image(systemName: "arrowtriangle.right.fill")
                                                .foregroundStyle(.white)
                                                .font(.title.weight(.bold))
                                            
                                        }
                                    }
                                }
                                Button(action: { scene.movePlayer(dx: 0, dy: -scene.moveStep) }) {
                                    ZStack{
                                        Circle()
                                            .frame(width: g.size.width * 0.1 , height: g.size.width * 0.1 )
                                            .foregroundStyle(.red)

                                        Image(systemName: "arrowtriangle.down.fill")
                                            .foregroundStyle(.white)
                                            .font(.title.weight(.bold))
                                        
                                    }
                                }

                            }
                            
                            Spacer()
                            
                        }
                    }
                    
                }
                .frame(width: g.size.width, height: g.size.height * 0.9)
                

            }
            .frame(width: g.size.width, height: g.size.height)



        }
        .navigationBarBackButtonHidden()

        
        
    }
}

