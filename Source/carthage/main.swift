//
//  main.swift
//  Carthage
//
//  Created by Justin Spahr-Summers on 2014-10-10.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import CarthageKit
import Commandant
import Foundation
import ReactiveCocoa
import Cocoa
import ReactiveTask
import Result

guard ensureGitVersion().first()?.value == true else {
	fputs("Carthage requires git \(CarthageRequiredGitVersion) or later.\n", stderr)
	exit(EXIT_FAILURE)
}

let printer = ThreadSafePrinter()
let fileManager = NSFileManager.defaultManager()

let registry = CommandRegistry<CarthageError>()
registry.register(ArchiveCommand(fileManager: fileManager))
registry.register(BootstrapCommand(printer: printer, fileManager: fileManager))
registry.register(BuildCommand())
registry.register(CheckoutCommand())
registry.register(CopyFrameworksCommand())
registry.register(FetchCommand())
registry.register(UpdateCommand())
registry.register(VersionCommand(printer: printer))

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

spinForTestIfNecessary()

registry.main(defaultVerb: helpCommand.verb) { error in
	fputs(error.description + "\n", stderr)
}
