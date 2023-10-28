//
//  HomeView.swift
//  InstaFilter
//
//  Created by Shah Md Imran Hossain on 28/10/23.
//

import SwiftUI

struct HomeView: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
}

// MARK: - Methods
extension HomeView {
    func loadImage() {
        image = Image("batman")
    }
}

#Preview {
    HomeView()
}
