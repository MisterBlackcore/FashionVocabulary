import UIKit

class WordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var englishWordLabel: UILabel!
    
    func configureCell(word: Word) {
        englishWordLabel.text = word.englishWord
    }
    
}
