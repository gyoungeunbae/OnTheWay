# Ontheway
## System Structure

![https://user-images.githubusercontent.com/24830023/27513171-d8d2c72c-5996-11e7-95a5-8e268fa98eea.GIF](https://user-images.githubusercontent.com/24830023/27513171-d8d2c72c-5996-11e7-95a5-8e268fa98eea.GIF)

## 서비스 설명

- human이라는 기존의 application을 모방
- 당신의 일주일 동안의 발자취 데이터를 제공합니다

## LoginView
![Image of Login](https://github.com/gyoungeunbae/OnTheWay/tree/fu/OnTheWayMain/Server/uploads/login.png)
- passport session 관리
- facebook login 연동
- 로그인

## RegisterView
![Image of Register](https://github.com/gyoungeunbae/OnTheWay/tree/fu/OnTheWayMain/Server/uploads/register.png)
- 회원가입

## ForgetPasswordView
![Image of ForgetPassword](https://github.com/gyoungeunbae/OnTheWay/tree/fu/OnTheWayMain/Server/uploads/forgetPassword.png)
- 비밀번호 분실시 이메일 입력하면 비밀번호 알 수 있다

## MainView
![Image of Main](https://github.com/gyoungeunbae/OnTheWay/tree/fu/OnTheWayMain/Server/uploads/main.png)
- 아이폰의 Healthkit 으로부터 일주일 간 걸음수 데이터 가져오기
- 코어그래픽
- 스크롤뷰
- 터치이벤트

## MyPathView
![Image of MyPath](https://github.com/gyoungeunbae/OnTheWay/tree/fu/OnTheWayMain/Server/uploads/myPath.png)
- Mapbox : 오늘날짜 지도
- static mapbox : 메모리 문제로 오늘 이외의 날짜에 해당하는 지도는 스냅샷
- CoreMotion : 걷거나 뛸때에 Realm에 현재위치 좌표 저장
- PageMenu : 일주일치 화면

## SharePhotoView
![Image of SharePhoto](https://github.com/gyoungeunbae/OnTheWay/tree/fu/OnTheWayMain/Server/uploads/sharePhoto.png)
- 사진촬영 시 사진 위에 걸음수, 이동경로 등 넣기
- AVFoundation을 통한 customCamera

## SettingView
![Image of Setting](https://github.com/gyoungeunbae/OnTheWay/tree/fu/OnTheWayMain/Server/uploads/setting.png)
- Local-notification 설정(매일 아침 8시 푸시알림)
- tableView

## 적용된 기술
### Front-End
- swift3

### Back-End
- node
- mongoDB
- Realm