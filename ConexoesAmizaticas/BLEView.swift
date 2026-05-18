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
    
    var body: some View {
        ZStack {
            Button(action: {}, label: {
                Text("Find Friend")
            })
            .frame(width: 200, height: 80, alignment: .center)
            .clipShape(.capsule)
            .foregroundStyle(.blue)
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    bleManager.startBLE()
                })
                    .onEnded({ _ in
                        bleManager.stopBLE()
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
