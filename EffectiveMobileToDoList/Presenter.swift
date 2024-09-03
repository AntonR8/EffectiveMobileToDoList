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

    var container: NSPersistentContainer

    init(interactor: Interactor) {
        self.interactor = interactor

        container = NSPersistentContainer(name: "ToDoListData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print ("Ошибка загрузки данных: \(error)")
            }
        }

        if self.firstLaunch {
            interactor.saveDownLoadedData(container: container, link: "https://dummyjson.com/todos") { fetchedData in
                DispatchQueue.main.async {
                    self.toDoList = fetchedData
                }
            }
            self.firstLaunch = false
        } else {
            self.toDoList = interactor.fetchData(container: self.container)
        }

    }

    /// Функция изменения свойства completed. Изменяет значение на противоположное. Все задачи выполняются в фоновом потоке, задача, свящанная с измением toDoList, который отображается на View, выполняется в главном. В данной функции)не возникает цикла сильных ссылок, поэтому применение слобых ссылок [weak self] не требуется.
    func makeCompleted(entry: ToDoListEntity) {
        DispatchQueue.global().async { [self] in
            self.container.viewContext.delete(entry)
            interactor.saveEntry(container: container, todo: entry.todo ?? "", completed: !entry.completed, date: entry.dateMade ?? Date())
            DispatchQueue.main.async {
                self.toDoList = self.interactor.fetchData(container: self.container)
            }
        }
    }

    /// Функция удаления передаваемой записи. Все задачи выполняются в фоновом потоке, задача, свящанная с измением toDoList, который отображается на View, выполняется в главном. В данной функции)не возникает цикла сильных ссылок, поэтому применение слобых ссылок [weak self] не требуется.
    func deleteItem(entry: ToDoListEntity) {
        DispatchQueue.global().async {
            self.container.viewContext.delete(entry)
            self.interactor.saveContainer(container: self.container)
            DispatchQueue.main.async {
                self.toDoList = self.interactor.fetchData(container: self.container)
            }
        }
    }

    /// Функция создания новой записи. Все задачи выполняются в фоновом потоке, задача, свящанная с измением toDoList, который отображается на View, выполняется в главном. В данной функции)не возникает цикла сильных ссылок, поэтому применение слобых ссылок [weak self] не требуется.
    func createNewEntry(todo: String) {
        DispatchQueue.global().async {
            self.interactor.saveEntry(container: self.container, todo: todo)
            DispatchQueue.main.async {
                self.toDoList = self.interactor.fetchData(container: self.container)
            }
        }
    }

    /// Функция сохранения измененной записи. Все задачи выполняются в фоновом потоке, задача, свящанная с измением toDoList, который отображается на View, выполняется в главном. В данной функции)не возникает цикла сильных ссылок, поэтому применение слобых ссылок [weak self] не требуется.
    func resaveEntry(entry: ToDoListEntity, todo: String) {
        DispatchQueue.global().async {
            self.container.viewContext.delete(entry)
            self.interactor.saveEntry(container: self.container, id: entry.id, userID: entry.userID, todo: todo, completed: entry.completed, date: entry.dateMade ?? Date())
            DispatchQueue.main.async {
                self.toDoList = self.interactor.fetchData(container: self.container)
            }
        }
    }
}
