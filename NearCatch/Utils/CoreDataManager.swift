
//
//  CoreDataManager.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/11.
//

import Foundation
import CoreData

class CoreDataManager {

    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name:"NearCatch")
        persistentContainer.loadPersistentStores {(description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }


    func createProfile(nickname: String) {

        let profile = Profile(context: persistentContainer.viewContext)
        profile.nickname = nickname


        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save profile \(error)")
        }
    }

    func readAllProfile() -> [Profile] {

        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()

        do{
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }

    }

    func updateMovie() {

        do{
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }

    func deleteProfile(profile: Profile) {

        persistentContainer.viewContext.delete(profile)

        do{
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
    }
}

