//
//  BLEView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import SwiftUI
import CoreBluetooth

struct BLEView: View {
    @State var bleManager: BLEManager?
    @State var friend: User = User()
    
    var body: some View {
        VStack {
            MockUserView(user: $friend)
            Button(action: {
                if let bleManager = bleManager {
                    do {
                        try bleManager.sendProfile()
                    }
                    catch {
                        print("uuuhhhh...")
                    }
                }
            }, label: {
                Text("Find Friend")
            })
            .frame(width: 200, height: 80, alignment: .center)
            .clipShape(.capsule)
            .foregroundStyle(.blue)
        }
        .onAppear() {
            self.bleManager = BLEManager(view: self)
        }
    }
    func updateFriend(_ friend: User) {
        self.friend = friend
    }
}

#Preview {
    BLEView()
}
