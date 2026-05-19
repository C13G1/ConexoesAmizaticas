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
    @State var friend: User?
    
    var body: some View {
        VStack {
            
            Button(action: {}, label: {
                Text("Find Friend")
            })
            .frame(width: 200, height: 80, alignment: .center)
            .clipShape(.capsule)
            .foregroundStyle(.blue)
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if let bleManager = bleManager {
                        bleManager.startBLE()
                    }
                })
                    .onEnded({ _ in
                        if let bleManager = bleManager {
                            bleManager.stopBLE()
                        }
                    }))
        }
        .onAppear() {
            self.bleManager = BLEManager(view: self)
        }
    }
}

#Preview {
    BLEView()
}
