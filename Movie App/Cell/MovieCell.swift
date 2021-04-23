//
//  MovieCell.swift
//  Movie App
//
//  Created by Еркебулан on 19.04.2021.
//

import UIKit
import Kingfisher
class MovieCell: UITableViewCell {
    public static let identifier: String = "MovieCell"
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var containerRatingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    public var movie: MovieEntity.Movie? {
        didSet {
            if let movie = movie {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w400" + (movie.poster ?? ""))
                posterImageView.kf.setImage(with: posterURL)
                posterImageView.backgroundColor = .systemTeal
                ratingLabel.text = "\(movie.rating)"
                movieTitleLabel.text = movie.title
                releaseDateLabel.text = movie.releaseDate
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerRatingView.layer.cornerRadius = 20
        containerRatingView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true
    }

}
