//
//  ListElementView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct ListElementView: View {
    @EnvironmentObject var presenter: Presenter
    let entry: ToDoListEntity
    
    var body: some View {
        NavigationStack {
            HStack {
                Image(systemName: entry.completed ? "checkmark.circle" : "circlebadge")
                    .foregroundStyle(entry.completed ? .green : .accent)
                    .font(entry.completed ? .title : .largeTitle)
                    .padding(.trailing)
           
                VStack(alignment: .leading) {
                    Text(entry.todo ?? "")
                        .lineLimit(1)
                        .bold()
                    Text(entry.todo ?? "")
                        .lineLimit(2)
                        .font(.footnote)
                }.overlay {
                    NavigationLink {
                        EntryEditingView(entry: entry, navigationTitle: "Редактировать задачу", saveButtonName: "Сохранить")
                            .onDisappear{
                                presenter.isTyping = false
                            }
                    } label: {EmptyView() }.opacity(0)
                }
                Spacer()
                VStack{
                    Text(entry.dateMade?.formatted(date: .omitted, time: .shortened) ?? Date().formatted(date: .omitted, time: .shortened))
                    Text(entry.dateMade?.formatted(date: .numeric, time: .omitted) ?? Date().formatted(date: .numeric, time: .omitted))
                }
                .font(.caption2)
            }
        }
    }
}
