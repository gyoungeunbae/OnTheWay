import Foundation

struct CalenderManager {
    
    var myCalender = Calendar.current   //그레고리안 달력
    var myDate = Date() //현재 날짜
    var myDateFormatter = DateFormatter()
    var myDateComponents = DateComponents()    //내가 원하는 날짜 지정해서 캘린더에 넣어라
    var weekDic = [Int: Int]()
    
    //이번주 일요일 Date
    func getSunday(myDate: Date) -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        let beginningOfWeek = cal.date(from: comps)!
        return beginningOfWeek
    }
    
    //이번주 일요일부터 토요일까지의 Date를 배열에 넣기
    func getWeekArr() -> [Date] {
        let sunDate = getSunday(myDate: myDate)
        let startOfDate = myCalender.startOfDay(for: sunDate)
        var weekArr = [Date]()
        for index in 0...6 {
            let weekDate = startOfDate.addingTimeInterval(TimeInterval(60*60*24*index))
            weekArr.append(weekDate)
        }
        return weekArr
    }
    
    //일주일 전 Date 구하기
    func getLastweekDate(myDate: Date) -> Date {
        let oneWeek = TimeInterval(60*60*24*6)
        let lastDate = Date(timeInterval: -oneWeek, since: Date())
        return Calendar.current.startOfDay(for: lastDate)
    }
    
    //일주일전부터 오늘까지 Date를 배열에 넣기
    func getLastWeekArr() -> [Date] {
        let lastDate = getLastweekDate(myDate: myDate)
        let startOfDate = myCalender.startOfDay(for: lastDate)
        var weekArr = [Date]()
        for index in 0...6 {
            let weekDate = startOfDate.addingTimeInterval(TimeInterval(60*60*24*index))
            weekArr.append(weekDate)
        }
        return weekArr
    }
    func getDayArr(todayDate: Date) -> Int {
        
        var today = myCalender.dateComponents([.weekday], from: todayDate)
        
        return today.weekday!
    }
    
    func getKoreanStr(todayDate: Date) -> String {
        myDateFormatter.dateFormat = "yyyyMMdd"
        return myDateFormatter.string(from: todayDate)
    }
    func getTimeString(todayDate: Date) -> String {
        myDateFormatter.dateFormat = "MM월 dd일"
        return myDateFormatter.string(from: todayDate)
    }
    func getTodayString(todayDate: Date) -> String {
        myDateFormatter.locale = Locale.init(identifier: "en_GB")
        myDateFormatter.dateFormat = "MMMM d"
        return myDateFormatter.string(from: todayDate)
    }


    func getSimpleStr(todayDate: Date) -> String {
        myDateFormatter.dateFormat = "dd일"
        return myDateFormatter.string(from: todayDate)
    }
    
    func getWeekArrStr() -> [String] {
        var weekArr = getLastWeekArr()
        var temp = [String]()
        for index in 0..<weekArr.count {
            let str = getKoreanStr(todayDate: weekArr[index])
            temp.append(str)
        }
        return temp
    }
    
    func getSimpleWeekArrStr() -> [String] {
        var weekArr = getLastWeekArr()
        var temp = [String]()
        for index in 0..<weekArr.count {
            let str = getSimpleStr(todayDate: weekArr[index])
            temp.append(str)
        }
        return temp
    }
    
}
