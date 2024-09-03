//
//  Interactor.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 02.09.2024.
//

import Foundation
import CoreData

class Interactor {

    /// Функция извлечения данных из контейнера. Принимает в качестве параметра контейнер типа NSPersistentContainer, который должен содержать сущность "ToDoListEntity", возвращает массив данных типа ToDoListEntity. В случае ошибки возвращает пустой массив
    func fetchData(container: NSPersistentContainer) -> [ToDoListEntity]{
        let request = NSFetchRequest<ToDoListEntity>(entityName: "ToDoListEntity")
        do {
            return try container.viewContext.fetch(request)
        } catch let error {
            print ("Ошибка извлечения данных: \(error)")
            return []
        }
    }

    /// Функция сохранения контекста в контейнере
    func saveContainer(container: NSPersistentContainer) {
        do {
            try container.viewContext.save()
        } catch let error {
            print ("Ошибка сохранения данных: \(error)")
        }
    }

    /// Функция сохранения записи в списке дел в контейнере. Применяется как для создания новых записей, так и для изменения существуюших.
    func saveEntry(container: NSPersistentContainer, id: Int64 = Int64(UUID().hashValue), userID: Int64 = 1, todo: String, completed: Bool = false, date: Date = Date()) {
        let newItem = ToDoListEntity(context: container.viewContext)
        newItem.id = id
        newItem.userID = userID
        newItem.todo = todo
        newItem.completed = completed
        newItem.dateMade = date

        saveContainer(container: container)
    }

    /// Функция  загрузки данных по ссылке. Принимает на вход URL, на выходе возвращает обработчик выполнения со скачанными данными. Обрабатывает возможные ошибки: отсутствие данных, отсуствие ответа сервера, "неуспешный" ответ сервера, или ошибки в ходе выполнения.
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

    ///Функция сохранения скачиваемых данных по ссылке в контейнере. Принимает в качестве параметров контейнер типа NSPersistentContainer и ссылку в виде строки. Конвертирует ссылку из строки в URL, далее вызывает функцию downLoadJSONData() для переданной ссылки, конвертирует получаемые данные из JSON-формата, и из содержащегося в них массива todos сохраняет в контейнер  записи типа ToDoListEntity. После скачивания, конвертации и сохранения извлекает данные и передаёт в обработчик исполнения для последующего применения.
    func saveDownLoadedData(container: NSPersistentContainer, link: String, completionHandler: @escaping([ToDoListEntity]) -> ()) {
        guard let url = URL(string: link) else {
            print("Переданная ссылка не корректна")
            return
        }
        downLoadJSONData(url: url) {data in
            let decodedData = try? JSONDecoder().decode(JSONDataModel.self, from: data)
            if let decodedData {
                for item in decodedData.todos {
                    self.saveEntry(
                        container: container,
                        id: Int64(item.id),
                        userID: Int64(item.userID),
                        todo: item.todo,
                        completed: item.completed)
                    print("Сохранена в контейнере запись \(item.id)")
                    completionHandler(self.fetchData(container: container))
                }
            }
        }
    }

}
