//
//  FriendsProfileView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI

struct FriendsProfileView: View {
    var viewModel : FriendProfileViewModel
    
    init(connection: Connection){
        self.viewModel = FriendProfileViewModel(connection: connection)
    }
    
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 623)
                .foregroundStyle(.friendProfileBackGround)
                .padding(.top, (UIScreen.main.bounds.height * -0.44))
            VStack{
                Image(uiImage: viewModel.getFriendImage() ??
                      UIImage(named: "DefaultPicture")!)
                .resizable()
                .scaledToFill()
                .frame(width: 108, height: 108)
                .clipShape(Circle())
                .padding(.top,10)
                
                Text(viewModel.getFriendName().uppercased())
                    .font(.custom("Bolota", size: 48))
                    .padding(.top, 22)
                    .fontWeight(.semibold)
                
                HStack(spacing: 20.5){
                    TextedRoundedRectangle(text: "conectados há",
                                           subText: "\(viewModel.getConnectionTime()) Dias",
                                           subTextColor: viewModel.getProfileColor())
                    TextedRoundedRectangle(text: "ultimo encontro",
                                           subText: "há \(String(describing: viewModel.getLastMeet())) Dias",
                                           subTextColor: viewModel.getProfileColor())
                    TextedRoundedRectangle(text: "promeça",
                                           subText: viewModel.getMeta().rawValue,
                                           subTextColor: viewModel.getProfileColor())
                }
                if viewModel.getTimeUntilMeet() < 0 {
                    TextedRoundedRectangle(width: 351,height: 77,
                                           text: "vocês prometeram se encontrar dentro de",
                                           textSize: 15,subText: "\(viewModel.getTimeUntilMeet() * -1) dias atrasados",
                                           subTextSize: 40,
                                           subTextColor: viewModel.getProfileColor())
                }
                else {
                    TextedRoundedRectangle(width: 351,height: 77,text: "vocês prometeram se encontrar dentro de", textSize: 15,
                                           subText: "\(viewModel.getTimeUntilMeet()) dias",
                                           subTextColor: viewModel.getProfileColor())
                }
                
                NavigationLink(destination: BLEView(profile: viewModel.connection.friend)) {
                    ZStack{
                        HStack(spacing: -40){
                            CurvedRectangle(depth: 2)
                                .stroke(viewModel.getProfileColor(),
                                        style: StrokeStyle(
                                            lineWidth: 5,
                                            lineCap: .round
                                        )
                                )
                                .frame(width: UIScreen.main.bounds.height * 0.0957,
                                       height: UIScreen.main.bounds.width * 0.0741)
                                .rotationEffect(Angle(degrees: 90))
                            Ellipse()
                                .frame(width: UIScreen.main.bounds.width * 0.623,
                                       height: UIScreen.main.bounds.height * 0.123)
                                .foregroundStyle(viewModel.getProfileColor())
                            CurvedRectangle(depth: 2)
                                .stroke(viewModel.getProfileColor(),
                                        style: StrokeStyle(
                                            lineWidth: 5,
                                            lineCap: .round
                                        )
                                )
                                .frame(width: UIScreen.main.bounds.height * 0.0957,
                                       height: UIScreen.main.bounds.width * 0.0741)
                                .rotationEffect(Angle(degrees: -90))
                        }
                        Text("registrar\num momento")
                            .font(.custom("Bolota", size: 24))
                            .foregroundStyle(.white)
                        
                    }
                }
                
                
                AddPictureButton(viewModel: FriendFeedViewModel(connection: viewModel.connection))
                    .padding(.top, 30)
                
                Spacer()
                
                PictureScroll(viewModel: FriendFeedViewModel(connection: viewModel.connection))
            }
        }
        .background(Color.black)
    }
}

#Preview {
    let c = Connection(friend: User(name: "Juliana"))
    FriendsProfileView(connection: c)
}
