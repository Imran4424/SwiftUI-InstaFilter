//
//  HomeView.swift
//  InstaFilter
//
//  Created by Shah Md Imran Hossain on 28/10/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct HomeView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundStyle(Color.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    // select an image
                    showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _, _ in
                            applyProcessing()
                        }
                }
                .padding()
                
                HStack {
                    Button("Change Filter") {
                        
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        save()
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("InstaFilter")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) {
                loadImage()
            }
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
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
    
    func save() {
        guard let inputImage = inputImage else {
            print("Input image is nil")
            return
        }
        
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
    }
}

#Preview {
    HomeView()
}
