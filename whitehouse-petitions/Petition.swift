//
//  Petition.swift
//  whitehouse-petitions
//
//  Created by Bradley Chesworth on 14/02/2020.
//  Copyright © 2020 Brad Chesworth. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
