//
//  SearchResult.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [AppSearchResult]
}

struct AppSearchResult: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let artworkUrl100: String
    let screenshotUrls: [String]
    var formattedPrice: String?
    let description: String
    var releaseNotes: String?
}
