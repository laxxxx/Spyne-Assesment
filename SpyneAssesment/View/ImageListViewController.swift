//
//  ImageListViewController.swift
//  SpyneAssesment
//
//  Created by Sree Lakshman on 10/11/24.
//

import UIKit
import RealmSwift

class ImageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var images: Results<ImageDataModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImagesFromRealm()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.reloadData()
    }

    private func loadImagesFromRealm() {
        let realm = try? Realm()
        images = realm?.objects(ImageDataModel.self)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell,
              let imageData = images?[indexPath.row] else {
            return UITableViewCell()
        }

        // Configure the cell with image data
        cell.titleLabel.text = imageData.imageName

        // Load the image thumbnail from the local file path
        if let imagePath = imageData.imageURI, let image = UIImage(contentsOfFile: imagePath) {
            cell.photoImageView.image = image
        } else {
            cell.photoImageView.image = UIImage(systemName: "photo") // Placeholder image
        }

        return cell
    }

}

