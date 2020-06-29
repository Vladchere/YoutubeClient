//
//  MainTableViewCell.swift
//  YoutubeClient
//
//  Created by Vladislav on 27.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - IB Outlets
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}
