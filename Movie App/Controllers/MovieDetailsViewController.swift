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
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    private var movie: MovieDetailsEntity?
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.layer.cornerRadius = 20
        ratingView.layer.masksToBounds = true
        self.getMovieDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        if let movieId = movieId {
            if let _ = MovieEntity.findMovie(with: movieId, context: context){
                favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        if let movieId = movieId {
            if let _ = MovieEntity.findMovie(with: movieId, context: context){
                favoriteButton.setImage(UIImage(named: "star"), for: .normal)
                CoreDataManager.shared.deleteMovie(with: movieId)
            } else {
                if var movie = movie {
                    favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
                    movie.id = movieId
                    CoreDataManager.shared.addMovie(movie)
                }
            }
        }
    }
}

extension MovieDetailsViewController {
    private func getMovieDetails() {
        AF.request("https://api.themoviedb.org/3/movie/\(movieId ?? 1))?api_key=3b58e5009b70d3e88f6f07c61f02cb67&language=en-US", method: .get, parameters: [:]).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        self?.movie = try JSONDecoder().decode(MovieDetailsEntity.self, from: data)
                        self?.updateUI(self?.movie)
                    }catch let errorJSON {
                        print(errorJSON)
                    }
                }
            case .failure:
                print("Failed")
            }
        }
    }
    
    private func updateUI(_ movie: MovieDetailsEntity?) {
        if let movie = movie {
            ratingLabel.text = String(movie.rating)
            overTitleLabel.text = movie.title
            descriptionTextView.text = movie.description
            releaseDate.text = movie.releaseDate
            title = movie.title
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movie.poster ?? ""))
            posterImageView.kf.setImage(with: posterURL)
        }
    }
    
}

