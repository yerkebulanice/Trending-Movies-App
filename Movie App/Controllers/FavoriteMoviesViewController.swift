//
//  FaboriteMoviesViewController.swift
//  Movie App
//
//  Created by Еркебулан on 20.05.2021.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let coreDataManager = CoreDataManager.shared
    private var movies: [TrendingMoviesEntity.Movie] = [] {
        didSet {
            if movies.count != oldValue.count {
                tableView.reloadData()
            }
        }
    }
//    var ids: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MovieCell.identifier, bundle: Bundle(for: MovieCell.self)), forCellReuseIdentifier: MovieCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movies = CoreDataManager.shared.allMovies()
//        for i in 0..<movies.count {
//            for j in 0..<ids.count {
//                if ids.count != 0{
//                    if ids[j] != ids[j+1] {
//                        ids.append(movies[i].id)
//                    }
//                } else {
//                    ids.append(movies[i].id)
//                }
//            }
//        }
//        print(ids)
        tableView.reloadData()
    }

}

extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        cell.wasDeletedMovie = {
            self.movies = self.coreDataManager.allMovies()
            self.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -10, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}

// My PROTOCOL is not worked, i don't why
extension FavoriteMoviesViewController: DeleteMovieProtocol {
    func wasDeletedMovie(with movieId: Int) {
        print("Works")
        print(movieId)
        var ids = 0
        for id in 0..<movies.count {
            if movieId == movies[id].id {
                ids = id
            }
        }
        let myIndexPath = IndexPath(row: ids, section: 0)
        movies.remove(at: ids)
        tableView.reloadData()
        tableView.deleteRows(at: [myIndexPath], with: .left)
    }
}

