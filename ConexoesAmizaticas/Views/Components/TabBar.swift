//
//  TabBar.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI

struct TabBar: View {
    @Binding var viewModel: InicialViewModel
    var user: User
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            SemiCircle()
                .fill(Color.black)
                .frame(width: width, height: 100)
            
            HStack {
                NavigationLink {
                    SearchView(viewModel: $viewModel)
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: width * 0.15)
                            .foregroundStyle(.lightBackground)
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.black)
                            .font(.largeTitle)
                            .bold()
                    }
                    .frame(width: width * 0.19, height: height * 0.19)
                    .background(.black)
                    .cornerRadius(100)
                }
                
                Spacer()
                
                Image("zELu")
                    .padding(.bottom, height * 0.07)
                
                Spacer()
                
                NavigationLink (destination: BLEView(profile: user)) {
                    ZStack {
                        Circle()
                            .frame(width: height * 0.15)
                            .foregroundStyle(.lightBackground)
                        Image(systemName: "person.2.badge.plus.fill")
                            .foregroundStyle(.black)
                            .font(.title2)
                    }
                    .frame(width: width * 0.19, height: width * 0.19)
                    .background(.black)
                    .cornerRadius(100)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, width * 0.38)
        }
    }
}
