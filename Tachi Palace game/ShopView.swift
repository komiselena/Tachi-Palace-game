//
//  ShopView.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    HStack(spacing: 0){
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
//                        .padding(.horizontal,20)
                        
                        Text("Shop")
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

                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)

                            VStack(spacing: 15){
                                Image("skin1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Glurp")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                Button {
                                    handleSkinButton(id: 1)
                                } label: {
                                    Text(currentSkinButtonImage(for: 1))
                                        .foregroundStyle(.white)
                                        .font(.callout.weight(.bold)) // Uses iOS's default title size + heavy weight
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.red)
                                            
                                            
                                        }
                                    
                                    
                                }
                                
                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)

                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("skin2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Zyxik")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                Button {
                                    handleSkinButton(id: 2)
                                } label: {
                                    Text(currentSkinButtonImage(for: 2))
                                        .foregroundStyle(.white)
                                        .font(.callout.weight(.bold)) // Uses iOS's default title size + heavy weight
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.red)
                                            
                                            
                                        }

                                    
                                }
                                
                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("skin3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Morblyx")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                Button {
                                    handleSkinButton(id: 3)
                                } label: {
                                    Text(currentSkinButtonImage(for: 3))
                                        .foregroundStyle(.white)
                                        .font(.callout.weight(.bold)) // Uses iOS's default title size + heavy weight
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.red)
                                            
                                            
                                        }

                                    
                                }
                                
                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("skin4")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Quibble")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                Button {
                                    handleSkinButton(id: 4)
                                } label: {
                                    Text(currentSkinButtonImage(for: 4))
                                        .foregroundStyle(.white)
                                        .font(.callout.weight(.bold)) // Uses iOS's default title size + heavy weight
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.red)
                                            
                                            
                                        }

                                    
                                }
                                
                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)

                    }

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)

        }
        .navigationBarBackButtonHidden()
    }
    
    private func handleSkinButton(id: Int) {
        if gameData.boughtSkinId.contains(id) {
            gameViewModel.skin = "skin\(id)"
            
            gameViewModel.objectWillChange.send()
        } else {
            if gameData.coins >= 100 {
                gameData.coins -= 100
                gameData.boughtSkinId.append(id)
            } else {
                print("Not enough money")
            }
        }
    }

    private func currentSkinButtonImage(for id: Int) -> String {
        if gameData.boughtSkinId.contains(id) && gameViewModel.skin != "skin\(id)" {
            return "Choose"
        } else if gameViewModel.skin == "skin\(id)" {
            return "Equipped"
        } else{
            return "100"
        }
    }

}
