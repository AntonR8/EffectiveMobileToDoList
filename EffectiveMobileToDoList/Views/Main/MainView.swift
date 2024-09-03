//
//  ContentView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct MainView: View { 
    @EnvironmentObject var presenter: Presenter
    @StateObject var router = Router()

    @State private var opacity: CGFloat = 1
   
    var body: some View {
        ZStack {
            TabView(selection: $router.currentRoute,
                    content:  {
                ListView()
                    .tabItem {
                        Text("Мои задачи")
                        Image(systemName: "list.bullet.rectangle.portrait")
                    }
                    .tag("list")

                AboutView()
                    .tabItem {
                        Text("О приложении")
                        Image(systemName: "info")
                    }
                    .tag("about")
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
            VStack {
                Spacer()
                if !presenter.isTyping {
                    PlusButtonView()
                        .opacity(1.0-opacity)
                        .transition(.opacity)
                }
            }
        }


        .sheet(isPresented: $presenter.createNewEntry, content: {
            EntryEditingView(entry: nil, navigationTitle: "Новая задача", saveButtonName: "Добавить")
                .presentationDetents([.medium])
                .onDisappear{
                    presenter.isTyping = false
                }
        })
    }
    
    
}

#Preview {
    MainView()
        .environmentObject(Presenter(interactor: Interactor()))
}
