//
//  PlusButtonView.swift
//  EffectiveMobileToDoList
//
//  Created by АнтохаПрограммист on 01.09.2024.
//

import SwiftUI

struct PlusButtonView: View {
    @EnvironmentObject var vm: ViewModel
  
    var body: some View {
        Button (action:{
            withAnimation(.easeInOut) {
                vm.createNewEntry = true
            }
        }, label: {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .padding()
                .background(
                    Circle()
                        .fill(.accent.gradient)
                )
        })
    }
}

#Preview {
    PlusButtonView()
        .environmentObject(ViewModel())
}
