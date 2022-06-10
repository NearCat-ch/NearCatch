//
//  NearCatchApp.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/07.
//

import SwiftUI

@main
struct NearCatchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
