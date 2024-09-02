//
//  NewEntryView.swift
//  EffectiveMobileToDoList
//
//  Created by АнтохаПрограммист on 01.09.2024.
//

import SwiftUI

struct EntryEditingView: View {
    @EnvironmentObject var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let entry: ToDoListEntity?
    @Binding var navigationPath: NavigationPath
    
    @FocusState var titleEditing: Bool
    @State var textFieldtext = ""
    var navigationTitle: String
    var saveButtonName: String
    
    var body: some View {
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
                            }
                            if let entry {
                                textFieldtext = entry.todo ?? ""
                            }
                        }
                    Spacer()
                    Button(action: {
                        if let entry {
                            vm.resaveEntry(entry: entry, todo: textFieldtext)
                        } else {
                            vm.createNewEntry(todo: textFieldtext)
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
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EntryEditingView(entry: nil, navigationPath: .constant(NavigationPath()), navigationTitle: "sds", saveButtonName: "dfv")
        .environmentObject(ViewModel())
}
