//
//  ResultViewController.swift
//  FlySearch
//
//  Created by Aleksey Usanov on 03.05.2020.
//  Copyright © 2020 Aleksey Usanov. All rights reserved.
//

import UIKit
import Kingfisher
import JGProgressHUD
import MapKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var airline: UIImageView!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var depart: UILabel!
    @IBOutlet weak var `return`: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var origin: String = ""
    var destination: String = ""
    var name: String = ""
    var originName: String = ""
    var destinationCoordinate = [Double]()
    var originCoordinate = [Double]()
    let hud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name + " " + destination
        hud.textLabel.text = "Загружаем детали..."
        setMap()
        detailAction(iata: origin, destination: destination)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func setMap() {
        let originAnnotation = MKPointAnnotation()
        let destinationAnnotation = MKPointAnnotation()
        originAnnotation.title = originName
        destinationAnnotation.title = name
        originAnnotation.coordinate = CLLocationCoordinate2D(latitude: originCoordinate[1], longitude: originCoordinate[0])
        destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: destinationCoordinate[1], longitude: destinationCoordinate[0])
        mapView.addAnnotation(originAnnotation)
        mapView.addAnnotation(destinationAnnotation)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: destinationCoordinate[1], longitude: destinationCoordinate[0])
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        detailAction(iata: origin, destination: destination)
    }
    
    func detailAction(iata: String, destination: String) {
        hud.show(in: self.view)
        NetworkService.instance.getDetails(iata: iata, dest: destination) { (state, message, detail) in
            DispatchQueue.main.async {
                self.hud.dismiss(animated: true)
                if state {
                    if let detail = detail {
                        let image = ImageResource(downloadURL: URL(string: "https://ios.aviasales.ru/logos/hdpi/\(detail.airline!).png")!, cacheKey: detail.airline)
                        self.airline.kf.setImage(with: image)
                        self.value.text = "Цена:  \(detail.value!) ₽"
                        self.depart.text = "Туда \(detail.depart_date!)"
                        self.return.text = "Обратно \(detail.return_date!)"
                    }
                } else {
                    let alert = UIAlertController(title: "ОЙ!", message: message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Хорошо", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}


