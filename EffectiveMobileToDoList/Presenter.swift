//
//  Presenter.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 02.09.2024.
//

import SwiftUI
import CoreData

class Presenter: ObservableObject {

    public var interactor: Interactor

    @Published var createNewEntry = false
    @Published var isTyping: Bool = false

    @AppStorage("firstLaunch") var firstLaunch = true
    @Published var toDoList: [ToDoListEntity] = []

    let container: NSPersistentContainer

    init(interactor: Interactor) {
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

    func resetTheList() {
        toDoList.removeAll()
        interactor.saveContainer(container: container)
        interactor.saveDownLoadedData(container: container)
        toDoList = interactor.fetchData(container: container)
    }

    func makeCompleted(entry: ToDoListEntity) {
        container.viewContext.delete(entry)
        interactor.saveEntry(container: container, todo: entry.todo ?? "", completed: !entry.completed, date: entry.dateMade ?? Date())
        toDoList = interactor.fetchData(container: container)
    }

    func deleteItem(entry: ToDoListEntity) {
        container.viewContext.delete(entry)
        interactor.saveContainer(container: container)
        toDoList = interactor.fetchData(container: container)
    }

    func createNewEntry(todo: String) {
        interactor.saveEntry(container: container, todo: todo)
        toDoList = interactor.fetchData(container: container)
    }

    func resaveEntry(entry: ToDoListEntity, todo: String) {
        container.viewContext.delete(entry)
        interactor.saveEntry(container: container, id: entry.id, userID: entry.userID, todo: todo, completed: entry.completed, date: entry.dateMade ?? Date())
        toDoList = interactor.fetchData(container: container)
    }

}
