//
//  main.swift
//  food-suggestion
//
//  Created by Jaehyuk Rhee on 12/22/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import Foundation

print("Hello, World!")

let suggestion = Suggestion()
//suggestion.staticMode()

if CommandLine.argc < 2 {
    suggestion.interactiveMode()
} else {
    suggestion.staticMode()
}
