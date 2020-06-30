//
//  MainTableViewController.swift
//  YoutubeClient
//
//  Created by Vladislav on 27.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Private propertes
    private var searchList: [Item] = []
    private var searchText: String = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupUI()
        setupRefreshControl()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        let snippet = searchList[indexPath.row].snippet
        let defaultImage = snippet?.thumbnails?.default
        
        cell.titleLable.text = snippet?.title
        cell.descriptionLabel.text = "\(snippet?.channelTitle ?? "")\n\(snippet?.description ?? "")"
        
        NetworkManager.shared.fetchDataImage(url: defaultImage?.url ?? "") { (data) in
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.previewImage.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    // MARK: - Private methods
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
    }
    
    private func setupUI() {
        title = "Youtube client"
        tableView.rowHeight = 100
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(updateView), for: .valueChanged)
        tableView.addSubview(refreshControl ?? UIRefreshControl())
    }

    @objc private func updateView() {
        NetworkManager.shared.fetchSearchData(query: searchText) { (video) in
            self.searchList = video.items ?? []
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let detailVC = segue.destination as? DetailViewController else { return }
            
            let videoId = searchList[indexPath.row].id?.videoId
            
            detailVC.videoId = videoId
        }
    }
}

// MARK: - UISearchBarDelegate
extension MainTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
        
        NetworkManager.shared.fetchSearchData(query: searchText) { (video) in
            self.searchList = video.items ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
