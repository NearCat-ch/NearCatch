//
//  TagView.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/13.
//

import SwiftUI

class TagViewModel : ObservableObject {
    
    @Published var Tags = [Tag]()
    
    init() {
        self.Tags =
        [
            Tag(index: 0, name: "게임"),
            Tag(index: 1, name: "강아지"),
            Tag(index: 2, name: "드라마"),
            Tag(index: 3, name: "피트니스"),
            Tag(index: 4, name: "테니스"),
            Tag(index: 5, name: "고양이"),
            Tag(index: 6, name: "넷플릭스"),
            Tag(index: 7, name: "아웃도어"),
            Tag(index: 8, name: "요리"),
            Tag(index: 9, name: "책읽기"),
            Tag(index: 10, name: "애완동물"),
            Tag(index: 11, name: "수영"),
            Tag(index: 12, name: "프로그래밍"),
            Tag(index: 13, name: "이동"),
            Tag(index: 14, name: "운전"),
            
            Tag(index: 15, name: "축구"),
            Tag(index: 16, name: "스포츠"),
            Tag(index: 17, name: "스노보드"),
            Tag(index: 18, name: "농구"),
            Tag(index: 19, name: "야구"),
            Tag(index: 20, name: "MBTI"),
            Tag(index: 21, name: "커피"),
            Tag(index: 22, name: "댄스"),
            Tag(index: 23, name: "스키"),
            Tag(index: 24, name: "패션"),
            Tag(index: 25, name: "보드게임"),
            Tag(index: 26, name: "사진촬영"),
            Tag(index: 27, name: "쇼핑"),
            Tag(index: 28, name: "양궁"),
            Tag(index: 29, name: "술"),
            
            Tag(index: 30, name: "영화"),
            Tag(index: 31, name: "자동차"),
            Tag(index: 32, name: "파티"),
            Tag(index: 33, name: "산책"),
            Tag(index: 34, name: "대화"),
            Tag(index: 35, name: "스케이트보드"),
            Tag(index: 36, name: "홈트"),
            Tag(index: 37, name: "맛집탐방"),
            Tag(index: 38, name: "요가"),
            Tag(index: 39, name: "만화책"),
            Tag(index: 40, name: "하키"),
            Tag(index: 41, name: "글쓰기"),
            Tag(index: 42, name: "명상"),
            Tag(index: 43, name: "메이크업"),
            Tag(index: 44, name: "크리켓"),
            
            Tag(index: 45, name: "음악"),
            Tag(index: 46, name: "K-Pop"),
            Tag(index: 47, name: "언어교환"),
            Tag(index: 48, name: "온천"),
            Tag(index: 49, name: "무술"),
            Tag(index: 50, name: "마블 시리즈"),
            Tag(index: 51, name: "헬스장"),
            Tag(index: 52, name: "러닝"),
            Tag(index: 53, name: "여행"),
            Tag(index: 54, name: "타투"),
            Tag(index: 55, name: "스킨케어"),
            Tag(index: 56, name: "K-드라마"),
            Tag(index: 57, name: "주식"),
            Tag(index: 58, name: "VR 체험"),
            Tag(index: 59, name: "시"),
            
            Tag(index: 60, name: "소셜 미디어"),
            Tag(index: 61, name: "돈"),
            Tag(index: 62, name: "스포츠"),
            Tag(index: 63, name: "배구"),
            Tag(index: 64, name: "밴드"),
            Tag(index: 65, name: "디즈니"),
            Tag(index: 66, name: "PC방"),
            Tag(index: 67, name: "수집"),
            Tag(index: 68, name: "등산"),
            Tag(index: 69, name: "밈"),
            Tag(index: 70, name: "노래방"),
            Tag(index: 71, name: "주짓수"),
            Tag(index: 72, name: "복싱"),
            Tag(index: 73, name: "아쿠아리움"),
            Tag(index: 74, name: "인스타그램"),
            
            Tag(index: 75, name: "애플"),
            Tag(index: 76, name: "사진"),
            Tag(index: 77, name: "새로운 것 도전하기"),
            Tag(index: 78, name: "넷플릭스"),
            Tag(index: 79, name: "유튜브"),
            Tag(index: 80, name: "차(tea)"),
            Tag(index: 81, name: "스탠드업 코미디"),
            Tag(index: 82, name: "자전거"),
            Tag(index: 83, name: "재테크"),
            Tag(index: 84, name: "크로스핏"),
            Tag(index: 85, name: "리그 오브 레전드"),
            Tag(index: 86, name: "참뼈")
            









        
        ]
    }
    
}
