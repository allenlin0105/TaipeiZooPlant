//
//  ViewController.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2021/12/30.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ContentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        viewModel?.requestPlantData(at: 0)
        
        tableView.register(UINib(nibName: GlobalStrings.cellIdentifier, bundle: nil), forCellReuseIdentifier: GlobalStrings.cellIdentifier)
    }
}

//MARK: - UITableViewDataSource

extension ContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.plantDataModel.plantDataList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GlobalStrings.cellIdentifier) as! ContentTableViewCell
        if let data = viewModel?.plantDataModel.plantDataList[indexPath.row] {
            cell.bind(data: data)
        }
        return cell
    }
}

//MARK: - ContentProtocol

extension ContentViewController: ContentProtocol {
    
    func updateContentTableView() {
        tableView.reloadData()
    }
}
