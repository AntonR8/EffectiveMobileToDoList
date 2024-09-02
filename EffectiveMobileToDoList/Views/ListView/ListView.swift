//
//  ListView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var presenter: Presenter
        
    var body: some View {
        NavigationStack(){
            List {
                ForEach(presenter.toDoList.sorted(by: { $0.dateMade ?? Date() > $1.dateMade ?? Date() })) { entry in
                    ListElementView(entry: entry)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(entry.completed ? "Не выполнено" : "Выполнено") {
                                    presenter.makeCompleted(entry: entry)
                            }
                            .tint(entry.completed ? .orange : .green)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Удалить") {
                                presenter.deleteItem(entry: entry)
                            }
                            .tint(.red)
                        }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Мои задачи")
        }
    }
}

#Preview {
    ListView()
        .environmentObject(Presenter(interactor: Interactor()))
}
