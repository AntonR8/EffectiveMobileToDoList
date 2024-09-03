//
//  AboutView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var presenter: Presenter

    let personalURL = URL(string: "https://antonr8.tilda.ws")!
    let appslURL = URL(string: "https://apps.apple.com/app/id6479015785")!
    let contactURL = URL(string: "https://t.me/AntonR87")!

    @State var showButton = true

    var body: some View {
        NavigationStack {
            List {
                Section (header: Text("Информация о разработчике")) {
                    VStack(alignment: .leading) {
                        Image ("myLogo")
                            .resizable ()
                            .frame(width: 90, height: 90)
                            .clipShape (Circle())
                        Text ("Приложение создано полностью на языке Swift в программе Xcode.  Приложение создано программистом и разработчиком приложений  ")
                            .font(.callout)
                            .fontWeight (.medium)
                        Text ("Разгуляевым Антоном | Anton Ra")
                            .fontWeight (.bold)
                            .padding (.vertical)
                        Link ("Cвязаться со мной", destination: contactURL)
                            .foregroundStyle(.blue)
                    }

                }

                Section (header: Text ("Cсылки")) {
                    Link( "Мои приложения", destination: appslURL)
                    Link ("Company Website", destination: personalURL)
                }
                .foregroundStyle(.primary)
            }
            .onAppear{
                showButton = true
            }
            .navigationTitle("О приложении")
        }

    }
}

#Preview {
    AboutView()
        .environmentObject(Presenter(interactor: Interactor()))
}
