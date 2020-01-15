import Foundation
import UIKit

class Word:Codable {
    
    var englishWord:String
    var belarusianWord:String
    var englishDefinition:String
    var belarusianDefinition:String
    var wordImage:UIImage
    
    private enum CodingKeys: String, CodingKey {
        case englishWord
        case belarusianWord
        case englishDefinition
        case belarusianDefinition
        case wordImage
    }
    
    init (englishWord: String,belarusianWord: String,englishDefinition: String,belarusianDefinition: String,wordImage: UIImage) {
        self.englishWord = englishWord
        self.belarusianWord = belarusianWord
        self.englishDefinition = englishDefinition
        self.belarusianDefinition = belarusianDefinition
        self.wordImage = wordImage
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        englishWord = try container.decode(String.self, forKey: .englishWord)
        belarusianWord = try container.decodeIfPresent(String.self, forKey: .belarusianWord) ?? ""
        englishDefinition = try container.decodeIfPresent(String.self, forKey: .englishDefinition) ?? ""
        belarusianDefinition = try container.decodeIfPresent(String.self, forKey: .belarusianDefinition) ?? ""
        
        let data = try container.decodeIfPresent(Data.self, forKey: CodingKeys.wordImage)
        if let data = data {
            guard let wordImage = UIImage(data: data) else {
                throw NSError(domain: "Error decoding logo", code: 0, userInfo: nil)
            }
            self.wordImage = wordImage
        } else {
            wordImage = UIImage(named: "placeholder")!
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let data = wordImage.jpegData(compressionQuality: 1.0)
        try container.encode(data, forKey: CodingKeys.wordImage)
        try container.encode(self.englishWord, forKey: .englishWord)
        try container.encode(self.belarusianWord, forKey: .belarusianWord)
        try container.encode(self.englishDefinition, forKey: .englishDefinition)
        try container.encode(self.belarusianDefinition, forKey: .belarusianDefinition)
    }
}
