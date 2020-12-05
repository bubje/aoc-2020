import ArgumentParser
import Foundation

struct swift2b: ParsableCommand {
	public static let configuration = CommandConfiguration(abstract: "Run 2b solution")

	@Argument(help: "The title of the input file")
	private var fileName: String

	mutating func run() throws {
		var count = 0

		let lines = try String(contentsOfFile: fileName).components(separatedBy: "\n")
		for line in lines {
			let array = line.components(separatedBy: CharacterSet(charactersIn: ": -")).filter { !$0.isEmpty }
			if array.count < 4 {
				break
			}
			let character = Array(array[3])
/*
			for item in array {
				print(item)
			}
*/
			if let firstPos = Int(array[0]), let secondPos = Int(array[1]) {
/*
				print(character[firstPos-1])
				print(character[secondPos-1])
*/
				let result = ((String(character[firstPos-1]) == array[2]) ? 1 : 0) + ((String(character[secondPos-1]) == array[2]) ? 1 : 0)
				if result == 1 {
					count+=1
				}
			}
		}
		print("Total count:", count);
	}
}

swift2b.main()
