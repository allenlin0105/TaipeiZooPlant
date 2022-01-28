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
    }
}

//MARK: - UITableViewDataSource

extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.plantDataModel.plantDataList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: - ContentProtocol

extension ContentViewController: ContentProtocol {
    func updateContentTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
