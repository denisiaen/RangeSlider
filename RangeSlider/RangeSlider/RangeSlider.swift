//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Denisia Enasescu on 05.07.2023.
//

import Foundation
import SwiftUI

struct RangeSlider: View {
    @Binding var lowerValue: CGFloat
    @Binding var upperValue: CGFloat
    
    private let height: CGFloat = 4
    private let thumbSize: CGFloat = 28
    
    private var range: ClosedRange<CGFloat>
    
    init(lowerValue: Binding<CGFloat>, upperValue: Binding<CGFloat>, range: ClosedRange<CGFloat>) {
        self._lowerValue = lowerValue
        self._upperValue = upperValue
        self.range = range
    }
    
    var body: some View {
        slider
            .padding(.vertical, 20)
            .padding(.leading, 30)
            .padding(.trailing, 40)
    }
    
    private var slider: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            
            ZStack(alignment: .leading) {
                makeLowerTrack(trackWidth: trackWidth)
                makeUpperTrack(trackWidth: trackWidth)
                
                HStack(spacing: 0) {
                    makeLowerThumb(trackWidth: trackWidth)
                    makeUpperThumb(trackWidth: trackWidth)
                }
            }
        }
    }
    
    private var thumbOffset: CGFloat {
        thumbSize / 2
    }
    
    private func makeLowerTrack(trackWidth: CGFloat) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: trackWidth + thumbOffset, height: height)
    }
    
    @ViewBuilder
    private func makeUpperTrack(trackWidth: CGFloat) -> some View {
        let upperLocation = makeUpperLocation(trackWidth: trackWidth)
        let lowerLocation = makeLowerLocation(trackWidth: trackWidth)

        Rectangle()
            .fill(.green)
            // due to lower thumb adjustment
            .frame(width: upperLocation - lowerLocation + thumbOffset, height: height)
            .offset(x: lowerLocation + thumbOffset)
    }
    
    @ViewBuilder
    private func makeLowerThumb(trackWidth: CGFloat) -> some View {
        let upperLocation = makeUpperLocation(trackWidth: trackWidth)
        let lowerLocation = makeLowerLocation(trackWidth: trackWidth)
        let maxLowerValue = min(upperLocation - thumbOffset, trackWidth)
        
        makeThumb()
            // adjust offset to properly centre lower thumb
            .offset(x: lowerLocation - thumbOffset)
            .shadow(color: .black.opacity(0.12), radius: 10, y: 6)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let newValue = value.location.x
                        if newValue >= 0 && newValue <= maxLowerValue {
                            lowerValue = formattedValue(value: newValue, trackWidth: trackWidth)
                        } else if newValue < 0 {
                            lowerValue = range.lowerBound
                        }
                    })
            )
    }
    
    @ViewBuilder
    private func makeUpperThumb(trackWidth: CGFloat) -> some View {
        let maxUpperValue = trackWidth
        let upperLocation = makeUpperLocation(trackWidth: trackWidth)
        let lowerLocation = makeLowerLocation(trackWidth: trackWidth)
        
        makeThumb()
            .offset(x: upperLocation - thumbSize)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let newValue = value.location.x
                        if newValue <= maxUpperValue && newValue >= lowerLocation + thumbOffset {
                            upperValue = formattedValue(value: newValue, trackWidth: trackWidth)
                        } else if newValue > maxUpperValue {
                            upperValue = range.upperBound
                        }
                    })
            )
    }
    
    private func makeThumb() -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: thumbSize, height: thumbSize)
            .shadow(color: .black.opacity(0.12), radius: 10, y: 6)
    }
    
    private func makeUpperLocation(trackWidth: CGFloat) -> CGFloat {
        ((upperValue - range.lowerBound) * trackWidth) / (range.upperBound - range.lowerBound)
    }
    
    private func makeLowerLocation(trackWidth: CGFloat) -> CGFloat {
        ((lowerValue - range.lowerBound) * trackWidth) / (range.upperBound - range.lowerBound)
    }
    
    private func formattedValue(value: CGFloat, trackWidth: CGFloat) -> CGFloat {
        let percentage = value / trackWidth
        return percentage * (range.upperBound - range.lowerBound) + range.lowerBound
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        RangeSliderWrapper()
    }
}

private struct RangeSliderWrapper: View {
    @State private var lowerValue: CGFloat = 0
    @State private var upperValue: CGFloat = 50
    
    var body: some View {
        RangeSlider(lowerValue: $lowerValue, upperValue: $upperValue, range: 0...100)
    }
}

