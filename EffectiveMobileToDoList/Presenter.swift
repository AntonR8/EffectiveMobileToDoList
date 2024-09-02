//
//  Presenter.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 02.09.2024.
//

import SwiftUI
import CoreData

class Presenter: ObservableObject {

    public var view: MainView?
    public var interactor: Interactor

    @Published var createNewEntry = false
    @Published var navigationPath = NavigationPath()

    @AppStorage("firstLaunch") var firstLaunch = true
    @Published var toDoList: [ToDoListEntity] = []

    let container: NSPersistentContainer

    init(view: MainView?, interactor: Interactor) {
        self.view = view
        self.interactor = interactor

        container = NSPersistentContainer(name: "ToDoListData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print ("Ошибка загрузки данных: \(error)")
            }
        }
        toDoList = interactor.fetchData(container: container)
        if firstLaunch {
            interactor.saveDownLoadedData(container: container)
        }
        firstLaunch = false
    }


}
