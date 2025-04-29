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
    private let labelSize: CGFloat = 13

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 25) {
                // Mood emoji display
                Text(selectedMood.emoji)
                    .font(.system(size: 90))
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
                    .padding(.bottom, 5)

                // Mood level text
                Text(selectedMood.description)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(selectedMood.color)
                    .padding(.bottom, 10)

                // Slider track with emojis
                ZStack(alignment: .leading) {
                    // Background track with gradient
                    RoundedRectangle(cornerRadius: sliderHeight / 2)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: sliderHeight)
                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)

                    // Colored portion of track with gradient
                    LinearGradient(
                        gradient: Gradient(colors: moodGradientColors()),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: sliderHeight / 2)
                            .frame(width: sliderWidth(in: geometry.size.width), height: sliderHeight)
                    )

                    // Emoji markers
                    HStack {
                        ForEach(MoodLevel.allCases) { level in
                            Spacer()
                            VStack {
                                Text(level.emoji)
                                    .font(.system(size: emojiSize))
                                    .opacity(level == selectedMood ? 1.0 : 0.7)
                                    .scaleEffect(level == selectedMood ? 1.3 : 1.0)
                                    .shadow(color: level == selectedMood ? level.color.opacity(0.3) : .clear, radius: 3, x: 0, y: 1)
                                    .animation(.spring(response: 0.3), value: selectedMood)

                                Text(level.description)
                                    .font(.system(size: labelSize, weight: level == selectedMood ? .bold : .regular))
                                    .foregroundColor(level == selectedMood ? level.color : .gray)
                                    .opacity(level == selectedMood ? 1.0 : 0.7)
                                    .animation(.easeInOut, value: selectedMood)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(level.description) mood")
                            .accessibilityHint("Double tap to select this mood")
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedMood = level
                                }
                                // Add haptic feedback
                                #if os(iOS)
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                #endif
                            }
                            Spacer()
                        }
                    }
                }
                .frame(height: sliderHeight + 50) // Add extra height for labels

                // Drag gesture for continuous selection
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            updateMoodFromDragLocation(value.location.x, totalWidth: geometry.size.width)
                        }
                )
            }
            .padding()
            .frame(width: geometry.size.width)
        }
        .frame(height: 280) // Fixed height for the entire component
    }

    /// Returns an array of colors for the mood gradient
    private func moodGradientColors() -> [Color] {
        return [
            MoodLevel.veryBad.color,
            MoodLevel.bad.color,
            MoodLevel.neutral.color,
            MoodLevel.good.color,
            MoodLevel.veryGood.color
        ]
    }

    /// Calculates the width of the colored portion of the slider
    private func sliderWidth(in totalWidth: CGFloat) -> CGFloat {
        let totalLevels = CGFloat(MoodLevel.allCases.count)
        let progress = CGFloat(selectedMood.rawValue) / totalLevels

        // Account for padding
        let effectiveWidth = totalWidth - 40 // 40 for padding

        return effectiveWidth * progress
    }

    /// Updates the selected mood based on drag location
    private func updateMoodFromDragLocation(_ xLocation: CGFloat, totalWidth: CGFloat) {
        // Account for padding
        let effectiveWidth = totalWidth - 40 // 40 for padding
        let normalizedX = max(0, min(xLocation, effectiveWidth)) / effectiveWidth

        let totalLevels = CGFloat(MoodLevel.allCases.count)
        let levelIndex = Int(normalizedX * totalLevels)

        // Convert to 1-based index for MoodLevel
        let adjustedIndex = max(1, min(Int16(levelIndex + 1), Int16(totalLevels)))

        if let newMood = MoodLevel(rawValue: adjustedIndex), newMood != selectedMood {
            withAnimation(.spring(response: 0.3)) {
                selectedMood = newMood
            }

            // Add haptic feedback
            #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            #endif
        }
    }
}

#Preview {
    MoodSlider(selectedMood: .constant(.neutral))
}
