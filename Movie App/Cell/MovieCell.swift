//
//  MovieCell.swift
//  Movie App
//
//  Created by Еркебулан on 19.04.2021.
//

import UIKit
import Kingfisher

protocol DeleteMovie: NSObjectProtocol {
    func wasDeleted(_ id: Int)
}

class MovieCell: UITableViewCell {
    public static let identifier: String = "MovieCell"
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var containerRatingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    public weak var delegate: DeleteMovie?

    public var movie: TrendingMoviesEntity.Movie? {
        didSet {
            if let movie = movie {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w400" + (movie.poster ?? ""))
                posterImageView.kf.setImage(with: posterURL)
                posterImageView.backgroundColor = .systemTeal
                ratingLabel.text = String(movie.rating ?? 0)
                movieTitleLabel.text = movie.title
                releaseDateLabel.text = movie.releaseDate
                                
                if let _ = MovieEntity.findMovie(with: movie.id, context: context){
                    favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
                } else {
                    favoriteButton.setImage(UIImage(named: "star"), for: .normal)
                }
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

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let movie = movie {
            if let _ = MovieEntity.findMovie(with: movie.id, context: context){
                favoriteButton.setImage(UIImage(named: "star"), for: .normal)
                CoreDataManager.shared.deleteMovie(with: movie.id)
                delegate?.wasDeleted(movie.id)
            } else {
                favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
                CoreDataManager.shared.addMovie(movie)
            }
        }
    }
}
