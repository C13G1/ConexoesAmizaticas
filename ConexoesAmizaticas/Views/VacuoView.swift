//
//  VacuoView.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 24/05/26.
//

import SwiftUI

struct VacuoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showInfo = false
    
    var body: some View {
        ZStack {
            Color.vacuoBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: { showInfo = true }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                Spacer()
                    .frame(height: 97)
                
                Text("VÁCUO")
                    .font(.custom("Sora-ExtraBold", size: 40))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image("vacuo")
                    .frame(width: 280, height: 280)
                
                Spacer()
                
                Text("Você não tem nenhum\namigo no vácuo")
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(maxWidth: 300)
                    .padding(.bottom, 40)
            }
            
            if showInfo {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { showInfo = false }
                    
                    VStack {
                        HStack {
                            Text("Informações")
                                .font(.custom("Sora-SemiBold", size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: { showInfo = false }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(20)
                        
                        Text("Esta é a tela de vácuo. Aqui você pode adicionar mais informações sobre o conceito.")
                            .foregroundColor(.white)
                            .padding(20)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                }
            }
        }
    }
}

#Preview {
    VacuoView()
}
