//
//  PostCell.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/3/22.
//

import UIKit
import Alamofire
import AlamofireImage
import PhotosUI

protocol PostCellDelegate: AnyObject {
    func showComments(post: Post)
}


class PostCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    // Blur view to blur out "hidden" posts
    @IBOutlet private weak var blurView: UIVisualEffectView!

    @IBOutlet weak var commentButton: UIButton!
    
    private var imageDataRequest: DataRequest?
    var delegate: PostCellDelegate?
    var post: Post?
    @IBAction func didPressComment(_ sender: Any) {
        print("INSIDE DID PRESS COMMENT")
        if let post = post{
            
            delegate?.showComments(post: post)
        }
        
    }
    
    
    func configure(with post: Post) {
        // TODO: Pt 1 - Configure Post Cell

        self.post = post
        // Username
        if let user = post.user {
            usernameLabel.text = user.username
        }

        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {

            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        // Caption
        captionLabel.text = post.caption

        // Date
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
        if let latitude = post.latitude, let longitude = post.longitude {
            geoLocation(latitude: latitude, longitude: longitude)
        }
        
        
        
        // TODO: Pt 2 - Show/hide blur view
        // A lot of the following returns optional values so we'll unwrap them all together in one big `if let`
        // Get the current user.
        if let currentUser = User.current,

            // Get the date the user last shared a post (cast to Date).
           let lastPostedDate = currentUser.lastPostedDate,

            // Get the date the given post was created.
           let postCreatedDate = post.createdAt,

            // Get the difference in hours between when the given post was created and the current user last posted.
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {

            // Hide the blur view if the given post was created within 24 hours of the current user's last post. (before or after)
            blurView.isHidden = abs(diffHours) < 24
        } else {

            // Default to blur if we can't get or compute the date's above for some reason.
            blurView.isHidden = false
        }

    }
    
  
    func geoLocation(latitude: Double, longitude: Double) {
        
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in

                // Place details
                guard let placeMark = placemarks?.first else { return }
                var result = ""
                // Location name
                if let locationName = placeMark.location {
                   // result.append(locationName)
                    print(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    result.append(street)
                    print(street)
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    result.append(city)
                    print(city)
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    result.append(zip)
                    print(zip)
                }
                // Country
                if let country = placeMark.country {
                    result.append(country)
                    print(country)
                }
            
            self.locationLabel.text = result
        })
    
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: Pt 1 - Cancel image data request

        // Reset image view image.
        postImageView.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()
    }
}
