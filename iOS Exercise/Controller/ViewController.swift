//
//  ViewController.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2021/12/30.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    private var content: PlantModel = PlantModel(plantResultList: [])
    let contentViewModel = ContentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "content")
        contentTableView.rowHeight = 150
        
        contentViewModel.delegate = self
        contentViewModel.requestPlantData()
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.plantResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.plantName.text = content.plantResultList[indexPath.row].name
        cell.plantLocation.text = content.plantResultList[indexPath.row].location
        cell.plantFeature.text = content.plantResultList[indexPath.row].feature
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: - ContentProtocol
extension ViewController: ContentProtocol {
    func updateContentTableView(plantContent: PlantModel) {
        plantContent.plantResultList.forEach { data in
            self.content.plantResultList.append(data)
        }
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
}
