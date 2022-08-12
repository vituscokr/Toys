//
//  ContentView.swift
//  Toys
//
//  Created by Gyeongtae Nam on 2022/08/12.
//

import SwiftUI

extension View {
    func snapshot() -> NSImage? {
        let controller = NSHostingController(rootView: self)
        let targetSize = controller.view.intrinsicContentSize
        let contentRect = NSRect(origin: .zero, size: targetSize)
        
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.contentView = controller.view
        
        guard
            let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
        else { return nil }
        
        controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
        let image = NSImage(size: bitmapRep.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}


struct ContentView: View {
    

    @State var title:String = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var count = 0
    
    @State var topImage : NSImage = NSImage()
    @State var bottomImage : NSImage = NSImage()
    
    
    var numberView : some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black )
            Text(title)
                .font(.custom("BM Dohyeon", size: 280))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.top, 0)
            
            
            
        }
        .frame(width: 400, height:400)
        .background(Color.clear)
        .onAppear {
            title = String(format: "%02d", count)
        }
    }
    
    
    var numberTopView : some View {

        
        ZStack (alignment: .top, content: {
            numberView
        })
        .frame(width: 400, height: 200, alignment: .top)
        .clipped()
    }
    
    var numberBottomView : some View {

        
        ZStack (alignment: .bottom, content: {
            numberView
        })
        .frame(width: 400, height: 200, alignment: .bottom)
        .clipped()
    }
    var body: some View {
        
        NavigationView {
            
            VStack(spacing:0) {
                
                numberTopView
                numberBottomView
              //  numberView
//                Button {
//
//                } label: {
//                   Text("Save")
//                }

            }
//            .onReceive(timer) { value  in
//
//                if count < 61 {
//
//                    count = count + 1
//                    save()
//                }
//            }
            
            .onAppear {
                
                save()
            }
        }

        
    }
    
//    func showSavePanel() -> URL? {
//        let savePanel = NSSavePanel()
//        savePanel.allowedContentTypes = [.png]
//        savePanel.canCreateDirectories = true
//        savePanel.isExtensionHidden = false
//        savePanel.title = "Save your image"
//        savePanel.message = "Choose a folder and a name to store the image."
//        savePanel.nameFieldLabel = "Image file name:"
//
//        let response = savePanel.runModal()
//        return response == .OK ? savePanel.url : nil
//    }
    
    func save() {
        topImage = numberTopView.snapshot()!
        bottomImage = numberBottomView.snapshot()!
        savePNG(type: "top")
        savePNG(type: "bottom")
    }
    
    func savePNG(type:String)  {
        let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let path = downloadsDirectory.appendingPathComponent("\(title)_\(type).png")

        
        let data :Data
        
        if type == "top" {
            data = topImage.tiffRepresentation!
        }else {
            data = bottomImage.tiffRepresentation!
        }
        let imageRepresentation = NSBitmapImageRep(data: data)
        let pngData = imageRepresentation?.representation(using: .png, properties: [:])
        
        do {
            try pngData?.write(to: path)
        }catch {
            print(error)
        }
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
//https://stackoverflow.com/questions/46997820/swift-4-macos-app-how-to-find-the-important-users-directories
