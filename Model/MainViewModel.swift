import Foundation

class MainViewModel {
    var subjectData: SubjectInfo? //roominfos 에 대한 배열 변수를 선언
    var roomData: [RoomInfos]?
    
    func setRoomInfos(allData: SubjectInfo) {
        self.subjectData = allData
        self.roomData = allData.roomInfos
    }
    
    func roomDataSend() -> [RoomInfos] {
        return roomData!
    }
    
    
}
