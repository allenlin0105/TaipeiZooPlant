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
        
        viewModel.delegate = self
        viewModel.requestPlantData(at: 0)
        
        tableView.register(UINib(nibName: ContentStrings.cellIdentifier, bundle: nil), forCellReuseIdentifier: ContentStrings.cellIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension ContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.requestImage(at: indexPath.row)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentStrings.cellIdentifier) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        let data = viewModel.plantDataModel.plantDataList[indexPath.row]
        cell.bind(data: data)
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
    
    func updateContentTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
