//
//  MoodSlider.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import SwiftUI

/// A custom slider for selecting mood levels
struct MoodSlider: View {
    @Binding var selectedMood: MoodLevel
    
    // Layout constants
    private let sliderHeight: CGFloat = 60
    private let emojiSize: CGFloat = 40
    private let labelSize: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 20) {
            // Mood emoji display
            Text(selectedMood.emoji)
                .font(.system(size: 80))
                .padding(.bottom, 10)
            
            // Mood level text
            Text(selectedMood.description)
                .font(.headline)
                .foregroundColor(selectedMood.color)
                .padding(.bottom, 20)
            
            // Slider track with emojis
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: sliderHeight / 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: sliderHeight)
                
                // Colored portion of track
                RoundedRectangle(cornerRadius: sliderHeight / 2)
                    .fill(selectedMood.color)
                    .frame(width: sliderWidth(), height: sliderHeight)
                
                // Emoji markers
                HStack {
                    ForEach(MoodLevel.allCases) { level in
                        Spacer()
                        VStack {
                            Text(level.emoji)
                                .font(.system(size: emojiSize))
                                .opacity(level == selectedMood ? 1.0 : 0.6)
                                .scaleEffect(level == selectedMood ? 1.2 : 1.0)
                                .animation(.spring(), value: selectedMood)
                            
                            Text(level.description)
                                .font(.system(size: labelSize))
                                .foregroundColor(level == selectedMood ? level.color : .gray)
                                .fontWeight(level == selectedMood ? .bold : .regular)
                        }
                        .onTapGesture {
                            selectedMood = level
                        }
                        Spacer()
                    }
                }
            }
            .frame(height: sliderHeight + 40) // Add extra height for labels
            
            // Drag gesture for continuous selection
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateMoodFromDragLocation(value.location.x)
                    }
            )
        }
        .padding()
    }
    
    /// Calculates the width of the colored portion of the slider
    private func sliderWidth() -> CGFloat {
        let totalLevels = CGFloat(MoodLevel.allCases.count)
        let levelWidth = 1.0 / totalLevels
        let progress = CGFloat(selectedMood.rawValue) / totalLevels
        
        // Get the geometry proxy's width (approximated for this calculation)
        let approximatedWidth: CGFloat = UIScreen.main.bounds.width - 40 // 40 for padding
        
        return approximatedWidth * progress
    }
    
    /// Updates the selected mood based on drag location
    private func updateMoodFromDragLocation(_ xLocation: CGFloat) {
        let totalWidth = UIScreen.main.bounds.width - 40 // 40 for padding
        let normalizedX = max(0, min(xLocation, totalWidth)) / totalWidth
        
        let totalLevels = CGFloat(MoodLevel.allCases.count)
        let levelIndex = Int(normalizedX * totalLevels)
        
        // Convert to 1-based index for MoodLevel
        let adjustedIndex = max(1, min(Int16(levelIndex + 1), Int16(totalLevels)))
        
        if let newMood = MoodLevel(rawValue: adjustedIndex) {
            selectedMood = newMood
        }
    }
}

#Preview {
    MoodSlider(selectedMood: .constant(.neutral))
}
