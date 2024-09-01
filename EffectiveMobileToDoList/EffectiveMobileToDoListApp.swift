//
//  EffectiveMobileToDoListApp.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

@main
struct EffectiveMobileToDoListApp: App {
    @EnvironmentObject var vm: ViewModel
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(ViewModel())
        }
    }
}
