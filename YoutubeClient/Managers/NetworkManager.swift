//
//  NetworkService.swift
//  YoutubeClient
//
//  Created by Vladislav on 27.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let request = "https://www.googleapis.com/youtube/v3"
    private let part = "snippet"
    private let type = "video"
    private let maxResults = 50
    private let apiKey = "AIzaSyD98q-C0TJ69JfPh1JxKcx3qCKd7gfENBg"
    
    func fetchSearchData(query: String, completion: @escaping (SearchList) -> Void) {
        var stringUrl = request
        stringUrl.append("/search")
        stringUrl.append("?part=\(part)")
        stringUrl.append("&type=\(type)")
        stringUrl.append("&maxResults=\(maxResults)")
        stringUrl.append("&q=\(query)")
        stringUrl.append("&key=\(apiKey)")
        
        guard let url = URL(string: stringUrl) else { return }
        print(url)
            
        URLSession.shared.dataTask(with: url) { (data, _, error)  in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let video = try JSONDecoder().decode(SearchList.self, from: data)
                completion(video)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchDataImage(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error)  in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
    func fetchVideoData(videoId: String, completion: @escaping (Video) -> Void) {
        var stringUrl = request
        stringUrl.append("/videos")
        stringUrl.append("?id=\(videoId)")
        stringUrl.append("&key=\(apiKey)")
        stringUrl.append("&part=snippet,contentDetails,statistics,status")
        
        guard let url = URL(string: stringUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, error)  in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let video = try JSONDecoder().decode(Video.self, from: data)
                completion(video)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
}
