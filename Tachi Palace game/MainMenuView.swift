//
//  MainMenuView.swift
//  NewCastle Game
//
//  Created by Mac on 16.05.2025.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject private var gameData = GameData()
    @StateObject private var gameViewModel = GameViewModel()
    @State private var selectedTab: Int = 0
    
    // Gradient colors for the tab bar
    private let gradientColors = [Color(hex: "#7C0A99"), Color(hex: "#440952")]
    private let tabBarHeight: CGFloat = 80  // Increased height
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    // Main content
                    TabView(selection: $selectedTab) {
                        HomeView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(0)
                            .ignoresSafeArea(.all, edges: .bottom)
                        
                        ShopView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(1)
                            .ignoresSafeArea(.all, edges: .bottom)
                        
                        AchievementsView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(2)
                            .ignoresSafeArea(.all, edges: .bottom)
                        
                        SettingsView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(3)
                            .ignoresSafeArea(.all, edges: .bottom)
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                    
                    // Custom tab bar
                    VStack(spacing: 0) {
                        // Tab items container
                        HStack(spacing: 0) {
                            ForEach(0..<4, id: \.self) { index in
                                TabItem(
                                    imageName: tabImageName(for: index),
                                    title: tabeTitle(for: index),
                                    isSelected: selectedTab == index,
                                    gradientColors: gradientColors
                                )
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    selectedTab = index
                                }
                            }
                        }
                        .frame(height: tabBarHeight)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: gradientColors),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(20, corners: [.topLeft, .topRight]) // Закругление 20pt сверху
                            .edgesIgnoringSafeArea(.bottom) // Игнорируем безопасную область снизу

                        )
                        
                    }
                    .frame(height: tabBarHeight)
                    .edgesIgnoringSafeArea(.bottom) // Игнорируем безопасную область снизу
                }
                .ignoresSafeArea(.keyboard)

            }
        } else {
            NavigationView {
                ZStack(alignment: .bottom) {
                    TabView(selection: $selectedTab) {
                        HomeView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(0)
                            .ignoresSafeArea(.all, edges: .bottom)
                        
                        ShopView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(1)
                            .ignoresSafeArea(.all, edges: .bottom)
                        
                        AchievementsView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(2)
                            .ignoresSafeArea(.all, edges: .bottom)
                        
                        SettingsView(gameData: gameData, gameViewModel: gameViewModel)
                            .tag(3)
                            .ignoresSafeArea(.all, edges: .bottom)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Custom tab bar for iOS 15
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(0..<4, id: \.self) { index in
                                TabItem(
                                    imageName: tabImageName(for: index),
                                    title: tabeTitle(for: index),
                                    isSelected: selectedTab == index,
                                    gradientColors: gradientColors
                                )
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    selectedTab = index
                                }
                            }
                        }
                        .frame(height: tabBarHeight)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: gradientColors),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(20, corners: [.topLeft, .topRight]) // Закругление 20pt сверху

                        )
                        
                    }
                    .frame(height: tabBarHeight)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
    }
    
    private func tabImageName(for index: Int) -> String {
        switch index {
        case 0: return "flag"
        case 1: return "shop"
        case 2: return "Achievs"
        case 3: return "settings"
        default: return ""
        }
    }
    private func tabeTitle(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Shop"
        case 2: return "Achievs"
        case 3: return "Settings"
        default: return ""
        }
    }

}

// Custom tab item view with larger icons
// Custom tab item view
struct TabItem: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let gradientColors: [Color]
    
    var body: some View {
        VStack(spacing: 4) {
            // Квадрат цвета #440952 под каждой иконкой
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#440952"))
                    .frame(width: 60, height: 60)
                VStack{
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text(title)
                        .foregroundStyle(.white)
                        .font(.system(size: 12))

                }
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}


// Corner radius extension (same as before)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    MainMenuView()
}
