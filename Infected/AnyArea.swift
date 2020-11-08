//
//  AnyArea.swift
//  Infected
//
//  Created by marko on 11/4/20.
//

import Foundation

struct AnyArea {

    let area: Area

}

extension AnyArea: Area, Identifiable {
    
    var id: Int {
        area.id
    }

    var name: String {
        area.name
    }

    var latest: Numbers {
        area.latest
    }

    var previous: Numbers {
        area.previous
    }

    var total: Numbers {
        area.total
    }

}
