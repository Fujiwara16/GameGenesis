//
//  URLs.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import Foundation

extension URL {
    static var development:URL {
        URL(string: "https://api.rawg.io")!
    }
    static var production:URL {
        URL(string: "https://api.rawg.io")!
        
    }
    static var apikey = "c542e67aec3a4340908f9de9e86038af"
    static var `default`:URL{
        #if DEBUG
        return development
        #else
        return production
        #endif
    }
    static func finalListUrl(page:Int,genre:String)->URL{
        let url = URL(
            string: "/api/games",
            relativeTo: URL.default
        )!
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )!
        components.queryItems = [
            URLQueryItem(name: "key", value: URL.apikey),
            URLQueryItem(name: "genres", value: "\(genre)"),
            URLQueryItem(name: "page", value: "\(page)"),
        ]
        return URL(string: components.string!)!
    }
    static func finalBestOfYearUrl(page:Int)->URL{
        
        let url = URL(string: "/api/games/lists/greatest", relativeTo:URL.default)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "discover", value: "true"),
            URLQueryItem(name: "ordering", value: "-added"),
            URLQueryItem(name: "page_size", value: "\(page)"),
            URLQueryItem(name: "key", value: URL.apikey)
        ]
        return URL(string: (components?.string!)!)!
    }
    
    static func finalDetURL(id:String)->URL{
        let url = URL(
            string: "/api/games/\(id)",
            relativeTo: URL.default
        )!
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )!
        components.queryItems = [
            URLQueryItem(name: "key", value: URL.apikey)
        ]
        return URL(string: components.string!)!
    }
    
    static func finalVideoUrl(id:String)->URL{
        let url = URL(
            string: "/api/games/\(id)/movies",
            relativeTo: URL.default
        )!
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )!
        components.queryItems = [
            URLQueryItem(name: "key", value: URL.apikey)
        ]
        return URL(string: components.string!)!
    }
    static func finalImageUrl(imageurl:String)->URL{
        guard let url = URL(
            string: imageurl
        ) else { return URL(string:"https://media.rawg.io/media/games/baf/baf9905270314e07e6850cffdb51df41.jpg")!}
     
        return url

    }
    static func finalGameSearchUrl(searchText:String)->URL{
        let url = URL(
            string: "/api/games",
            relativeTo: URL.default
        )!
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )!
        components.queryItems = [
            URLQueryItem(name: "key", value: URL.apikey),
            URLQueryItem(name: "search", value: searchText)
        ]
        return URL(string: components.string!)!
    }
    
}
