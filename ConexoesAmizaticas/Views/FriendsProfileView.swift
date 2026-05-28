//
//  FriendsProfileView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI
import SwiftData

struct FriendsProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("SetMetaOnboarding") var SetMetaOnboarding: Bool = false
    @State var blurLevel: CGFloat = 0.0
    
    var viewModel : FriendProfileViewModel
    @State private var feedViewModel: FriendFeedViewModel
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    init(connection: Connection){
        self.viewModel = FriendProfileViewModel(connection: connection)
        self._feedViewModel = State(initialValue: FriendFeedViewModel(connection: connection))
    }
    
    var body: some View {
        ZStack {
            ZStack {
                PictureScroll(viewModel: feedViewModel)
                    .padding(.top, height * 0.55)
                
                Circle()
                    .frame(width: width * 1.6)
                    .foregroundStyle(.friendProfileBackGround)
                    .padding(.top, (height * -0.6))
                
                VStack(spacing: 4) {
                    Image(uiImage: viewModel.getFriendImage() ?? UIImage(named: "DefaultPicture")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipShape(Circle())
                        .padding(.top)
                    
                    Text(viewModel.getFriendName().uppercased())
                        .font(.custom("Bolota", size: 48))
                        .padding(.top, 8)
                        .frame(width: width * 0.8)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 20.5) {
                        TextedRoundedRectangle(text: "conectados há", textSize: 12, textWeight: .thin, subText: "\(viewModel.getConnectionTime()) Dias", subTextWeight: .black, subTextColor: viewModel.getProfileColor(), isTwelve: true)
                        
                        TextedRoundedRectangle(text: "último encontro", textSize: 12, textWeight: .thin, subText: "há \(String(describing: viewModel.getLastMeet())) Dias", subTextSize: 20, subTextWeight: .black, subTextColor: viewModel.getProfileColor(), isTwelve: true)
                        
                        TextedRoundedRectangle(text: "promessa", textSize: 12, textWeight: .thin, subText: viewModel.getMeta().rawValue, subTextSize: 20, subTextWeight: .black, subTextColor: viewModel.getProfileColor(), isTwelve: true)
                    }
                    
                    if viewModel.getTimeUntilMeet() < 0 {
                        TextedRoundedRectangle(width: 351, height: 77, text: "vocês prometeram se encontrar dentro de", textSize: 12, textWeight: .thin, subText: "\(viewModel.getTimeUntilMeet() * -1) dias", subTextSize: 36, subTextColor: viewModel.getProfileColor(), isTwelve: false)
                    } else {
                        TextedRoundedRectangle(width: 351, height: 77, text: "vocês prometeram se encontrar dentro de", textSize: 15, subText: "\(viewModel.getTimeUntilMeet()) dias", subTextSize: 36, subTextColor: viewModel.getProfileColor(), isTwelve: false)
                    }
                    
                    NavigationLink(destination: BLEView(profile: viewModel.connection.friend)) {
                        ZStack {
                            HStack(spacing: -45) {
                                CurvedRectangle(depth: 2)
                                    .stroke(viewModel.getProfileColor(), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                    .frame(width: height * 0.0957, height: width * 0.0741)
                                    .rotationEffect(Angle(degrees: 90))
                                
                                Ellipse()
                                    .frame(width: width * 0.623, height: height * 0.123)
                                    .foregroundStyle(viewModel.getProfileColor())
                                
                                CurvedRectangle(depth: 2)
                                    .stroke(viewModel.getProfileColor(), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                    .frame(width: height * 0.0957, height: width * 0.0741)
                                    .rotationEffect(Angle(degrees: -90))
                            }
                            Text("registrar\num momento")
                                .font(.custom("Bolota", size: 24))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    AddPictureButton(viewModel: feedViewModel, color: viewModel.getProfileColor())
                        .padding(.top, 35)
                }
                .padding(.bottom, height * 0.3)
                
                if SetMetaOnboarding {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(0.6)
                        .ignoresSafeArea(.all)
                }
            }
            .background(Color.black)
            .blur(radius: blurLevel + (feedViewModel.postToDelete != nil ? 10 : 0))
            .onAppear {
                blurLevel = SetMetaOnboarding ? 5 : 0
            }
            
            if SetMetaOnboarding {
                VStack {
                    Text("novo amigo\nadicionado!")
                        .font(.custom("Bolota", size: 32))
                        .foregroundStyle(.friendProfileBackGround)
                    Text("altere a sua meta com\n\(viewModel.getFriendName()) aqui!")
                        .font(.custom("Sora", size: 20))
                        .foregroundStyle(.friendProfileBackGround)
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                }
                .padding(.bottom, height * 0.0985)
            }
            
            if let post = feedViewModel.postToDelete {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { feedViewModel.postToDelete = nil }
                    }
                
                VStack {
                    ZStack {
                        Circle()
                            .foregroundStyle(.red)
                            .frame(width: 140, height: 140)
                        
                        if let data = post.images.first, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 132, height: 132)
                        }
                    }
                    
                    Text("QUER MESMO DELETAR ESTE MOMENTO?")
                        .foregroundStyle(.white)
                        .font(.custom("Bolota", size: 24))
                        .fontWeight(.bold)
                        .frame(width: 280)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                    
                    Text("Esta ação é permanente e a foto será apagada da conexão.")
                        .font(.custom("Sora-Regular", size: 12))
                        .foregroundStyle(.white)
                        .frame(width: 206)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    
                    HStack(spacing: 50) {
                        Button {
                            withAnimation { feedViewModel.postToDelete = nil }
                        } label: {
                            ZStack {
                                Circle().foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                                Image(systemName: "xmark")
                                    .resizable().frame(width: 32, height: 32)
                                    .foregroundStyle(.white).bold()
                            }
                        }
                        .frame(width: 72, height: 72)
                        
                        Button {
                            if let id = feedViewModel.postToDelete?.id {
                                feedViewModel.deletePost(id: id, modelContext: modelContext)
                            }
                            withAnimation { feedViewModel.postToDelete = nil }
                        } label: {
                            ZStack {
                                Circle().foregroundStyle(.white)
                                Image(systemName: "trash")
                                    .resizable().frame(width: 32, height: 32)
                                    .foregroundStyle(.red).bold()
                            }
                        }
                        .frame(width: 72, height: 72)
                    }
                    .padding(.top, 40)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: SetMetaView(viewModel: viewModel)) {
                    ZStack {
                        if SetMetaOnboarding {
                            Circle()
                                .frame(height: height * 0.063)
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
    let mockConnection: Connection = {
        let mockImage = UIImage(named: "gallery") ?? UIImage()
        let mockData = mockImage.pngData() ?? Data()
        let c = Connection(friend: User(name: "Juliana"))
        
        for _ in 0..<5 {
            let post = Post(images: [mockData])
            c.feedManager.addPost(post)
        }
        
        return c
    }()

    return FriendsProfileView(connection: mockConnection)
}
