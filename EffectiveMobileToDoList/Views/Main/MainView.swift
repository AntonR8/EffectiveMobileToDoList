//
//  ContentView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct MainView: View {
    @State var selection = 1
    @State private var showLaunchScreen = true
    @State private var opacity: CGFloat = 1
    var body: some View {
        ZStack {
            TabView(selection: $selection,
                    content:  {
                ListView()
                    .tabItem {
                        Text("Мои задачи")
                        Image(systemName: "list.bullet.rectangle.portrait")
                    }
                    .tag(1)
                AboutView()
                    .tabItem {
                        Text("О приложении")
                        Image(systemName: "info")
                    }
                    .tag(2)
            })
            
            LaunchScreen()
                .opacity(opacity)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut(duration: 1)) {
                            opacity = 0
                        }
                    }
                }
        }
    }
}

#Preview {
    MainView()
}
