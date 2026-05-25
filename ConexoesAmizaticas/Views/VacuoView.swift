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
    @State var focusedConnection: Connection!
    
    var body: some View {
        
        ZStack {
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
            }
            .background(.vacuoBackground)
            .blur(radius: focusedConnection != nil ? 10 : 0)
            ZStack {
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
            ZStack {
                if let focusedConnection = focusedConnection {
                    Rectangle()
                        .ignoresSafeArea()
                        .opacity(0.6)
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundStyle(.red)
                                .frame(width: 140, height: 140)
                            Image(uiImage: UIImage(data: focusedConnection.friend.profilePicture)!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 132, height: 132)
                        }
                        Text("Você deixou \(focusedConnection.friend.name) no vácuo")
                            .padding(.top, 16)
                            .font(.custom("Sora-Bold", size: 16))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        Text("QUER RESGATAR ESSE CONTATO?")
                            .foregroundStyle(.white)
                            .font(.custom("Bolota", size: 24))
                            .fontWeight(.bold)
                            .frame(width: 222)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                        Text("Contatos ficam no vácuo por até 30 dias. Depois disso, a conexão é perdida e será preciso recomeçar do zero.")
                            .font(.custom("Sora-Light", size: 12))
                            .foregroundStyle(.white)
                            .frame(width: 206)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                        HStack {
                            Button(action: {
                                self.focusedConnection = nil
                            }, label: {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.themeAfastados)
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                            })
                            .frame(width: 72, height: 72)
                            
                            Button(action: {
                                self.focusedConnection = nil
                            }, label: {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.white)
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(.black)
                                        .bold()
                                }
                            })
                            .frame(width: 72, height: 72)
                            .padding(.leading, 128)
                        }
                        .padding(.top, 67)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    func resgatarContato() {
        // TODO: IMPLEMENTAR
    }
}

#Preview {
    VacuoView(focusedConnection: Connection(friend: User(profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)))
}
