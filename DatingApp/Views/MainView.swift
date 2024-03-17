//
//  MainView.swift
//  DatingApp
//
//  Created by Frank on 3/13/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            GroupListContainerView().tabItem {
                Label("Chats", systemImage: "message.fill")
            }
            SettingsView().tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    MainView()
}
