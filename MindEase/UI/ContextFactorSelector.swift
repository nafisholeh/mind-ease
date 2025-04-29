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
        GridItem(.adaptive(minimum: 100), spacing: 10)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What factors affected your mood?")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("Select all that apply")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, spacing: 15) {
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
        if selectedFactors.contains(factor) {
            selectedFactors.removeAll { $0 == factor }
        } else {
            selectedFactors.append(factor)
        }
    }
}

/// A button representing a single context factor
struct FactorButton: View {
    let factor: ContextFactor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: factor.iconName)
                    .font(.system(size: 24))
                    .padding(.bottom, 5)
                
                Text(factor.rawValue)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 80, minHeight: 80)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(isSelected ? .blue : .primary)
    }
}

#Preview {
    ContextFactorSelector(selectedFactors: .constant([.sleep, .stress]))
}
