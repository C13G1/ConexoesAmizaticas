//
//  AddFriendSheetView.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 22/05/26.
//

import SwiftUI

struct AddFriendSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Como você quer\nadicionar seu amigo?")
                .font(.custom("Sora-ExtraBold", size: 28))
                .kerning(0.38)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 344)
                .padding(.bottom, 61)
            
            VStack(spacing: 40) {
                VStack(spacing: 10) {
                    Image(systemName: "person.2.wave.2.fill")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("por aproximação")
                        .font(.custom("Sora-SemiBold", size: 16))
                        .foregroundColor(.addFriendsText)
                }
                .frame(width: 292, height: 160)
                .background(Color.addFriendsCard)
                .cornerRadius(38)
                
                VStack(spacing: 10) {
                    Image(systemName: "bubble.and.pencil")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("digitando informações")
                        .font(.custom("Sora-SemiBold", size: 16))
                        .foregroundColor(.addFriendsText)
                }
                .frame(width: 292, height: 160)
                .background(Color.addFriendsCard)
                .cornerRadius(38)
            }
            .padding(.horizontal, 51)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.addFriendsSheet)
        .navigationTitle("Adicionar amigo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct AddFriendSheetPreview: View {
    @State private var showSheet = false
    
    var body: some View {
        Button("Abrir Sheet") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                AddFriendSheetView()
            }
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    AddFriendSheetPreview()
}
