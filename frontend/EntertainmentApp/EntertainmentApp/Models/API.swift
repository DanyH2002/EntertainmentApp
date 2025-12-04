//
//  API.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import Foundation

// MARK: Modelos de Movies
struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let poster: String?
    let backdrop: String?
    let releaseDate: String?
    let voteAverage: Double?
    let video_url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case video_url
    }
    
    var posterURL: String? {
        if let poster {
            return "https://image.tmdb.org/t/p/w500\(poster)"
        }
        return nil
    }
}

struct MovieDetail: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: CollectionInfo?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: Modelos de Series
struct SeriesResponse: Codable {
    let page: Int
    let results: [Serie]
}

struct Serie: Codable, Identifiable {
    let id: Int
    let name: String
    let originalName: String?
    let overview: String
    let poster: String?
    let backdrop: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let popularity: Double?
    let originCountry: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "original_name"
        case overview
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case popularity
        case originCountry = "origin_country"
    }
    
    var posterURL: String? {
        if let poster {
            return "https://image.tmdb.org/t/p/w500\(poster)"
        }
        return nil
    }
}

struct SeriesDetail: Codable, Identifiable {
    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let genres: [Genre]?
    let homepage: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let firstAirDate: String?
    let lastAirDate: String?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let status: String?
    let tagline: String?
    let name: String
    let voteAverage: Double?
    let voteCount: Int?
    let spokenLanguages: [SpokenLanguage]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case genres
        case homepage
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case status
        case tagline
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case spokenLanguages = "spoken_languages"
    }
}

// MARK: Modelos auxiliares
struct Genre: Codable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct CollectionInfo: Codable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}

struct ProductionCountry: Codable {
    let iso31661: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable {
    let englishName: String?
    let iso6391: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}
