//
//  ContentView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var vm: ViewModel
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
            VStack {
                Spacer()
                PlusButtonView()
                    .opacity(1.0-opacity)
            }
        }
        
        .sheet(isPresented: $vm.createNewEntry, content: {
            EntryEditingView(entry: nil, navigationPath: $vm.navigationPath, navigationTitle: "Новая задача", saveButtonName: "Добавить")
                .presentationDetents([.medium])
        })
    }
    
    
}

#Preview {
    MainView()
        .environmentObject(ViewModel())
}
