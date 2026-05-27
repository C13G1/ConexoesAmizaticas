//
//  BLEView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import SwiftUI
import CoreBluetooth

struct BLEView: View {
    @State var bleManager: BLEManager!
    @State var friend: User! = User()
    @State var foundFriend: Bool = true
    let profile: User!
    
    var body: some View {
        VStack {
            if foundFriend {
                VStack{
                    ZStack {
                        Circle()
                            .frame(width: 148, height: 148)
                            .foregroundStyle(.themeYellow)
                        Image(uiImage: UIImage(data: friend.profilePicture)!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 132, height: 132)
                    }
                    .position(x: UIScreen.main.bounds.midX, y: 108)
                    Text("Parece que você e \(self.friend.name) se encontraram!")
                        .font(.custom("Sora-ExtraBold", size: 28))
                        .frame(width: 250)
                        .multilineTextAlignment(.center)
                        .lineHeight(.exact(points: 34))
                        .position(x: UIScreen.main.bounds.midX, y: 103)
                    Text("pressione e segure para confirmar encontro.")
                        .font(.custom("Sora-Regular", size: 20))
                        .multilineTextAlignment(.center)
                        .lineHeight(.exact(points: 34))
//                        .position(x: UIScreen.main.bounds.midX, y: 10)
                    Button(action: {
                        bleManager.startBLE()
                    }, label: {
                        Text("Procurar por outra pessoa")
                            .font(.custom("Sora-Bold", size: 14))
                            .foregroundStyle(.themeEstaveis)
                            .lineHeight(.exact(points: 34))
                    })
                    .position(x: UIScreen.main.bounds.midX, y: 0)
                }
            }
            else {
                Text("Buscando contatos por perto...")
                    .font(.custom("Sora-ExtraBold", size: 28))
                    .multilineTextAlignment(.center)
                    .lineHeight(.exact(points: 34))
                    .frame(width: 270)
                    .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            }
            Button(action: {
                
            }, label: {
                ZStack {
                    Circle()
                        .frame(width: 148, height: 148)
                        .foregroundStyle(.themeYellow)
                    Image(uiImage: UIImage(data: profile.profilePicture)!)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 132, height: 132)
                }
            })
        }
        .onAppear() {
            self.bleManager = BLEManager(view: self)
            self.startSearching()
        }
    }
    func updateFriend(_ friend: User) {
        self.friend = friend
    }
    func startSearching() {
//        self.friend = nil
        bleManager.startBLE()
    }
}

#Preview {
    BLEView(profile: User())
}
