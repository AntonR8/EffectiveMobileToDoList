//
//  ListView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct ListView: View {
   @ObservedObject var vm = ViewModel()
    @State var addOn = false

    var body: some View {
        List {
            ForEach(vm.toDoList) { item in
                ListElementView(id: Int(item.id), todo: item.todo ?? "", completed: item.completed, userID: Int(item.userID), dateMade: item.dateMade ?? Date())
            }
        }
        .onDelete(perform: { indexSet in
            vm.deleteItem(atOffsets: indexSet)
        })
        .onMove(perform: {i1,i2 in
            vm.moveItems(fromOffsets: i1, toOffset: i2)
        })
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button (action:{
                    addOn.toggle()
                }, label: {
                    Image(systemName: "plus")
                })

            }
        }
    }
}

#Preview {
    ListView()
        .environmentObject(ViewModel())
}
