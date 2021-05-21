//
//  ViewController.swift
//  Movie App
//
//  Created by Еркебулан on 19.04.2021.
//

import UIKit
import Alamofire

class MovieNewsViewController: UIViewController {

    private let TrendingMoviesURL: String = "https://api.themoviedb.org/3/trending/movie/week?api_key=3b58e5009b70d3e88f6f07c61f02cb67"
    @IBOutlet weak var tableView: UITableView!
    private var pageNumber: Int = 1
    private var movies: [TrendingMoviesEntity.Movie] = [TrendingMoviesEntity.Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieCell.identifier, bundle: Bundle(for: MovieCell.self)), forCellReuseIdentifier: MovieCell.identifier)
        getTrendingMovies()
    }

}

extension MovieNewsViewController {
    private func getTrendingMovies(_ page: Int? = nil){
        var params: [String: Any] = [:]
        
        if let page = page {
            params["page"] = page
        }
        
        AF.request(TrendingMoviesURL, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                    let movieJSON = try JSONDecoder().decode(TrendingMoviesEntity.self, from: data)
                        self.movies += movieJSON.movies
//                        print(movieJSON)
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


extension MovieNewsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.movieId = movies[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
//            print(movies[indexPath.row].id)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 10 && currentOffset > 200 {
            pageNumber += 1
            getTrendingMovies(pageNumber)
        }
    }
    
}

extension MovieNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    
}
