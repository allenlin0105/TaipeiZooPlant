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
    
    convenience init(viewModel: ContentViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        viewModel?.requestPlantData(at: 0)
        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: GlobalStrings.cellIdentifier, bundle: nil), forCellReuseIdentifier: GlobalStrings.cellIdentifier)
    }
}

//MARK: - UITableViewDelegate
//extension ContentViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if isAvailableToRequestData(at: indexPath.row) {
////            viewModel?.requestPlantData()
//        }
//    }
//
//    private func isAvailableToRequestData(at rowIndex: Int) -> Bool {
////        guard let finish = viewModel?.finishAllAccess, let notValidRow = viewModel?.notValidOffset else { return false }
//        return false
////        return !finish && rowIndex != notValidRow && rowIndex + 1 == viewModel?.getTotalDataSize()
//    }
//}
//
////MARK: - UITableViewDataSource
//extension ContentViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return viewModel?.getTotalDataSize() ?? 0
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: GlobalStrings.cellIdentifier, for: indexPath) as? ContentTableViewCell else {
//            return UITableViewCell()
//        }
//
////        if let data = viewModel?.getCertainDataForTableViewCellWithIndex(index: indexPath.row) {
////            cell.bind(data: data)
////        }
//        return cell
//    }
//}

//MARK: - ContentProtocol

extension ContentViewController: ContentProtocol {
    func updateContentTableView() {
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
}
