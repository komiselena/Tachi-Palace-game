//
//  BackButton.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct BackButton: View {
    
    var body: some View {
        GeometryReader { g in
                ZStack{
                    Circle()
                        .foregroundStyle(.red)
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundStyle(.white)
                        .font(.title2)
                }
                .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)
        }
    }
}
