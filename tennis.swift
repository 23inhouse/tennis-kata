import Foundation
import XCTest

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

func earlyGameName(_ score: UInt8) -> String {
    precondition(score < 4, "Score must be below 4")

    let names: [UInt8: String] = [
        0: "love",
        1: "fifteen",
        2: "thirty",
        3: "forty",
    ]
    return names[score]!
}

func lateGameName(_ difference: UInt8) -> String {
    switch difference {
    case 0: return "deuce"
    case 1: return "advantage"
    default: return "win"
    }
}

func formattedScore(_ p1: UInt8, _ p2: UInt8) -> String {
    return score(p1, p2).capitalizingFirstLetter()
}

func earlyGame(_ p1: UInt8, _ p2: UInt8) -> Bool {
    return (p1 < 4 && p2 < 4) && (p1 + p2 < 6)
}

func earlyGameScore(_ p1: UInt8, _ p2: UInt8) -> String {
    if p1 == p2 {
        return "\(earlyGameName(p1)) all"
    } else {
        return "\(earlyGameName(p1)) - \(earlyGameName(p2))"
    }
}

func lateGameScore(_ p1: UInt8, _ p2: UInt8) -> String {
    if p1 > p2 {
        return "\(lateGameName(p1 - p2)) player one"
    } else if p2 > p1 {
        return "\(lateGameName(p2 - p1)) player two"
    } else {
        return "\(lateGameName(0))"
    }
}

func score(_ p1: UInt8, _ p2: UInt8) -> String {
    return earlyGame(p1, p2) ? earlyGameScore(p1, p2) : lateGameScore(p1, p2)
}

class TennisTests: XCTestCase {
    func testScores() {
        let expectations: [(p1: UInt8, p2: UInt8, score: String)] = [
            (0, 0, "Love all"),
            (1, 1, "Fifteen all"),
            (2, 2, "Thirty all"),

            (1, 0, "Fifteen - love"),
            (2, 0, "Thirty - love"),
            (3, 0, "Forty - love"),

            (0, 1, "Love - fifteen"),
            (0, 2, "Love - thirty"),
            (0, 3, "Love - forty"),

            (1, 2, "Fifteen - thirty"),
            (2, 3, "Thirty - forty"),
            (3, 1, "Forty - fifteen"),

            (3, 3, "Deuce"),
            (4, 4, "Deuce"),
            (5, 5, "Deuce"),

            (4, 3, "Advantage player one"),
            (5, 4, "Advantage player one"),
            (3, 4, "Advantage player two"),
            (4, 5, "Advantage player two"),

            (4, 0, "Win player one"),
            (5, 0, "Win player one"),
            (5, 3, "Win player one"),
            (6, 4, "Win player one"),
            (3, 5, "Win player two"),
            (4, 6, "Win player two"),
        ]

        for expectation in expectations {
            let gameScore = formattedScore(expectation.p1, expectation.p2)
            let errorMessage = "Expected \"\(expectation.score)\" but got \"\(gameScore)\""
            XCTAssertEqual(gameScore, expectation.score, errorMessage)
        }
    }
}

TennisTests.defaultTestSuite.run()
