//
//  SearchView.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 25/05/26.
//

import SwiftData
import SwiftUI

struct SearchView: View {

    @Binding var viewModel: InicialViewModel
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    var searchResults: [Connection] {
        if searchText.isEmpty {
            return []
        } else {
            let results = viewModel.connectionsWithFriends.filter { c in
                c.friend.name.localizedStandardContains(searchText)
            }
            
            return results
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(searchResults) { friend in
                        NavigationLink(destination: FriendsProfileView()) {
                            Text(friend.name)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
        }
    }
}

#Preview {
    @Previewable @State var viewModel = InicialViewModel()
    SearchView(viewModel: $viewModel)
        .modelContainer(for: [
            User.self,
            Post.self,
            FeedManager.self,
            Connection.self,
            MetaManager.self,
        ])
}
