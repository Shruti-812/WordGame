//
//  Word.swift
//  WordGame
//
//  Created by Shruti Mishra on 21/04/22.
//

import Foundation

struct Word: Codable {
  var englishVersion: String
  var spanishVersion: String
  
  enum CodingKeys: String, CodingKey {
    case englishVersion = "text_eng"
    case spanishVersion = "text_spa"
  }
}
