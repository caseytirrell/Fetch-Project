//
//  ContentView.swift
//  Fetch Project
//
//  Created by Casey tirrell on 5/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MealsView(viewModel: MealsViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
