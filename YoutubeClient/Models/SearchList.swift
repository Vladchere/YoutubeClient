//
//  SearchList.swift
//  YoutubeClient
//
//  Created by Vladislav on 29.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

struct SearchList: Decodable {
    let items: [Item]?
}

struct Item: Decodable {
    let id: Id?
    let snippet: Snippet?
}

struct Id: Decodable {
    let videoId: String?
}

struct Snippet: Decodable {
    let title: String?
    let description: String?
    let thumbnails: Thumbnails?
    let channelTitle: String?
}

struct Thumbnails: Decodable {
    let `default`: Preview?
}

struct Preview: Decodable {
    let url: String?
}
