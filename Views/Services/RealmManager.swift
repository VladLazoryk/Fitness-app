import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func saveWorkoutModel(model: WorkoutModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func updateStatusWorkoutModel(model: WorkoutModel, bool: Bool) {
        try! localRealm.write {
            model.status = bool
        }
    }
    
    func updateSetsRepsWorkoutModel(model: WorkoutModel, sets: Int, reps: Int) {
        try! localRealm.write {
            model.workoutSets = sets
            model.workoutReps = reps
        }
    }
    
    func updateSetsTimerWorkoutModel(model: WorkoutModel, sets: Int, timer: Int) {
        try! localRealm.write {
            model.workoutSets = sets
            model.workoutTimer = timer
        }
    }
    
    func deleteWorkoutModel(model: WorkoutModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func saveUserModel(model: UserModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func updateUserModel(model: UserModel) {
        let users = localRealm.objects(UserModel.self)
        
        try! localRealm.write {
            users[0].userFirstName = model.userFirstName
            users[0].userSecondName = model.userSecondName
            users[0].userWeight = model.userWeight
            users[0].userHeight = model.userHeight
            users[0].userTarget = model.userTarget
            users[0].userImage = model.userImage
        }
        
    }
}
