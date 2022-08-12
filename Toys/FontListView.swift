//
//  FontListView.swift
//  Toys
//
//  Created by Gyeongtae Nam on 2022/08/12.
//

import SwiftUI

struct FontListView: View {
    @State var fonts = [String]()
    var body: some View {
        ScrollView ([.vertical, .horizontal], showsIndicators: true) {
           
            VStack (alignment:.leading, spacing:0){
                
                ForEach(Array(fonts.enumerated()) , id: \.offset) { (i, font) in
                    HStack {

                        Text(font)
                            .font(.system(size: 10, weight: .bold, design: .default))


                        Text("Hello, world! 0123456789")
                            .font(Font.custom(font, size: 18))
                            .padding()
                    }
                }
                
                //DIN Alternate

            }
        }
        .border(Color.red, width: 1)
        .onAppear {
            
            for font in  NSFontManager.shared.availableFontFamilies {
                print(font)
                fonts.append(font)
            }
            
            
        }
        .frame(width: 500 , height: 300)
    }
}

struct FontListView_Previews: PreviewProvider {
    static var previews: some View {
        FontListView()
    }
}
