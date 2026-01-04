//
//  IconButton.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

struct IconButton: View {
    var imageName: String
    
    var body: some View {
        Color.main300
            .frame(width: 48, height: 48)
            .overlay {
                Image(systemName: imageName)
                    .foregroundStyle(Color.white)
                    .padding(8)
            }
            .cornerRadius(10)
    }
}

#Preview {
    IconButton(imageName: "globe")
}

