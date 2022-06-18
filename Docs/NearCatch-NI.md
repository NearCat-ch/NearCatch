# NearCatch Nearby Interaction
[Nearby Interaction Documentation](./Nearby-Interaction.md) <br>
[NI 관련 코드 디렉토리](../NearCatch/Utils/NIUtils/) 

## Flow

'니어캐치'에서 동작하는 Nearby Interaction 프레임워크의 동작 플로우는 아래와 같습니다.

### 1. Multipeer Connectivity 세션 실행
Nearby Interaction 세션이 작동하기 위해서는 위치 정보를 공유할 디바이스의 NIDiscoveryToken을 알아야합니다. 따라서 이 토큰을 무선으로 전송할 통신 수단이 필요합니다. '니어캐치'에서는 토큰 교환 수단으로 Multipeer Connectivity 프레임워클를 사용하였습니다. <br>
MC(Multipeer Connectivity) 세션은 Advertising과 Browsing을 통해 근처 peer들의 연결과 끊김을 감지할 수 있고 연결된 피어에게 데이터를 전송할 수 있습니다.   

### 2. NIDiscoveryToken과 관심사 데이터 공유
MC로 연결된 peer들과 거리, 방향 공유가 가능한 Nearby Interaction으로 연결하기 위해서는 NIDiscoveryToken이 필요합니다. 따라서 MC로 하나의 peer가 연결되었을 때 NISession을 생성하여 그 세션의 NIDiscoveryToken을 연결된 해당 peer에 전송합니다. **여기서 중요한 사항은 해당 세션의 NIDiscoverToken을 어느 peer에 공유했는지 알 수 있도록 맵핑하는 딕셔너리 자료구조를 구축해야합니다.**

### 3. Nearby Ineraction 세션 실행
연결된 peer에 NIDiscoveryToken을 전달하고 상대 NIDiscoveryToken을 전달받으면 NISession에 받은 토큰을 지정하고 실행합니다. 이를 통해 고유한 토큰을 가진 상대 세션과 연결을 유지할 수 있게합니다.   

### 4. NI 세션을 통한 거리, 방향 공유 (NI세션 <-> MCPeerID 맵핑)
동시에 여러 디바이스들과 Nearby Interaction 통신을 유지하기 위해 디바이스 개수만큼 NI세션을 생성하고 그 NI세션과 MCPeerID를 맵핑한 딕셔너리를 사용합니다. 따라서 어느 디바이스가 어느 거리, 방향을 가지는지 확인할 수 있습니다.  

### 5. 거리에 따라 액션 트리거
어느 디바이스가 어느 거리, 방향을 가지는지 지속적인 파악이 가능하기 때문에 특정 디바이스와의 거리에 따라 원하는 액션을 수행시킬 수 있습니다. <br>
'니어캐치'에서는 가장 관심사가 일치하는 디바이스를 MC를 통해 파악하고 해당 디바이스와의 거리에 따라 햅틱진동 액션에 변화를 줍니다. <br>
어느 디바이스가 8cm 이하로 가까워지면 그 디바이스의 NI세션과 맵핑된 MC로 나의 정보를 전송하여 '범프' 액션을 수행합니다.   

## Issues & Trouble shootings
1. Nearby Interaction의 자료 및 예시 소스 부족

        WWDC2020에서 공개된 Nearby Interaction 프레임워크는 아직까지 상용 앱에서 보편화된 기술이 아니며 활용 방안도 크게 없어 간혹 써드파티 기기들과의 통신 수단으로 사용하는 것이 전부입니다.
        따라서 공식 문서 활용, WWDC에서 공개한 데모 소스 코드와 다른 개발자들이 공유한 실습 코드 분석과 가설/검증 방식으로 여러번 테스트를 통해 구현을 진행하였습니다. 

2. SwiftUI로의 전환

        WWDC2020에서의 Nearby Interaction 데모 소스 코드는 UIKit으로 공개되어 이를 SwiftUI에서 활용할 수 있는 코드로 전환하는 과정이 필요했습니다. 게다가 Nearby Interaction 뿐만 아니라 Multipeer Connectivity를 같이 활용해야하는 기술이기 때문에 더 어려운 과정이었습니다.
        이는 UIKit에서 SwiftUI로 전환된 여러 오픈소스 프로젝트를 참고하고 공식 문서를 참고하여 클래스를 SwiftUI에 맞게 옮기는 과정을 가졌습니다. 그리고 다행히 WWDC2022에서 Nearby Interaction에 대한 새로운 데모 소스 코드가 SwiftUI로 공개되어 좀 더 standard한 방식으로 구현하는 데 도움이 되었습니다.

3. 여러 디바이스와의 연결

        가장 큰 트러블을 겪은 사항입니다. WWDC 데모 소스, 여러 개발자들이 작성한 실습 코드들은 모두 '두 기기'만의 Nearby Interaction 통신을 지원하였습니다. '니어캐치'는 여러 디바이스와의 동시 통신이 필요했기 때문에 이를 해결하는데 큰 어려움을 겪었습니다.
        결국 애플 개발자 포럼과 Stackoverflow를 통해 다중 연결을 위해서는 통신 상대 만큼의 세션 생성이 필요하다는 점을 알게되었고 이 로직을 작성하는데에도 많은 테스트와 검증을 거쳐 구현하였습니다. 또한 테스트하기위해 디바이스가 많이 필요한 상황이라 테스트 과정에서도 어려움을 겪었습니다. 

4. 다중 통신시에 발생하는 성능 저하

        다중 통신을 위해서 통신 상대만큼의 세션을 생성해야합니다. '니어캐치'는 레크리에이션을 위해 개발된 앱이기 때문에 100개 디바이스의 통신도 필요한 상황입니다. 그렇다면 한 기기당 100개의 세션이 생성 가능해야 하며 그 100개의 세션들이 지속해서 거리, 방향 정보를 양방향으로 송수신 해야합니다. 이는 휴대폰 리소스를 많이 소요하며 이는 결국 앱의 성능 저하로 이어집니다.
        이를 해결할 더 효율적인 방안을 찾고 있으며 현재는 세션을 멀티쓰레드에서 비동기로 생성하고 실행하여 작업이 밀려 반응이 늦어지는 상황이 없어지도록 1차적인 해결 로직을 작성하였습니다. 