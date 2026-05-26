//
//  FriendsProfileView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI

struct FriendsProfileView: View {
    var viewModel = FriendProfileViewModel(connection: Connection(friend: User(name: "Juliana")))
    
    init(){
        viewModel.setRecordTimeNotMeeting()
    }
    var body: some View {
        VStack{
            Image(uiImage: viewModel.getFriendImage() ??
                  UIImage(named: "DefaultPicture")!)
            .resizable()
            .scaledToFill()
            .frame(width: 108, height: 108)
            .clipShape(Circle())
            .padding(.top,10)
            
            Text(viewModel.getFriendName())
                .font(.system(size: 48))
                .padding(.top, 22)
                .fontWeight(.semibold)
            
            HStack(spacing: 20){
                TextedRoundedRectangle(text: "conectados há",
                                       subText: "há \(String(describing: viewModel.getConnectionTime())) Dias")
                TextedRoundedRectangle(text: "ultimo encontro",
                                       subText: "há \(String(describing: viewModel.getLastMeet())) Dias")
            }
            TextedRoundedRectangle(width: 350,text: "maior tempo sem se encontrar", subText: "\(viewModel.getRecordTimeNotMeeting()) dias")
        
            TextedRoundedRectangle(width: 350,text: "maior tempo sem se encontrar", subText: "\(viewModel.getRecordTimeNotMeeting()) dias")
            NavigationLink(destination: BLEView(profile: viewModel.connection.friend)) {
                TextedRoundedRectangle(width: 351, height: 91,
                                       text: "registrar encontro",
                                       textSize: .system(size: 24),
                                       textWeight: .black)
                .clipShape(ConcaveShape())
            }
        }
        Spacer()
    }
}

#Preview {
    FriendsProfileView()
}
