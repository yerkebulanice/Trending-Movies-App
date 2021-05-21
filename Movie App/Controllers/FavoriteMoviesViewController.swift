//
//  FaboriteMoviesViewController.swift
//  Movie App
//
//  Created by Еркебулан on 20.05.2021.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var movies: [TrendingMoviesEntity.Movie] = [] {
        didSet {
            if movies.count != oldValue.count {
                tableView.reloadData()
            }
        }
    }
    var ids: [Int] = []
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
        
        for i in 0..<movies.count {
            for j in 0..<ids.count {
                if ids.count != 0{
                    if ids[j] != ids[j+1] {
                        ids.append(movies[i].id)
                    }
                } else {
                    ids.append(movies[i].id)
                }
            }
        }
        print(ids)
    }
}

extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
}

extension FavoriteMoviesViewController: DeleteMovie {
    func wasDeleted(_ id: Int) {
        if let index = ids.firstIndex(of: id) {
            movies.remove(at: index)
        }
        tableView.reloadData()
    }
}
