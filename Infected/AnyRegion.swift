//
//  AnyRegion.swift
//  Infected
//
//  Created by marko on 11/4/20.
//

import Foundation

struct AnyRegion {

    let region: Region

}

extension AnyRegion: Region, Identifiable {
    
    var id: Int {
        region.id
    }

    var name: String {
        region.name
    }

    var latest: Numbers {
        region.latest
    }

    var previous: Numbers {
        region.previous
    }

    var total: Numbers {
        region.total
    }

}
