//
//  ContentView.swift
//  Bubbly
//
//  Created by Devin Jay on 9/5/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.blue)
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("Bubbly!")
                        .font(.custom("MarkerFelt-Thin", size: 90))
                        .foregroundStyle(Color(red: 0.4627, green: 0.8392, blue: 1.0))
                }
                Spacer()
                ZStack
                {
                    Image("BubbleWrap")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                        .scaleEffect(x: 1, y: -1)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
