//
//  WordRepository.swift
//  WordGame
//
//  Created by Shruti Mishra on 21/04/22.
//

import Foundation

enum WordRepositoryError: Error {
  case wordFileNotFound
  case failedToParseSourceFile
}

protocol WordRepositoryProtocol {
  func sourceWordList() -> Result<[String : String], WordRepositoryError>
}

class WordRepository: WordRepositoryProtocol {
  
  var sourceFileName: String
  private var wordListCache = [String: String]()
  
  init(sourceFileName: String = "words") {
    self.sourceFileName = sourceFileName
  }
  
  func sourceWordList() -> Result<[String : String], WordRepositoryError> {
    
    if wordListCache.isEmpty {
      
      if let fileUrl = Bundle.main.url(forResource: self.sourceFileName,
                                       withExtension: "json") {
        if let data = try? Data(contentsOf: fileUrl) {
          
          if let wordList = try? JSONDecoder().decode([Word].self, from: data) {
            
            let arrayOfWordDict = wordList.map({ [$0.englishVersion: $0.spanishVersion] }).flatMap({ $0 })
            self.wordListCache = self.wordListCache.merging(arrayOfWordDict) { _, new in
              return new
            }
            
          } else {
            return .failure(.failedToParseSourceFile)
          }
          
        } else {
          return .failure(.failedToParseSourceFile)
        }
      } else {
        return .failure(.wordFileNotFound)
      }
    }
    return .success(self.wordListCache)
  }
}
