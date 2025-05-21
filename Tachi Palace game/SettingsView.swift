import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject private var musicManager = MusicManager.shared

    var body: some View {
        GeometryReader { g in
            ZStack {
                Image("BG")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                        ZStack{
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.9 , height: g.size.height * 0.1)
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
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.9 , height: g.size.height * 0.1)
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
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.9 , height: g.size.height * 0.1)
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
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.6)

            }
            .frame(width: g.size.width, height: g.size.height )

        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button{ dismiss() } label: {
                    BackButton()
                }
            }
        })

        .navigationBarBackButtonHidden()
    }
}

