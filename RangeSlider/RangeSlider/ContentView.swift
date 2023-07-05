//
//  ContentView.swift
//  RangeSlider
//
//  Created by Denisia Enasescu on 05.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var lowerValue: CGFloat = 0
    @State private var upperValue: CGFloat = 50
    
    var body: some View {
        RangeSlider(lowerValue: $lowerValue, upperValue: $upperValue, range: 0...100)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
