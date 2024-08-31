//
//  AboutView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct AboutView: View {
    @StateObject var vm = ViewModel()
    let personalURL = URL(string: "https://antonr8.tilda.ws")!

    var body: some View {
        NavigationStack {
            List {
                Button(action: {
//                    vm.resetTheList(link: "https://dummyjson.com/todos")
                    vm.newItem()
                }, label: {
                    Text("Восстановить исходный список")
                })

                Section (header: Text("Информация о разработчике")) {
                    VStack(alignment: .leading) {
                        Image ("myLogo")
                            .resizable ()
                            .frame(width: 98, height: 98)
                            .clipShape (Circle())
                        Text ("Приложение создано полностью на языке Swift в программе Xcode.  Приложение создано программистом и разработчиком приложений  ")
                            .font(.callout)
                            .fontWeight (.medium)
                        Text ("Разгуляевым Антоном | Anton Ra")
                            .fontWeight (.bold)
                            .padding (.vertical)
                        Link ("Cвязаться со мной", destination: personalURL)
                            .foregroundStyle(.blue)
                    }

                }

                Section (header: Text ("Cсылки")) {
                    Link( "Privacy Policy", destination: personalURL)
                    Link ("Company Website", destination: personalURL)
                }
            }
            .navigationTitle("О приложении")
        }

    }
}

#Preview {
    AboutView()
}
