//
//  VacuoView.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 24/05/26.
//

import SwiftUI

// TODO: IMPLEMENTAR BOLHAS NO VÁCUO
struct VacuoView: View {
    @Environment(\.dismiss) var dismiss
    @State var focusedConnection: Connection!
    
    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, -0.9)
                    
                    Image("void")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04)
                        .padding(.top, 30)
                    
                    Spacer()
                    
                    Text("Você não tem nenhum\namigo no vácuo")
                        .font(.custom("Sora-Regular", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: 300)
                        .padding(.bottom, 40)
                }
            }
            .background(
                ZStack {
                    Color.vacuoBackground
                    Image("vacuo")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 1.7, height: UIScreen.main.bounds.height * 0.65)
                        .padding(.trailing, UIScreen.main.bounds.width * 0.15)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.025)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            )
            .blur(radius: focusedConnection != nil ? 10 : 0)
                        
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
