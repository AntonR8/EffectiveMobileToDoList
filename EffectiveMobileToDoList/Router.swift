//
//  Router.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 02.09.2024.
//

import Foundation


class Router: ObservableObject {
    enum Route {
        case list
        case about
    }

    @Published var currentRoute: Route = .list

}
