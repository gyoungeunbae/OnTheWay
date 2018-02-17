# Ontheway

## 서비스 설명

- human이라는 기존의 application을 모방
- 당신의 일주일 동안의 발자취 데이터를 제공합니다

## LoginView
<img width="372" alt="login" src="https://user-images.githubusercontent.com/24830023/27516637-98b6af48-59f8-11e7-8f5a-c755b1c714a7.png">
- passport session 관리
- facebook login 연동
- 로그인

## RegisterView

#####                          <img width="372" alt="register" align="middle" src="https://user-images.githubusercontent.com/24830023/27523083-df0a6850-5a65-11e7-9203-77cdcee2e035.png">

- 회원가입

## ForgetPasswordView
<img width="372" alt="forgetpassword" align="middle" src="https://user-images.githubusercontent.com/24830023/27523051-a6735cf4-5a65-11e7-9967-76be60ce9940.png">

- 비밀번호 분실시 이메일 입력하면 비밀번호 알 수 있다

## MainView


<img width="372" alt="main" src="https://user-images.githubusercontent.com/24830023/27522998-22ec195c-5a65-11e7-9abc-5380b4478bae.png">

- 아이폰의 Healthkit 으로부터 일주일 간 걸음수 데이터 가져오기
- 코어그래픽
- 스크롤뷰
- 터치이벤트

## MyPathView
<img width="372" alt="mypath" src="https://user-images.githubusercontent.com/24830023/27516575-97f697e0-59f7-11e7-8e19-67caedc934af.png">
- Mapbox : 오늘날짜 지도
- static mapbox : 메모리 문제로 오늘 이외의 날짜에 해당하는 지도는 스냅샷
- CoreMotion : 걷거나 뛸때에 Realm에 현재위치 좌표 저장
- PageMenu : 일주일치 화면

## SharePhotoView
<img width="372" alt="sharephoto"  src="https://user-images.githubusercontent.com/24830023/27516374-7ff9e484-59f3-11e7-9e39-9030c8c6f391.png">

- 사진촬영 시 사진 위에 걸음수, 이동경로 등 넣기
- AVFoundation을 통한 customCamera

## SettingView
​                       <img width="372" alt="setting" align="middle" src="https://user-images.githubusercontent.com/24830023/27516304-8061951c-59f2-11e7-9bce-9945c5bcf9c1.png">

- Local-notification 설정(매일 아침 8시 푸시알림)
- tableView

## 적용된 기술
### Front-End
- swift3

### Back-End
- node
- mongoDB
- Realm
