//
//  SearchView.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 25/05/26.
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel: InicialViewModel?
    @State private var friends: [User] = []
    
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    var searchResults: [User] {
        if searchText.isEmpty {
            return []
        } else {
            let results = friends.filter { friend in
                friend.name.localizedStandardContains(searchText)
            }
            
            return results
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(searchResults) { friend in
                        //                        NavigationLink(destination: PerfumeView(perfume: perfume)) {
                        //                            Text(perfume.name)
                        //                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onAppear {
                viewModel = InicialViewModel(modelContext: modelContext)
                viewModel?.fetchData()
                friends = viewModel!.getFriends()
            }
        }
    }
}

#Preview {
    SearchView()
        .modelContainer(for: [
            User.self,
            Post.self,
            FeedManager.self,
            Connection.self,
            MetaManager.self,
        ])
}
