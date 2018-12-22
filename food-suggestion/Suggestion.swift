//
//  Suggestion.swift
//  food-suggestion
//
//  Created by Jaehyuk Rhee on 12/22/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import Foundation

enum OptionType: String {
    case help = "h"
    case quit = "q"
    case search = "s"
    case reservation = "r"
    case unknown

    
    init(value: String) {
        switch value {
        case "h": self = .help
        case "help": self = .help
        case "q": self = .quit
        case "s": self = .search
        case "search": self = .search
        case "r": self = .reservation
        case "reservation": self = .reservation
        default: self = .unknown
        }
    }
}

class Suggestion {
    let consoleIO = ConsoleIO()
    
    func staticMode() {
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        let initial = argument.startIndex
        let next = argument.index(after: initial)
        let (option, value) = getOption(String(argument[next...]))
        consoleIO.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
    }
    
    func getOption(_ option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    func interactiveMode() {
        consoleIO.writeMessage("Welcome to Food Suggestion!")
        var shouldQuit = false
        while !shouldQuit {
            consoleIO.writeMessage("Type 'h' for help type 'q' to quit.")
            let (option, _) = getOption(consoleIO.getInput())
            
            switch option {
            case .help:
                consoleIO.writeMessage("HELP")
                consoleIO.printUsage()
            case .quit:
                consoleIO.writeMessage("Bye bye.")
                shouldQuit = true
            case .unknown:
                consoleIO.writeMessage("Unknown command.")
                consoleIO.printUsage()
            case .search:
                consoleIO.writeMessage("Type query term:")
                let yelpApiClient = YelpApiClient()
                yelpApiClient.queryTerm(term: consoleIO.getInput())
            case .reservation:
                consoleIO.writeMessage("Type restaurant name:")
                let yelpApiClient = YelpApiClient()
                yelpApiClient.queryTerm(term: consoleIO.getInput())
            }
        }
    }
}
