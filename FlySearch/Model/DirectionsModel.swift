//
//  DirectionsModel.swift
//  FlySearch
//
//  Created by Aleksey Usanov on 30.04.2020.
//  Copyright © 2020 Aleksey Usanov. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class AllDirections: Mappable {
    var origin: Origin?
    var directions: [Directions]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        origin <- map["origin"]
        directions <- map["directions"]
    }
}

class Origin: Mappable {
    var iata: String?
    var name: String?
    var country: String?
    var coordinates: [Double]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        iata <- map["iata"]
        name <- map["name"]
        country <- map["country"]
        coordinates <- map["coordinates"]
    }
}


class Directions: Mappable {
    var direct: Bool?
    var iata: String?
    var name: String?
    var country: String?
    var country_name: String?
    var coordinates: [Double]?
    var weight: Int?
    var weather: Weather?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        direct <- map["direct"]
        iata <- map["iata"]
        name <- map["name"]
        country <- map["country"]
        country_name <- map["country_name"]
        coordinates <- map["coordinates"]
        weight <- map["weight"]
        weather <- map["weather"]
    }
}

class Weather: Mappable {
    var weathertype: String?
    var temp_min: String?
    var temp_max: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        weathertype <- map["weathertype"]
        temp_min <- map["temp_min"]
        temp_max <- map["temp_max"]
    }
}

class DirectionDetail: Mappable {
    var value: Int?
    var origin: String?
    var destination: String?
    var actual: Bool?
    var airline: String?
    var depart_date: String?
    var return_date: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        value <- map["value"]
        origin <- map["origin"]
        destination <- map["destination"]
        actual <- map["actual"]
        airline <- map["airline"]
        depart_date <- map["depart_date"]
        return_date <- map["return_date"]
    }
}
