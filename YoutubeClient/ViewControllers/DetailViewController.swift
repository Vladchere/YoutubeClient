//
//  DetailViewController.swift
//  YoutubeClient
//
//  Created by Vladislav on 27.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public propertes
    var videoId: String!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        showDataInElements()
        
    }
    
    private func setUI() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        descriptionTextView.isEditable = false
    }
    
    private func showDataInElements() {
        NetworkManager.shared.fetchVideoData(videoId: videoId) { (video) in
            DispatchQueue.main.async {
                let snippet = video.items?.first?.snippet
                let duration = video.items?.first?.contentDetails?.duration
                
                // Title
                self.titleLable.text = snippet?.title ?? ""
                
                // WebView
                let videoURL = URL(string: "https://www.youtube.com/embed/\(self.videoId ?? "")")!
                self.webView.load(URLRequest(url: videoURL))
                self.activityIndicator.stopAnimating()
                
                // Description
                self.descriptionTextView.text = """
                Channel: \(snippet?.channelTitle ?? "")
                Link: https://www.youtube.com/channel/\(snippet?.channelId ?? "")
                
                View count: \(video.items?.first?.statistics?.viewCount ?? "0")
                Like count: \(video.items?.first?.statistics?.likeCount ?? "0")
                Dislike count: \(video.items?.first?.statistics?.dislikeCount ?? "0")
                
                Published: \(snippet?.publishedAt ?? "")
                Duration: \(duration ?? "")
                
                Description: \(snippet?.description ?? "")
                
                Tags: \(snippet?.tags?.joined(separator: ", ") ?? "")
                """
            }
        }
    }
}
