//
//  ContentView.swift
//  project13
//
//  Created by Sc0tt on 31/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.1
    
    @State private var showingFilterSheet = false
    @State private var showingImagePicker = false
    @State private var showingError = false

    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var filterName = "Sepia Tone"
    
    @State var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        let intensity = Binding<Double> (
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        let radius = Binding<Double> (
            get: {
                self.filterRadius
        },
            set: {
                self.filterRadius = $0
                self.applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }
                .padding(.vertical)
                HStack {
                    Text("Radius")
                    Slider(value: radius)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Filter: \(filterName)") {
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedImage = self.processedImage else {
                            //print("No image")
                            self.showingError.toggle()
                            return
                        }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        
                        imageSaver.errorHandler = {
                            print("Oops: \($0.localizedDescription)")
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) {
                        self.setFilter(CIFilter.crystallize())
                        self.filterName = "Crystallize" } ,
                    .default(Text("Edges")) {
                        self.setFilter(CIFilter.edges())
                        self.filterName = "Edges" },
                    .default(Text("Guassian Blur")) { self.setFilter(CIFilter.gaussianBlur())
                        self.filterName = "Guassian Blur" },
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate())
                        self.filterName = "Pixellate" },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone())
                        self.filterName = "Sepia Tone" },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask())
                        self.filterName = "Unsharp Mask" },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette())
                        self.filterName = "Vignette" },
                    .cancel()
                ])
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text("Error Saving"), message: Text("Please select a photo first!"), dismissButton: .default(Text("Dismiss")))
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage
            else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
