# Multipeer Connectivity
https://developer.apple.com/documentation/multipeerconnectivity

## Overview
Multipeer Connectivity 프레임워크는 주변 근처 디바이스가 제공하는 서비스를 탐색을 지원하고 메시지 기반 데이터, 스트리밍 데이터, 파일과 같은 리소스의 통신을 지원합니다. (iOS 7부터 지원) <br>
iOS에서는 infrastructure Wi-Fi 네트워크, peer-to-peer Wi-Fi 네트워크, Bluetooth 개인 영역 네트워크를 통해 통신합니다.<br>
macOS와 tvOS에서는 infrastructure Wi-Fi 네트워크, peer-to-peer Wi-Fi 네트워크, 이더넷을 통해 통신합니다

## Description
Multipeer Connectivity 프레임워크는 Bonjour 프로토콜 상에서 레이어를 제공합니다. 이 프레임워크는 자동으로 적절한 네트워킹 기술(두 디바이스가 동일한 Wi-Fi 네트워크에 있는 경우 infra Wi-Fi, 그 외 P2P Wi-Fi 혹은 Bluetooth)을 선택합니다.

### Advertising & Browsing
두 기기간의 통신은 Advertising 과 Browsing을 통해 서로를 인식함으로써 시작됩니다. Advertising 은 다른 peer들에게 서비스를 알리고 Browsing 은 반대로 Advertising 을 한 다른 peer들을 인식합니다.

### MCSession
MCSession 객체는 Multipeer Connectivity 세션 내 모든 peer들 간의 통신을 활성화하고 관리합니다. Session을 설정한 후에는 다른 peer에 데이터를 전송할 수 있습니다.

### Data
Multipeer Connectivity 프레임워크는 세 가지 데이터 전송 형식을 가집니다. 
- Messages : 짧은 텍스트 혹은 직렬화된 작은 객체와 같이 명확한 경계를 가진 정보
- Streams : 오디오, 비디오 또는 실시간 센서 이벤트와 같은 데이터를 지속적으로 전송하는 개방형 정보 채널
- Resources : 이미지, 동영상, 문서와 같은 파일

## Reference
https://www.ralfebert.com/ios-app-development/multipeer-connectivity/ <br>
https://nshipster.com/multipeer-connectivity/
https://www.toptal.com/ios/ <br> collusion-ios-multipeerconnectivity