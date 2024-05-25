//
//  ContentView.swift
//  WordleApp
//
//  Created by Riley Koo on 5/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView(game: game())
    }
}

#Preview {
    ContentView()
}
