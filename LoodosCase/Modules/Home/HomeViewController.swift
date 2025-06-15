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
        setupUI()
        configureLayout()
        bindViewModel()
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
            layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
            layout.estimatedItemSize = .zero
        }
    }

    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.collectionView.reloadData()
                self.emptyLabel.isHidden = !self.viewModel.movies.isEmpty
            }
        }

        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
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
        viewModel.searchMovies(query: query)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource & Layout

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                            for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        let movie = viewModel.movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12 + 8 + 12 // sectionInsets + spacing
        let availableWidth = collectionView.bounds.width - padding
        let width = availableWidth / 2
        let posterHeight = width * 3 / 2 // 2:3 oranı (genişlik × 1.5)
        let textHeight: CGFloat = 48 // title + year label alanı
        return CGSize(width: width, height: posterHeight + textHeight)
    }
}
