//
//  NumbersDTO.swift
//  Infected
//
//  Created by marko on 10/25/20.
//

import Foundation

struct NumbersDTO: Decodable {

    let date: Date
    let category: Category
    let count: Int
    let totalCount: Int
    let municipalityCode: Int?
    let municipalityName: String?
    let provinceCode: Int?
    let provinceName: String?

}

extension NumbersDTO {

    enum Category: String, Decodable {
        case cases = "Totaal"
        case hospitalizations = "Ziekenhuisopname"
        case deaths = "Overleden"
    }

    enum CodingKeys: String, CodingKey {
        case date = "Datum"
        case category = "Type"
        case count = "Aantal"
        case totalCount = "AantalCumulatief"
        case municipalityCode = "Gemeentecode"
        case municipalityName = "Gemeentenaam"
        case provinceCode = "Provinciecode"
        case provinceName = "Provincienaam"
    }

}
