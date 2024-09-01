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
        NavigationStack(path: $vm.navigationPath){
            List {
                ForEach(vm.toDoList.sorted(by: { $0.id > $1.id })) { item in
                    ListElementView(entry: item)
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(item.completed ? "Не выполнено" : "Выполнено") {
                                vm.makeCompleted(entry: item)
                            }
                            .tint(item.completed ? .red : .blue)
                        }
                }
                .onDelete(perform: { indexSet in
                    vm.deleteItem(atOffsets: indexSet)
                })
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
