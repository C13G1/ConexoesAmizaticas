//
//  FriendsProfileView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI
import SwiftData

struct FriendsProfileView: View {
    @AppStorage("SetMetaOnboarding") var SetMetaOnboarding: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State var blurLevel: CGFloat = 0.0
    var viewModel: FriendProfileViewModel
    private let connectionID: UUID

    @Query private var connections: [Connection]
    @Query private var allUsers: [User]
    @State private var refreshToken = 0

    private var ownUser: User? {
        let friendIDs = Set(connections.map { $0.friend.id })
        return allUsers.first { !friendIDs.contains($0.id) }
    }

    private var lastMeetDaysText: String {
        guard let lastMet = viewModel.getLastMeet() else { return "nunca" }
        let days = Calendar.current.dateComponents([.day], from: lastMet, to: .now).day ?? 0
        if days == 0 { return "hoje" }
        return "há \(days) dias"
    }

    init(connection: Connection) {
        self.viewModel = FriendProfileViewModel(connection: connection)
        self.connectionID = connection.id
    }
    
    var body: some View {
            ZStack{
                ZStack{
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * 1.6)
                        .foregroundStyle(.friendProfileBackGround)
                        .padding(.top, (UIScreen.main.bounds.height * -0.49))
                    
                    VStack{
                        ZStack(alignment: .bottomTrailing) {
                            Image(uiImage: viewModel.getFriendImage() ??
                                  UIImage(named: "DefaultPicture")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 108, height: 108)
                                .clipShape(Circle())
                                .id(refreshToken)

                            NavigationLink(destination: EditFriendProfileView(connection: viewModel.connection)) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.white, .gray)
                            }
                        }
                        .padding(.top, 10)
                        
                        Text(viewModel.getFriendName().uppercased())
                            .font(.custom("Bolota", size: 48))
                            .padding(.top, 8)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 20.5){
                            TextedRoundedRectangle(text: "conectados há",
                                                   subText: "\(viewModel.getConnectionTime()) Dias",
                                                   subTextColor: viewModel.getProfileColor())
                            TextedRoundedRectangle(text: "ultimo encontro",
                                                   subText: lastMeetDaysText,
                                                   subTextColor: viewModel.getProfileColor())
                            TextedRoundedRectangle(text: "promeça",
                                                   subText: viewModel.getMeta().displayText,
                                                   subTextColor: viewModel.getProfileColor())
                        }
                        
                        if viewModel.getTimeUntilMeet() < 0 {
                            TextedRoundedRectangle(width: 351,height: 77,
                                                   text: "vocês prometeram se encontrar dentro de",
                                                   textSize: 15,subText: "\(viewModel.getTimeUntilMeet() * -1) dias atrasados",
                                                   subTextSize: 36,
                                                   subTextColor: viewModel.getProfileColor())
                        }
                        else {
                            TextedRoundedRectangle(width: 351,height: 77,text: "vocês prometeram se encontrar dentro de", textSize: 15,
                                                   subText: "\(viewModel.getTimeUntilMeet()) dias",
                                                   subTextSize: 36,
                                                   subTextColor: viewModel.getProfileColor())
                        }
                        
                        NavigationLink(destination: BLEView(profile: ownUser ?? User())) {
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
                            .padding(.top, 35)
                        
                        Spacer()
                        
                        PictureScroll(viewModel: FriendFeedViewModel(connection: viewModel.connection))
                    }
                    if SetMetaOnboarding {
                        Rectangle()
                            .frame(width: .infinity,
                                   height: .infinity)
                            .opacity(0.6)
                            .ignoresSafeArea(.all)
                    }
                }
                .background(Color.black)
                .blur(radius: blurLevel)
                .onAppear {
                    if SetMetaOnboarding{
                        blurLevel = 5
                    }
                    else {
                        blurLevel = 0
                    }
                }
                if SetMetaOnboarding {
                    VStack{
                        Text("novo amigo\nadicionado!")
                            .font(.custom("Bolota", size: 32))
                            .foregroundStyle(.friendProfileBackGround)
                        
                        Text("altere a sua meta com\n\(viewModel.getFriendName()) aqui!")
                            .font(.custom("Sora", size: 20))
                            .foregroundStyle(.friendProfileBackGround)
                            .multilineTextAlignment(.center)
                            .padding(.top, 12)
                    }
                    .padding(.bottom, UIScreen.main.bounds.height * 0.0985)
                }
            }
            .environment(\.colorScheme, .light)
            .onReceive(NotificationCenter.default.publisher(for: .friendProfileUpdated)) { _ in
                refreshToken += 1
            }
            .onChange(of: connections) { _, newConnections in
                if !newConnections.contains(where: { $0.id == connectionID }) {
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: SetMetaView(viewModel: viewModel)) {
                        ZStack{
                            if SetMetaOnboarding{
                                Circle()
                                    .frame(height: UIScreen.main.bounds.height * 0.063)
                                    .foregroundStyle(.white)
                            }
                            Image(systemName: "gear")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
    }
}

#Preview {
    let c = Connection(friend: User(name: "Juliana"))
    FriendsProfileView(connection: c)
}
