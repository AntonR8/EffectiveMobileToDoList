//
//  ViewModel.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    @Published var createNewEntry = false
    @Published var navigationPath = NavigationPath()
    @AppStorage("firstLaunch") var firstLaunch = true
    @Published var toDoList: [ToDoListEntity] = []
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ToDoListData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print ("Ошибка загрузки данных: \(error)")
            }
        }
        fetchData()
        if firstLaunch {
            saveDownLoadedData()
        }
        firstLaunch = false
    }

    func fetchData() {
        let request = NSFetchRequest<ToDoListEntity>(entityName: "ToDoListEntity")
        do {
            toDoList = try container.viewContext.fetch(request)
        } catch let error {
            print ("Ошибка извлечения данных: \(error)")
        }
    }
    
    func saveContainer() {
        do {
            try container.viewContext.save()
        } catch let error {
            print ("Ошибка сохранения данных: \(error)")
        }
    }

    func createNewEntry(id: Int64 = Int64(UUID().hashValue), userID: Int64 = 1, todo: String = "Новая задача2", completed: Bool = false, date: Date = Date()) {
        // создаём экземпляр данных:
        let newItem = ToDoListEntity(context: container.viewContext)
        newItem.id = id
        newItem.userID = userID
        newItem.todo = todo
        newItem.completed = completed
        newItem.dateMade = date
      
        saveContainer()
        fetchData()
    }
    
    func resaveEntry(entry: ToDoListEntity, todo: String) {
                container.viewContext.delete(entry)
                createNewEntry(
                    id: entry.id,
                    userID: entry.userID,
                    todo: todo,
                    completed: entry.completed,
                    date: entry.dateMade ?? Date()
                    ) 
    }

                   
    func deleteItem(atOffsets: IndexSet) {
        for entry in toDoList {
            if let index = atOffsets.first {
                if toDoList[index].id == entry.id {
                    container.viewContext.delete(entry)
                }
            }
        }
        saveContainer()
        fetchData()
    }
    
    func moveItems(fromOffsets: IndexSet, toOffset: Int) {
        toDoList.move(fromOffsets: fromOffsets, toOffset: toOffset)
        saveContainer()
    }

    func downLoadJSONData(url: URL, completionHandler: @escaping(Data) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300,
                error == nil
            else {
                print ("Ошибка загрузки данных")
                return
            }
            completionHandler(data)
        }.resume()
    }

    
    func deleteAllData() {
        toDoList.removeAll()
        saveContainer()
    }
    
    
    func saveDownLoadedData() {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            print("Переданная ссылка не корректна")
            return
        }
        downLoadJSONData(url: url) { data in
            let decodedData = try? JSONDecoder().decode(JSONDataModel.self, from: data)
            DispatchQueue.main.async {
                if let decodedData {
                    for item in decodedData.todos {
                        self.createNewEntry(
                            id: Int64(item.id),
                            userID: Int64(item.userID),
                            todo: item.todo,
                            completed: item.completed)
                    }
                }
            }
        }
    }

    func resetTheList() {
        deleteAllData()
        saveDownLoadedData()
    }

    func makeCompleted(entry: ToDoListEntity) {
        entry.completed.toggle()
        saveContainer()
        fetchData()
    }




}
