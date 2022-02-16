//
//  ViewController.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2021/12/30.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ContentViewModel

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ContentViewModel(dataLoader: DataLoader())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ContentStrings.cellIdentifier, bundle: nil), forCellReuseIdentifier: ContentStrings.cellIdentifier)
        tableView.register(UINib(nibName: ContentStrings.errorCellIdentifier, bundle: nil), forCellReuseIdentifier: ContentStrings.errorCellIdentifier)
        
        viewModel.delegate = self
        viewModel.requestPlantData(at: 0)
    }
}

// MARK: - UITableViewDataSource

extension ContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.requestPlantDataStatus {
        case .loading, .noData:
            return viewModel.dataCount + 1
        case .success:
            return viewModel.dataCount
        case .requestFail, .decodeFail:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.requestImage(at: indexPath.row)
        
        switch viewModel.requestPlantDataStatus {
        case .loading:
            if indexPath.row < viewModel.dataCount {
                guard let cell = makeContentCell(at: indexPath.row) else {
                    return UITableViewCell()
                }
                return cell
            } else {
                guard let cell = makeErrorCell(description: "Loading...") else {
                    return UITableViewCell()
                }
                return cell
            }
        case .success:
            guard let cell = makeContentCell(at: indexPath.row) else {
                return UITableViewCell()
            }
            return cell
        case .noData:
            guard let cell = makeErrorCell(description: "End of data...") else {
                return UITableViewCell()
            }
            return cell
        case .requestFail:
            guard let cell = makeErrorCell(description: "Request Fail...") else {
                return UITableViewCell()
            }
            return cell
        case .decodeFail:
            guard let cell = makeErrorCell(description: "Decode Fail...") else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    private func makeContentCell(at row: Int) -> ContentTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentStrings.cellIdentifier) as? ContentTableViewCell else {
            return nil
        }
        
        let data = viewModel.plantDataModel.plantDataList[row]
        cell.bind(data: data)
        return cell
    }
    
    private func makeErrorCell(description: String) -> ErrorTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentStrings.errorCellIdentifier) as? ErrorTableViewCell else {
            return nil
        }
        cell.errorLabel.text = description
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let nextIndex = indexPath.row + 1
        if !viewModel.finishAllAccess && nextIndex == viewModel.dataCount {
            viewModel.requestPlantData(at: nextIndex)
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
