//
//  ViewController.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2021/12/30.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    let contentViewModel = ContentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: GlobalStrings.cellIdentifier)
        
        contentViewModel.delegate = self
        contentViewModel.requestPlantData()
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentViewModel.getTotalDataSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GlobalStrings.cellIdentifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        let data = contentViewModel.getCertainDataForTableViewCellWithIndex(index: indexPath.row)
        cell.plantName.text = data.name
        cell.plantLocation.text = data.location
        cell.plantFeature.text = data.feature
        cell.plantImage.image = data.image?.resizeTopAlignedToFill(newWidth: 100) ?? nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == contentViewModel.getTotalDataSize() {
            print("Hello")
            contentViewModel.requestPlantData()
        }
    }
}

//MARK: - ContentProtocol
extension ContentViewController: ContentProtocol {
    func updateContentTableView(plantContent: PlantModel) {
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
}
