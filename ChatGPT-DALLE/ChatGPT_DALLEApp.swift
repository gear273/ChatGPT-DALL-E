//
//  ChatGPT_DALLEApp.swift
//  ChatGPT-DALLE
//
//  Created by Caleb Hrenchir on 6/12/23.
//

import SwiftUI

@main
struct ChatGPT_DALLEApp: App {
    let dalleViewModel = DalleViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dalleViewModel)
        }
    }
}
