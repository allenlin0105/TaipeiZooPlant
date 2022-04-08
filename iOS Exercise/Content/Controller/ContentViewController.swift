//
//  ViewController.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2021/12/30.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ContentViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ContentStrings.contentCellIdentifier, bundle: nil), forCellReuseIdentifier: ContentStrings.contentCellIdentifier)
        tableView.register(UINib(nibName: ContentStrings.errorCellIdentifier, bundle: nil), forCellReuseIdentifier: ContentStrings.errorCellIdentifier)
        
        viewModel?.requestPlantData(at: 0)
    }
}

// MARK: - UITableViewDataSource

extension ContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = viewModel?.dataCount ?? 0
        switch viewModel?.requestPlantDataStatus {
        case .loading, .noData, .requestFail, .decodeFail, .none:
            return dataCount + 1
        case .success:
            return dataCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.requestImage(at: indexPath.row)
        
        switch viewModel?.requestPlantDataStatus {
        case .loading, .noData, .requestFail, .decodeFail, .none:
            let description = viewModel?.requestPlantDataStatus.description ?? ""
            return (indexPath.row < (viewModel?.dataCount ?? 0)) ? contentCell(at: indexPath.row) : errorCell(description: description)
        case .success:
            return contentCell(at: indexPath.row)
        }
    }
    
    private func contentCell(at row: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentStrings.contentCellIdentifier) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        if let data = viewModel?.plantDataModel.plantDataList[row] {
            cell.bind(data: data)
        }
        return cell
    }
    
    private func errorCell(description: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentStrings.errorCellIdentifier) as? ErrorTableViewCell else {
            return UITableViewCell()
        }
        cell.errorLabel.text = description
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let nextIndex = indexPath.row + 1
        if viewModel?.requestPlantDataStatus == .success && nextIndex == viewModel?.dataCount {
            viewModel?.requestPlantData(at: nextIndex)
        }
    }
}

// MARK: - ContentProtocol

extension ContentViewController: ContentViewProtocol {
    
    func reloadContentTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
