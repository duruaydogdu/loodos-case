//
//  HomeViewController.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var emptyLabel: UILabel!

    // MARK:- Properties
    private var viewModel = HomeViewModel()
    private var selectedIndexPath: IndexPath?

    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureLayout()
        bindViewModel()
    }

    // MARK:- UI
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
            layout.sectionInset = .init(top: 16, left: 12, bottom: 16, right: 12)
            layout.estimatedItemSize = .zero
        }
    }

    // MARK:- ViewModel
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = true
                self?.collectionView.reloadData()
                self?.updateEmptyState()
            }
        }

        viewModel.onLoadingStateChange = { [weak self] loading in
            DispatchQueue.main.async {
                loading ? self?.loadingIndicator.startAnimating()
                        : self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = !loading
            }
        }
    }

    private func updateEmptyState() {
        let empty = viewModel.movies.isEmpty
        emptyLabel.isHidden = !empty
        emptyLabel.text = empty ? "Sonuç bulunamadı." : ""
    }

    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let idx = selectedIndexPath,
           let dst = segue.destination as? DetailViewController {
            dst.imdbID = viewModel.movies[idx.item].imdbID 
        }
    }
}

// MARK:- Delegates
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let q = searchBar.text?.trimmingCharacters(in: .whitespaces), !q.isEmpty else { return }
        viewModel.searchMovies(query: q)
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                          for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: viewModel.movies[indexPath.item])
        return cell
    }

    func collectionView(_ cv: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12 + 8 + 12
        let w = (cv.bounds.width - padding) / 2
        return CGSize(width: w, height: w * 1.5 + 48)
    }

    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
