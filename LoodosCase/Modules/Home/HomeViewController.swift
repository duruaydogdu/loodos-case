//
//  HomeViewController.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!

    private var viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad çalıştı")
        print("COLLECTIONVIEW: \(collectionView ?? .init())")

        setupUI()
        configureLayout()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("CollectionView Frame: \(collectionView.frame)")
    }

    // MARK: - Setup

    private func setupUI() {
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        emptyLabel.isHidden = true
        loadingIndicator.isHidden = true
    }

    private func configureLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            layout.estimatedItemSize = .zero
        }
    }

    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                print("reloadData çağrıldı. Film sayısı: \(self.viewModel.movies.count)")
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.collectionView.reloadData()
                self.emptyLabel.isHidden = !self.viewModel.movies.isEmpty
            }
        }

        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                print("Loading durumu: \(isLoading)")
                self?.loadingIndicator.isHidden = !isLoading
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        print("Arama yapılıyor: \(query)")
        viewModel.searchMovies(query: query)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource & Layout

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection: \(viewModel.movies.count)")
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Hücre oluşturuluyor: \(indexPath.item)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                            for: indexPath) as? MovieCollectionViewCell else {
            print("Hücre tip dönüşümü başarısız")
            return UICollectionViewCell()
        }

        let movie = viewModel.movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 + 8 + 16
        let availableWidth = collectionView.bounds.width - padding
        let width = availableWidth / 2
        let height = width * 1.5 + 40 // görsel + 2 label için yeterli alan
        let size = CGSize(width: width, height: height)
        print("Hücre boyutu: \(size)")
        return size
    }
}
