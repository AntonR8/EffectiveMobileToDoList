//
//  EffectiveMobileToDoListApp.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

@main
struct EffectiveMobileToDoListApp: App {
    @EnvironmentObject var presenter: Presenter
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(Presenter(interactor: Interactor()))
        }
    }
}
