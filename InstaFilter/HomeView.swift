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
    @State private var processedImage: UIImage?
    
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    
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
                        showingFilterSheet = true
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
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crytallize") { setFilter(filter: CIFilter.crystallize()) }
                Button("Edges") { setFilter(filter: CIFilter.edges()) }
                Button("Crytallize") { setFilter(filter: CIFilter.crystallize()) }
                Button("Gaussian Blur") { setFilter(filter: CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(filter: CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(filter: CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(filter: CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(filter: CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
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
    
    func setFilter(filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
        processedImage = uiImage
    }
    
    func save() {
        guard let processedImage = processedImage else {
            print("Processed Image is nil")
            return
        }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success! Image saved successfully")
        }
        
        imageSaver.errorHandler = {
            print("Opps! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
}

#Preview {
    HomeView()
}
