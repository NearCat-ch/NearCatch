# Nearby Interaction
https://developer.apple.com/documentation/nearbyinteraction <br>
https://developer.apple.com/videos/play/wwdc2020/10668 <br>
https://developer.apple.com/videos/play/wwdc2022/10008

## Overview
Nearby Interaction 프레임워크를 사용하면 U1 혹은 UWB(Ultra Wide Band)칩을 가지고 있는 장치(iPhone 11 이상, Apple Watch, 써드파티 액세서리)의 위치 정보를 얻을 수 있습니다. (iOS 14부터 지원) <br>
물리적으로 근처에 위치한 디바이스는 상호 작용을 하기 위해 위치 정보와 고유 식별 가능한 디바이스 토큰을 공유합니다. 앱이 foreground상에서 실행하고 있을 때, Nearby Interaction은 peer의 **방향과 거리 정보를 미터 단위**로 상호 작용 Session에 알립니다. <br>

*iOS는 peer 디바이스의 거리와 방향 정보를 제공하지만, watchOS는 peer 디바이스의 거리 정보만을 제공합니다.*

## Description
Nearby Interaction 프레임워크는 최대 약 9m 거리의 디바이스들과 통신이 가능하며 거리, 위치, 고유 토큰 데이터를 공유합니다. 이 데이터들은 세션을 통해 지속적인 스트림을 통해 업데이트됩니다.

### NIDiscoveryToken
Nearby Interaction 통신을 하기 위해서는 통신을 원하는 상대 디바이스의 NISession이 가지는 고유한 NIDiscoveryToken을 알아야합니다. 통신할 상대의 NIDiscoverToken을 전달받기 위해서는 iCloud, [Multipeer Connectivity](./Multipeer-Connectivity.md), sockets, Bonjour 등의 프레임워크를 사용하여 데이터 통신을 해야합니다.

### NISession
NISession 객체는 Nearby Interaction 세션의 통신을 활성화하고 관리합니다. 데이터 통신을 통해 전달받은 NIDiscoveryToken을 통해 NISession을 설정하고 세션을 실행합니다. 이를 통해 보안성을 유지하며 원하는 디바이스와 거리, 방향 정보를 공유할 수 있습니다. 유저가 앱을 닫거나 Foreground 상태를 유지하지 않으면 세션은 손실됩니다.

### Data
Nearby Interaction 프레임워크는 다음 세 가지 정보를 공유합니다.
- discoveryToken : 통신하는 디바이스 세션을 식별할 수 있는 고유 토큰
- 거리 : 통신하는 디바이스와 현재 디바이스 간의 거리 값
- 방향 : 현재 디바이스로부터 통신하는 디바이스의 상대적인 방향

### Multiple Interaction
한 개의 NISession은 peer-to-peer 통신이므로 여러 디바이스와 상호작용을 하기 위해서는 여러 개의 NISession 객체를 생성해야합니다. 따라서 여러 디바이스와의 Nearby Interaction을 유지하기 위해서는 각 디바이스가 가지는 고유 ID를 추적하여 각 세션의 NIDiscoveryToken을 맵핑하여야 합니다. <br>
https://developer.apple.com/forums/thread/652180 <br>
https://developer.apple.com/forums/thread/661148 <br>
https://stackoverflow.com/questions/66287186/how-to-connect-multiple-devices-implement-multiple-ongoing-sessions-using-appl/67223540#67223540


## Reference
https://developer.apple.com/forums/thread/652180 <br>
https://developer.apple.com/forums/thread/661148 <br>
https://developer.apple.com/forums/thread/670374 <br>
https://stackoverflow.com/questions/66287186/how-to-connect-multiple-devices-implement-multiple-ongoing-sessions-using-appl/67223540#67223540 <br>
https://github.com/yoshimin/NearbyInteractionDemo