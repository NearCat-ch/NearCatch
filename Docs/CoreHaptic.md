# Core Haptic
https://developer.apple.com/documentation/corehaptics
https://developer.apple.com/videos/play/wwdc2019/520/
https://developer.apple.com/videos/play/wwdc2021/10278/

## Overview
<p>
Core Haptics를 사용하면 커스텀한 햅틱 및 오디오 피드백을 앱에 추가할 수 있습니다. 햅틱 및 오디오 피드백으로 사용자의 주의를 끌고 앱의 특정 동작의 의미를 좀 더 강화시키려고 할 때 사용합니다.
</p>
<p>
피커, 스위치 및 슬라이더와 같은 일부 시스템 인터페이스 UI요소는 사용자와 상호 작용할 때 햅틱 피드백을 자동으로 제공합니다. Core Haptics를 사용하면 기본 패턴 이상으로 Haptics를 구성하고 결합하여 이 기능을 확장할 수 있습니다.
</p>
<p>
앱은 햅틱 이벤트(CHHapticEvent)라고 하는 기본 구성 요소로 조작된 사용자 지정 햅틱 패턴을 재생할 수 있습니다. 이벤트는 스위치 전환에서 얻은 피드백과 같이 <b>일시적(transient)</b>일 수도 있고 벨소리에서 발생하는 진동이나 소리와 같이 <b>연속적(continuous)</b>일 수도 있습니다. 두 패턴을 개별적으로 사용하거나 두 패턴을 조합하여 만들 수도 있습니다. 햅틱 이벤트의 일부로 사용자 지정된 오디오 콘텐츠를 재생할 수도 있습니다.
</p>

### CHHapticEngine
.
### CHHapticPattern & AHAP File
.
### CHHapticAdvancedPatternPlayer
.

## Reference
https://developer.apple.com/documentation/corehaptics/delivering_rich_app_experiences_with_haptics
https://developer.apple.com/documentation/corehaptics/updating_continuous_and_transient_haptic_parameters_in_real_time
https://developer.apple.com/documentation/corehaptics/representing_haptic_patterns_in_ahap_files