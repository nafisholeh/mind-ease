//
//  ContextFactorSelector.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import SwiftUI

/// A component for selecting contextual factors that might affect mood
struct ContextFactorSelector: View {
    @Binding var selectedFactors: [ContextFactor]

    // Layout constants
    private let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("What factors affected your mood?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.bottom, 5)

            Text("Select all that apply")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.gray)
                .padding(.bottom, 15)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(ContextFactor.allCases) { factor in
                    FactorButton(
                        factor: factor,
                        isSelected: selectedFactors.contains(factor),
                        action: {
                            toggleFactor(factor)
                        }
                    )
                }
            }
        }
        .padding()
    }

    /// Toggles the selection state of a context factor
    private func toggleFactor(_ factor: ContextFactor) {
        withAnimation(.spring(response: 0.3)) {
            if selectedFactors.contains(factor) {
                selectedFactors.removeAll { $0 == factor }
            } else {
                selectedFactors.append(factor)
            }
        }

        // Add haptic feedback
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

/// A button representing a single context factor
struct FactorButton: View {
    let factor: ContextFactor
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: factor.iconName)
                    .font(.system(size: 26, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                    )
                    .padding(.top, 5)

                Text(factor.rawValue)
                    .font(.system(size: 14, weight: isSelected ? .medium : .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? .blue : .primary)
            }
            .frame(minWidth: 90, minHeight: 90)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                    .shadow(color: isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1),
                            radius: 3, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(factor.rawValue) factor")
        .accessibilityValue(isSelected ? "selected" : "not selected")
        .accessibilityHint("Double tap to \(isSelected ? "deselect" : "select")")
    }
}

#Preview {
    ContextFactorSelector(selectedFactors: .constant([.sleep, .stress]))
}
