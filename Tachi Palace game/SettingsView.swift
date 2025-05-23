//
//  SettingsView.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject private var musicManager = MusicManager.shared

    var body: some View {
        GeometryReader { g in
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack{
                    // Header
                    HStack{
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                        Text("Settings")
                            .foregroundStyle(.white)
                            .font(.title2.weight(.bold))
                        
                        Spacer()
                        
                    }
                    .frame(width: g.size.width * 0.9)
                    Spacer()


                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.black)
                                .opacity(0.5)
                                .frame(width: g.size.width * 0.9, height: g.size.height * 0.2)
                            HStack{
                                Text("Music")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.heavy)) // Uses iOS's default title size + heavy weight
                                    .padding()
                                Spacer()
                                Button {
                                    if !musicManager.paused {
                                        MusicManager.shared.pauseMusic()
                                    }else{
                                        MusicManager.shared.resumeMusic()
                                    }
                                } label: {
                                    Text(!musicManager.paused ? "ON" : "OFF")
                                        .foregroundStyle(.white)
                                        .opacity(!musicManager.paused ? 1.0 : 0.5)

                                        .font(.title.weight(.heavy)) // Uses iOS's default title size + heavy weight
                                        .padding()

                                }

                            }
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.1)

                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.black)
                                .opacity(0.5)
                                .frame(width: g.size.width * 0.9, height: g.size.height * 0.2)
                            HStack{
                                Text("Sounds")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.heavy)) // Uses iOS's default title size + heavy weight
                                    .padding()
                                Spacer()
                                Button {
                                    if musicManager.soundsOn {
                                        musicManager.soundsOn = false
                                    }else{
                                        musicManager.soundsOn = true
                                    }
                                } label: {
                                    Text(musicManager.soundsOn ? "ON" : "OFF")
                                        .foregroundStyle(.white)
                                        .opacity(musicManager.soundsOn ? 1.0 : 0.5)
                                        .font(.title.weight(.heavy)) // Uses iOS's default title size + heavy weight
                                        .padding()

                                }

                            }
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.1)

                        }
                    
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.black)
                                .opacity(0.5)
                                .frame(width: g.size.width * 0.9, height: g.size.height * 0.2)
                            HStack{
                                Text("Vibro")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.heavy)) // Uses iOS's default title size + heavy weight
                                    .padding()
                                Spacer()
                                Button {
                                    // vibro ...
                                } label: {
                                    Text("OFF")
                                        .foregroundStyle(.white)
                                        .opacity(0.5)
                                        .font(.title3.weight(.heavy)) // Uses iOS's default title size + heavy weight
                                        .padding()

                                }

                            }
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.1)

                        }
                    Spacer()

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height )

        }


        .navigationBarBackButtonHidden()
    }
}

