//
//  Interactor.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 02.09.2024.
//

import Foundation
import CoreData

class Interactor {

//    toDoList = fetchData
    func fetchData(container: NSPersistentContainer) -> [ToDoListEntity]{
        let request = NSFetchRequest<ToDoListEntity>(entityName: "ToDoListEntity")
        do {
            return try container.viewContext.fetch(request)
        } catch let error {
            print ("Ошибка извлечения данных: \(error)")
            return []
        }
    }

    func saveContainer(container: NSPersistentContainer) {
        do {
            try container.viewContext.save()
        } catch let error {
            print ("Ошибка сохранения данных: \(error)")
        }
    }

    func createNewEntry(container: NSPersistentContainer, id: Int64 = Int64(UUID().hashValue), userID: Int64 = 1, todo: String, completed: Bool = false, date: Date = Date()) {
        // создаём экземпляр данных:
        let newItem = ToDoListEntity(context: container.viewContext)
        newItem.id = id
        newItem.userID = userID
        newItem.todo = todo
        newItem.completed = completed
        newItem.dateMade = date

        saveContainer(container: container)
//        fetchData(container: container)
    }

    func resaveEntry(container: NSPersistentContainer, entry: ToDoListEntity, todo: String) {
        container.viewContext.delete(entry)
        createNewEntry(
            container: container, 
            id: entry.id,
            userID: entry.userID,
            todo: todo,
            completed: entry.completed,
            date: entry.dateMade ?? Date()
        )
    }

    func deleteItem(container: NSPersistentContainer, entry: ToDoListEntity) {
        container.viewContext.delete(entry)
        saveContainer(container: container)
//        fetchData(container: container)
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

    func saveDownLoadedData(container: NSPersistentContainer) {
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
                            container: container, 
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
//        toDoList.removeAll()
//        saveContainer()
//        saveDownLoadedData()
    }

    func makeCompleted(entry: ToDoListEntity) {
//        entry.completed.toggle()
//        saveContainer()
//        fetchData()
    }




}
