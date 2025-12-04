//
//  PosterView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 27/11/25.
//

import SwiftUI

struct PosterView: View {
    let url: String?
    
    var body: some View {
        AsyncImage(url: makeURL()) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle().fill(Color.gray.opacity(0.3))
        }
    }
    
    private func makeURL() -> URL? {
        guard let path = url else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

#Preview {
    PosterView(url: "/xYLBgw7dHyEqmcrSk2Sq3asuSq5.jpg")
}
