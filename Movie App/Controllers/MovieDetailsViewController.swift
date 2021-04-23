//
//  MovieDetailsViewController.swift
//  Movie App
//
//  Created by Еркебулан on 22.04.2021.
//

import UIKit
import Alamofire
import Kingfisher

class MovieDetailsViewController: UIViewController {
    public var movieId: Int?
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overTitleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
//    private var movie: [MovieDetailsEntity] = [MovieDetailsEntity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.layer.cornerRadius = 20
        self.getMovieDetails()
    }

}

extension MovieDetailsViewController {
    private func getMovieDetails() {
        AF.request("https://api.themoviedb.org/3/movie/\(movieId ?? 1))?api_key=3b58e5009b70d3e88f6f07c61f02cb67&language=en-US", method: .get, parameters: [:]).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let movieJSON = try JSONDecoder().decode(MovieDetailsEntity.self, from: data)
                        self.ratingLabel.text = "\(movieJSON.rating)"
                        self.overTitleLabel.text = movieJSON.title
                        self.descriptionTextView.text = movieJSON.description
                        self.releaseDate.text = movieJSON.releaseDate
                        self.title = movieJSON.title
                        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movieJSON.poster ?? ""))
                        self.posterImageView.kf.setImage(with: posterURL)
                    }catch let errorJSON {
                        print(errorJSON)
                    }
                }
            case .failure:
                print("Failed")
            }
        }
    }
}

