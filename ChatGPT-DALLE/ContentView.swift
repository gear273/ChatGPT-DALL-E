//
//  ContentView.swift
//  ChatGPT-DALLE
//
//  Created by Caleb Hrenchir on 6/12/23.
//

import UIKit
import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            TabView {
                GPT3View().tabItem {
                    Label("CHAT", systemImage: "ellipses.bubble")
                }
                
                DalleView().tabItem {
                    Label("DALL-E 2", systemImage: "paintbrush")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
