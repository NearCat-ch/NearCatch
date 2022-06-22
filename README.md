![MC2-Team13-gitgubLogo](https://user-images.githubusercontent.com/74142881/173856730-d5746d2a-d2d2-44af-a28e-299bb2d02371.png)


# :iphone: Near Catch 니어 캐치

닉네임과 관심사를 등록하고 다양한 사람들과 어울려 친해질 수 있는 환경에서 함께 즐길 수 있는 아이스 브레이킹 용 Gamification App입니다.
> WWDC20 에서 발표한 Nearby Interaction을 사용한 어플리케이션입니다 Multipeer Connectivity를 통해 동일한 와이파이 환경, 또는 Peer-to-Peer 와이파이, 블루투스를 통해 근처 주변 디바이스와 서로의 관심사를 비교합니다.
이후 관심사가 일치하는 항목이 3개 이상일때 진동으로 앱 사용자에게 알려주고, 두 사람이 가까이서 스마트폰을 서로 교차하면 공통 키워드가 모달형식으로 뜹니다. <br>

1. For What `Situation`
- 다수의 아이폰 사용자가 처음 만나 어색한 자리
- 애플 아카데미의 각종 행사
- iOS 개발자 컨퍼런스
- `WWDC`

2. `Who` it's for
- 애플 아카데미에 입학해 처음 보는 주니어, 시니어 러너
- 애플 관련 컨퍼런스에 참석한 개발자들
- 평소에 다른 사람들과 친해지고 싶지만 대화주제를 몰라 어려워했던 아이폰 사용자들
- 좀더 많은 사람들과 쉽게 친해지고 싶은 아이폰 사용자들


## :pushpin: Features

- 프로필 등록 : 닉네임, 사진, 관심사 등을 등록하고 수정
- 내 주변 어플 사용자 명수 확인 : 내 주변 어플을 통해 탐색중인 인원 수 표시
- 햅틱 알람 : 공통 관심사가 있는 사람이 주변에 오면 심장소리 진동 알람
- 공통 관심사 확인 : Bump Action을 통해 상대방과 나의 공통 관심사 키워드 확인


## :framed_picture: Demo

### [⭐️ NearCatch ⭐️](https://youtu.be/bBylSazJQlQ)유튜브 영상데모 보러가기
### [⭐️ 사용방법 ⭐️](https://youtu.be/0zftlcXqkXs)시뮬레이터 작동영상 보러가기

## 🌈 Design Guide 

![DsignGuide](https://user-images.githubusercontent.com/74142881/174117058-45b0cfa1-9734-4d47-8f7c-a270bbec5095.png)


## :fireworks: Screenshots

| 닉네임 설정 | 관심사 저장 | Home |
|:---:|:---:|:---:|
|![App Screenshot](https://user-images.githubusercontent.com/74142881/173845513-cb0707fd-6432-4818-b29c-6e98c53c5015.png)|![App Screenshot](https://user-images.githubusercontent.com/74142881/173845509-1b33de95-3e87-4ab2-bd0b-5bda5d53bbb4.png)|![App Screenshot](https://user-images.githubusercontent.com/74142881/173845502-ac5fe7f8-ce3e-40e7-a974-b2b248fb08a3.png)|

<br>

| 니어캣 탐색 중 | 니어캣 탐색 완료 | 공통 관심사 모달 |
|:---:|:---:|:---:|
|![App Screenshot](https://user-images.githubusercontent.com/74142881/173845517-a7926515-d480-4ef2-8fee-33c0ed2b20e3.png)|![App Screenshot](https://user-images.githubusercontent.com/74142881/173845489-8a10572b-86b3-48df-b407-6dde962e5a13.png)|![App Screenshot](https://user-images.githubusercontent.com/74142881/173845505-2cd0a6b2-f64c-483e-b340-bd6d0d48a6a4.png)|

## :sparkles: Skills & Tech Stack
1. 이슈관리 : Miro
2. 형상관리 : Github
3. 커뮤니케이션 : Ryver, Notion, Zoom<br>
4. 개발환경
- OS : MacOS(M1Pro)
- IDE : Xcode 13.4.1
5. 상세사용
- Application : SwiftUI
- Design : Sketch, AfterEffect, Illustrator<br>
6. 라이브러리
```swift
import swiftUI
import UIKit
import NearbyInteraction
import MultipeerConnectivity
import Lottie
import CoreData
import CoreMotion
import CoreHaptics
```
## 🔀 Git

1. Commit 컨벤션
    - `feat` : 새로운 기능 추가
    - `fix` : 버그 수정
    - `docs` : 문서 (README, 포팅메뉴얼)
    - `test` : 테스트 코드
    - `refactor` : 코드 리팩토링 (기능 말고 성능 개선)
    - `style` : 코드 의미에 영향을 주지 않는 변경 사항
    - `chore` : 빌드, 설정 파일
    - `comment` : 주석이 추가되는 경우.
    
2. 규칙
    - 제목의 길이는 50글자를 넘기지 않는다
    - 제목의 마지막에 마침표를 사용하지 않는다
    - 본문을 작성할 때 한 줄에 72글자 넘기지 않는다
    - 과거형을 사용하지 않는다
    - 커밋 메시지는 **영어**로 작성한다   
```bash
feat: Summarize changes in around 50 characters or less

This is a body part. Please describe the details of commit.
```
3. Git 브랜치
    - `master` : 배포
    - `develop` : 개발된 기능(feature)을 통합하는 브랜치
    - `docs` : 문서작업 브랜치
    - `feature/[function name]` : 각 기능별 개발을 진행하는 브랜치
    - `release/[version]` : 배포 전, 현재까지의 develop 상태를 가져와서 버그 픽스하고 지금 상태까지를 현재 개발 중인 버전으로.
    - `hotfix/[version]` : 배포한 것을 급하게 수정
    - 띄어쓰기, 구분 필요한 경우 대쉬

## :people_hugging: Authors

- [@김예훈](https://github.com/eraser3031) | [@류현선](https://www.github.com/hs-ryu) | [@이준영](https://github.com/User-Lawn) | [@조현민](https://github.com/uudquark) | [@최원혁](https://github.com/DevLuce) | [@황찬기](https://github.com/DevMizeKR)
  
## :books: Documentation

[Documentation](./Docs/)


## :lock_with_ink_pen: License

[MIT](https://choosealicense.com/licenses/mit/)
[Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0.txt)
