//
//  ViewController.swift
//  FlySearch
//
//  Created by Aleksey Usanov on 30.04.2020.
//  Copyright © 2020 Aleksey Usanov. All rights reserved.
//

import UIKit
import JGProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var directions = [Directions]()
    var original: Origin?
    let hud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Поиск авиабилетов"
        self.tableView.tableFooterView = UIView()
        hud.textLabel.text = "Ищем куда можно улететь..."
        searchBar.searchTextField.textColor = .darkGray
        self.navigationController?.navigationBar.shadowImage = UIImage()
        searchBar.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func searchAction() {
        self.view.endEditing(true)
        hud.show(in: self.view)
        let searchText = searchBar.text!.uppercased()
        
        NetworkService.instance.searchFly(searchText: searchText) { (state, message, directions, origin) in
            DispatchQueue.main.async {
                self.hud.dismiss(animated: true)
                if state {
                    if let directions = directions {
                        self.directions = directions
                    }
                    if let origin = origin {
                        self.original = origin
                    }
                    self.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "ОЙ!", message: message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultViewController
        vc.destination = directions[tableView.indexPathForSelectedRow!.row].iata!
        vc.origin = original!.iata!
        vc.name = directions[tableView.indexPathForSelectedRow!.row].name!
        vc.originName = original!.name!
        vc.destinationCoordinate = directions[tableView.indexPathForSelectedRow!.row].coordinates!
        vc.originCoordinate = original!.coordinates!
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAction()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.uppercased()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionTableViewCell") as! DirectionTableViewCell
        
        cell.startCityLabel.text = self.original!.name!
        cell.startIATALabel.text = self.original!.iata!
        cell.startCountryLabel.text = "(\(self.original!.country!))"
        
        cell.stopCityLabel.text = directions[indexPath.row].name
        cell.stopIATALabel.text = directions[indexPath.row].iata
        cell.stopCountryLabel.text = "(\(directions[indexPath.row].country!))"
        
        return cell
    }
}
