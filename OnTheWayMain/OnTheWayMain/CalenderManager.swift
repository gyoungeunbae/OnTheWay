import Foundation

class CalenderManager {
    class var sharedInstance: CalenderManager {
        struct Singleton {
            static let instance = CalenderManager()
        }
        return Singleton.instance
    }
    
    
    var myCalender = Calendar.current   //그레고리안 달력
    var myDate = Date() //현재 날짜
    var myDateFormatter = DateFormatter()
    var myDateComponents = DateComponents()    //내가 원하는 날짜 지정해서 캘린더에 넣어라
    var weekDic = [Int:Int]()
    
    
    //이번주 일요일 Date
    func getSunday(myDate: Date) -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        let beginningOfWeek = cal.date(from: comps)!
        return beginningOfWeek
    }
    
    //이번주 일요일부터 오늘까지의 Date를 배열에 넣기
    func getWeekArr() -> [Date] {
        let sunDate = getSunday(myDate: myDate)
        let startOfDate = myCalender.startOfDay(for: sunDate)
        var weekArr = [Date]()
        for index in 0...6 {
            var weekDate = startOfDate.addingTimeInterval(TimeInterval(60*60*24*index))
            weekArr.append(weekDate)
        }
        
        return weekArr
    }
    
    func getKoreanStr(todayDate: Date) -> String {
        myDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return myDateFormatter.string(from: todayDate)
    }
    
}


