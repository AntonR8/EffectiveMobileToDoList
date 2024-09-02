//
//  NewEntryView.swift
//  EffectiveMobileToDoList
//
//  Created by АнтохаПрограммист on 01.09.2024.
//

import SwiftUI

struct EntryEditingView: View {
    @EnvironmentObject var presenter: Presenter
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let entry: ToDoListEntity?
    
    @FocusState var titleEditing: Bool
    @State var textFieldtext = ""
   

    var navigationTitle: String
    var saveButtonName: String
    
    var body: some View {

        NavigationView {
            ZStack {
                    LinearGradient(colors: [.accentColor, .accentColor.opacity(0.3)], startPoint: .bottom, endPoint: .top)
                        .ignoresSafeArea()
                    VStack {
                        TextEditor(text: $textFieldtext)
                            .focused($titleEditing)
                            .scrollContentBackground(.hidden)
                            .frame(maxHeight: .infinity)
                            .padding()
                            .onAppear {
                                DispatchQueue.main.async {
                                    self.titleEditing = true
                                    presenter.isTyping = true
                                }
                                if let entry {
                                    textFieldtext = entry.todo ?? ""
                                }
                            }
                        Spacer()
                        Button(action: {
                            if let entry {
                                presenter.resaveEntry(entry: entry, todo: textFieldtext)
                            } else {
                                presenter.createNewEntry(todo: textFieldtext)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text(saveButtonName)
                                .font(.headline)
                                .foregroundColor(.primary)
                        })
                        .buttonStyle(.bordered)
                        .padding(40)
                    }
                }
                .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode((navigationTitle == "Сохранить") ? .automatic : .inline)
        }
    }
}

#Preview {
    EntryEditingView(entry: nil, navigationTitle: "Новая заметка", saveButtonName: "Сохранить")
        .environmentObject(Presenter(interactor: Interactor()))
}
