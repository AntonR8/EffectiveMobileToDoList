//
//  ListView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var vm: ViewModel
    
    
    var body: some View {
        NavigationStack(){
            List {
                ForEach(vm.toDoList.sorted(by: { $0.dateMade ?? Date() < $1.dateMade ?? Date() })) { item in
                    ListElementView(entry: item)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(item.completed ? "Не выполнено" : "Выполнено") {
                                vm.makeCompleted(entry: item)
                            }
                            .tint(item.completed ? .orange : .green)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Удалить") {
                                vm.deleteItem(entry: item)
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
        .environmentObject(ViewModel())
}
