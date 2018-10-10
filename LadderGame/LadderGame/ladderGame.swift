//
//  ladderGame.swift
//  LadderGame
//
//  Created by 김장수 on 2018. 10. 1..
//  Copyright © 2018년 Codesquad Inc. All rights reserved.
//

import Foundation

// LadderGame 객체는 사다리를 추상화한 형태로 생성

struct LadderGame {
    private var height = 0
    private var players = [LadderPlayer]()
    private var step: LadderStep
    
    init(height: Int, names: String, leg: Bool) {
        self.height = height
        self.step = LadderStep.init(have: leg)
        for name in makeList(names) {
            self.players.append(LadderPlayer.init(name: name))
        }
    }
    
    func delieverDTO() -> LadderGameDTO {
        var dto = LadderGameDTO()
        
        dto.ladder = makeLadderWith()
        dto.players = players
        return dto
    }
    
    // 이름을 배열로 바꿔주는 함수
    private func makeList(_ names: String) -> [String] {
        return names.split(separator: ",").map({String($0)})
    }
    
    // 중복을 바꿔주는 함수
    private func changeLegToEmpty(before: Bool, after: Bool) -> Bool {
        var result = after
        
        if before && after {result = false}
        return result
    }
    
    // 사다리가 옆으로 연속해서 나오는 걸 방지하는 함수
    private func preventOverlap(legs: [Bool]) -> [Bool] {
        var refined = legs
        
        for i in 0..<(refined.count-1) {
            refined[i+1] = changeLegToEmpty(before: refined[i], after: refined[i+1])
        }
        return refined
    }
    
    // 사다리가 옆으로 연속해서 나오지 검증하는 함수
    // 연속해서 나올 가능성이 있을/없을 경우로 분리
    private func checkSuccession(line: [Bool]) -> [Bool] {
        if line.count > 1 {return preventOverlap(legs: line)}
        return line
    }
    
    // 한 계단을 만드는 함수
    private func makeOneStepAlong(_ number: Int, _ step: LadderStep) -> [Bool] {
        var steps = [Bool]()
        var step = step
        
        for _ in 1..<number {
            steps.append(step.isExist(Int(arc4random_uniform(2))))
        }
        return checkSuccession(line: steps)
    }
    
    // 사다리를 만드는 함수
    private func makeLadderWith() -> [[Bool]] {
        var steps = Array(repeating: [Bool](), count: height)
        
        for i in 0..<height {
            steps[i] = makeOneStepAlong(players.count, step)
        }
        return steps
    }
}