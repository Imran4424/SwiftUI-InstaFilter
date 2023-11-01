//
//  HomeView.swift
//  InstaFilter
//
//  Created by Shah Md Imran Hossain on 28/10/23.
//

import SwiftUI

struct HomeView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            Spacer()
            
            image?
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            Button("Select Image Picker") {
                showingImagePicker = true
            }
            
            Button("Save Image") {
                guard let inputImage = inputImage else {
                    print("Input image is nil")
                    return
                }
                
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) {
            loadImage()
        }
    }
}

// MARK: - Methods
extension HomeView {
    func loadImage() {
        guard let inputImage = inputImage else {
            print("Input image is nil")
            return
        }
        
        image = Image(uiImage: inputImage)
        
        
    }
}

#Preview {
    HomeView()
}
