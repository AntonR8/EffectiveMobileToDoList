//
//  ListElementView.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import SwiftUI

struct ListElementView: View {
    let id: Int
    let todo: String
    @State var completed: Bool
    let userID: Int
    let dateMade: Date

    var body: some View {
        HStack {
            Button(action: {
                completed.toggle()
            }, label: {
                Image(systemName: completed ? "checkmark.circle" : "circlebadge")
                    .foregroundStyle(completed ? .green : .primary)
                    .font(completed ? .title : .largeTitle)
            })
            .padding(.trailing)
            VStack(alignment: .leading) {
                Text(todo)
                    .lineLimit(1)
                    .bold()
                Text(todo)
                    .lineLimit(2)
                    .font(.footnote)
            }
            Spacer()
            Divider()
            VStack{
                Text(dateMade.formatted(date: .omitted, time: .shortened))
                Text(dateMade.formatted(date: .numeric, time: .omitted))
            }
            .font(.caption2)
        }
    }
}

#Preview {
    ListElementView(id: 1, todo: "Do something nice for someone you care about", completed: true, userID: 1, dateMade: Date())
}
