# WorkTime
![WorkTime Logo](https://github.com/ejeonghun/worktime/blob/main/assets/logo.png?raw=true)
### 사업장 근태관리 애플리케이션

## 🔧Stack🔧
<p align="center">
  <img src="https://img.shields.io/badge/JAVA-007396?style=for-the-badge&logo=java&logoColor=white">
  <img src="https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white">
  <img src="https://img.shields.io/badge/JWT-black?style=for-the-badge&logo=JSON%20web%20tokens">
  <img src="https://img.shields.io/badge/Spring Security-6DB33F?style=for-the-badge&logo=Spring Security&logoColor=white">
  <img src="https://img.shields.io/badge/apache tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black">
  <img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">
  <img src="https://img.shields.io/badge/mariadb-003545?style=for-the-badge&logo=mariadb&logoColor=white">
</p>

## 📱Platform📱
<p align="left">
  <img src="https://img.shields.io/badge/ios-000000?style=for-the-badge&logo=ios&logoColor=white">
  <img src="https://img.shields.io/badge/android-3DDC84?style=for-the-badge&logo=android&logoColor=white">
  <img src="https://img.shields.io/badge/web-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white">
</p>

## 📜 개발 배경
- **지원 시스템 부재**
     - 관리자가 사업장의 근무자들의 근무 시간 체크 필요성
- **협업 시 필요성**
    - 근무자들의 일정 관리 및 일정 공유 필요성

## 🎯 개발 목적
- **쉬운 사용성**
   - 출/퇴근 시간에는 쉽고 빠르게 처리 될 필요성이 있음, 그래서 앱으로 버튼 원터치로 출/퇴근 가능
- **사업장 내 일정 공유**
   - 근무자들과의 일정 공유 및 원활한 업무 처리 가능
- **부정 근로 차단**
   - 스마트폰의 GPS로 회사의 관리자가 설정한 좌표값의 200m 내에서만 출/퇴근 기능 사용 가능

## 📋 서비스 개요
- 빠르고 쉬운 사용성으로 사업장의 근무자들의 근태 관리 가능한 어플리케이션

### 💡 주요 기능
- **부서 및 직급**
  - 앱 메인의 근태 리스트에서 부서 및 직급 조회 가능
- **GPS로 부정근로 방지**
  - 사업장이 설정한 좌표값에서 200m 내 에서만 출/퇴근 가능
- **일정**
  - 근로자의 휴가 지정 시 해당 날짜의 근태 리스트에서 "휴가"로 표시 및 미팅, 회의 등 일정 추가 가능
- **푸시 알림 기능**
  - 근로자가 출근 버튼을 누르면 그 시간의 매 1시간마다 Push 알림으로 사용자에게 표시

---

## 🖼 화면 구성
### [화면 구성](https://github.com/ejeonghun/worktime/wiki/%ED%99%94%EB%A9%B4-%EA%B5%AC%EC%84%B1)

## 🎨 Figma
[![Figma](https://github.com/user-attachments/assets/d457d0c6-7d21-4cf2-bb01-34fbbbe82090)](https://www.figma.com/design/zeisHMhifJKOmdTbdyY2N6/%EC%B6%9C%ED%87%B4%EA%B7%BC%EC%95%B1?m=auto&t=x8NQpdmgyYuZETr3-1)

## 🗂 ERD
![image](https://github.com/user-attachments/assets/9a162f49-5db2-435c-a858-098db758c9f9)
[ERD 자세히보기](https://www.erdcloud.com/d/5uC6oYWq7SLuCxttE)

## 📂 Back-end Repository
[Back-end](https://github.com/ejeonghun/worktime_backend)


## 🌳 Project Tree
```
.
├── components
│   ├── CustomBottomNavigatorbar.dart
│   └── EmployeeItem.dart
├── main.dart
├── models
│   ├── MainScreen_model.dart
│   ├── ScheduleModel.dart
│   └── ScheduleUtils.dart
├── providers
│   ├── mainScreen_provider.dart
│   ├── schedule_provider.dart
│   └── user_provider.dart
├── screens
│   ├── DeptSelectScreen.dart
│   ├── HomeTab.dart
│   ├── LoginScreen.dart
│   ├── MainScreen.dart
│   ├── MyPageTab.dart
│   ├── ScheduleTab.dart
│   ├── SettingsScreen.dart
│   ├── SignUpScreen.dart
│   └── SplashScreen.dart
├── services
│   └── api_service.dart
└── utils
    ├── CustomSnackBar.dart
    ├── LocalPushNotifications.dart
    ├── StatusUtils.dart
    └── time_utils.dart```
