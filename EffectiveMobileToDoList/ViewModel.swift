//
//  ViewModel.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import Foundation
import CoreData

class ViewModel: ObservableObject {
   @Published var toDoList: [ToDoListEntity] = []
    let container: NSPersistentContainer

    init() {


        container = NSPersistentContainer (name: "ToDoListData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print ("Ошибка загрузки данных: \(error)")
            } else {
                print ("Даннные успешно загружены")
            }
        }

        let newItem = ToDoListEntity(context: container.viewContext)
        newItem.id = Int64(UUID().hashValue)
        newItem.userID = 1
        newItem.todo = "Новая задача"
        newItem.completed = false
        fetchHelloData()
    }

    func fetchHelloData() {
        let request = NSFetchRequest<ToDoListEntity>(entityName: "ToDoListEntity")
        do {
            toDoList = try container.viewContext.fetch(request)
        } catch let error {
            print ("Ошибка извлечения данных: \(error)")
        }
    }

    func newItem(/*id: Int64, userID: Int64, todo: String, completed: Bool*/) {
        // создаём экземпляр данных:
        let newItem = ToDoListEntity(context: container.viewContext)
        newItem.id = Int64(UUID().hashValue)
        newItem.userID = 1
        newItem.todo = "Новая задача2"
        newItem.completed = false


        // сохраняем экземпляр данных:
        do {
            try container.viewContext.save()
        } catch let error {
            print ("Ошибка сохранения данных: \(error)")
        }

        // извлекаем данные из контейнера
        fetchHelloData()
    }
    
    func deleteItem(atOffsets: IndexSet) {
        toDoList.remove(atOffsets: atOffsets)
    }
    
    func moveItems(fromOffsets: IndexSet, toOffset: Int) {
        toDoList.move(fromOffsets: fromOffsets, toOffset: toOffset)
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


    func resetTheList(link: String) {
        guard let url = URL(string: link) else {
            print("Переданная ссылка не корректна")
            return
        }
        downLoadJSONData(url: url) { data in
            let decodedData = try? JSONDecoder().decode(JSONDataModel.self, from: data)
                DispatchQueue.main.async {
                    if let decodedData {
                        for item in decodedData.todos {
                            print("Сохраняю данные в контейнер")
                            let newItem = ToDoListEntity(context: self.container.viewContext)
//                            newItem.id = Int64(item.id)
//                            newItem.userID = Int64(item.userID)
//                            newItem.todo = item.todo
//                            newItem.completed = item.completed
                            newItem.id = Int64(UUID().hashValue)
                            newItem.userID = 1
                            newItem.todo = "Новая задача"
                            newItem.completed = false
                        }
                    }
                    print("Всего объектов в хранилище: \(String(describing: decodedData?.todos.count))")
                }
        }
        // извлекаем данные из контейнера
        fetchHelloData()
    }






}
