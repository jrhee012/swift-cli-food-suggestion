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
    case unknown
    case quit = "q"

    
    init(value: String) {
        switch value {
        case "h": self = .help
        case "q": self = .quit
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
        print(option)
        return (OptionType(value: option), option)
    }
    
    func interactiveMode() {
        consoleIO.writeMessage("Welcome to Food Suggestion!")
        var shouldQuit = false
        while !shouldQuit {
            consoleIO.writeMessage("Type 'h' for help type 'q' to quit.")
            let (option, value) = getOption(consoleIO.getInput())
            
            switch option {
            case .help:
                consoleIO.writeMessage("HELP")
                consoleIO.printUsage()
            case .unknown, .quit:
                consoleIO.writeMessage("Unknown command. Exiting...")
                shouldQuit = true
            }
        }
    }
}