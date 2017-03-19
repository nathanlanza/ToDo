import UIKit

class ViewController: UIViewController {
    
    func makeHeadline(from string: String) -> String {
        return string.components(separatedBy: " ").map { $0.capitalized }.joined(separator: " ")
    }
    
    func numberOfVowels(in string: String) -> Int {
        let vowels = CharacterSet(charactersIn: "aeiouAEIOU")
        return string.unicodeScalars.filter(vowels.contains).count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

