//
//  CoreDataManager.swift
//  abz.agency
//
//  Created by Alexander on 12.06.25.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }

    private init() {
        container = NSPersistentContainer(name: "abz.agency")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("CoreData error: \(error.localizedDescription)")
            }
        }
    }

    func saveUsers(_ users: [User]) {
        deleteAllUsers()

        for user in users {
            let entity = UserEntity(context: context)
            entity.id = (Int64(user.id)) as NSNumber
            entity.name = user.name
            entity.email = user.email
            entity.phone = user.phone
            entity.photo = user.photo
            entity.timestamp = Int64(user.registration_timestamp)
            entity.position = user.position
            entity.positionId = Int64(user.position_id)
        }

        do {
            try context.save()
        } catch {
            print("Failed to save users: \(error)")
        }
    }

    func fetchUsers() -> [User] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sort]
        do {
            return try context.fetch(request).map {
                User(id: Int($0.id ?? 0), name: $0.name ?? "", email: $0.email ?? "", phone: $0.phone ?? "", position: $0.position ?? "", position_id: Int($0.positionId ?? 0), registration_timestamp: Int($0.timestamp ?? 0), photo: $0.photo ?? "")
            }
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }

    func deleteAllUsers() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete users: \(error)")
        }
    }
}
