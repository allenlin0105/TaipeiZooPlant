//
//  ViewController.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2021/12/30.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ContentViewModel(dataLoader: DataLoader())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: GlobalStrings.cellIdentifier)
        
        viewModel.delegate = self
        viewModel.requestPlantData()
    }
}

//MARK: - UITableViewDelegate
extension ContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.getTotalDataSize() {
            viewModel.requestPlantData()
        }
    }
}

//MARK: - UITableViewDataSource
extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTotalDataSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GlobalStrings.cellIdentifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        let data = viewModel.getCertainDataForTableViewCellWithIndex(index: indexPath.row)
        cell.bind(data: data)
        
        return cell
    }
}

//MARK: - ContentProtocol
extension ContentViewController: ContentProtocol {
    func updateContentTableView(plantContent: PlantModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
