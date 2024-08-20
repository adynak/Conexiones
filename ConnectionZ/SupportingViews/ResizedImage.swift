//
//  ResizedImage.swift
//  WineSearch
//
//  Created by al00p on 9/21/22.
//

import SwiftUI

struct ResizedImage: View {
    var imageName: String
    var size: CGFloat
    var foregroundColor: Color = .white
    var foregroundStyle: [Color]? = []

    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(foregroundColor)
    }
}

struct ResizedImageWithStyle: View {
    var imageName: String
    var size: CGFloat
    var foregroundStyle: [Color]

    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(foregroundStyle[0], foregroundStyle[1])
    }
}

struct ResizedBundleImage: View {
    var imageName: String
    var size: CGFloat
    var foregroundColor: Color = .white
    var body: some View {
        Image(uiImage: UIImage(named: imageName)!)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(foregroundColor)
    }
}

struct ResizedImage_Previews: PreviewProvider {
    static var previews: some View {
        ResizedImage(imageName: "chevron.down", 
                     size: 25, 
                     foregroundColor: Color("textDarkLight")
        )
    }
}

struct ResizedImageWithStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var refreshStyle: [Color] =  [Color("tabItemSelected"), Color("mainColor")]

        ResizedImageWithStyle(imageName: "star.bubble",
                     size: 25,
                     foregroundStyle: refreshStyle
        )
    }
}
