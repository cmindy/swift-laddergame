//
//  main.swift
//  LadderGame
//
//  Created by JK on 09/10/2017.
//  Copyright © 2017 Codesquad Inc. All rights reserved.
//

import Foundation

enum stateInput {
    case completeInput
    case faultInput
}

// 참여할 사람의 숫자를 사용자로 부터 입력받음
func inputNumberOfPeoples() -> Int{
    let inputFromUser = readLine()!
    guard let inputNumberOfPeoples = Int(inputFromUser) else{
        return -1
    }
    return inputNumberOfPeoples
}

// 최대 사다리 높이를 사용자로부터 입력받음 --> 숫자말고 다른 타입을 입력했을 경우 -1을 반환
func inputHeightOfLadder() -> Int{
    let inputFromUser = readLine()!
    guard let inputHeightOfLadder = Int(inputFromUser) else {
        return -1
    }
    return inputHeightOfLadder
}

// 사용자가 숫자를 제대로 입력했는지 확인 --> 제대로 입력한 경우 True를 반환
// Ex) 음수를 입력하거나 숫자와 스트링을 섞어서 입력한 경우 False를 반환
func isRightUserInput(userInput : Int) -> Bool{
    return userInput != -1 && userInput > 0
}

// 랜덤 함수로 1일 경우 "-"생성을 위해 true를 반환, 0일 경우 " "생성을 위해 false를 반환
func isExistLadder() -> Bool{
    return arc4random_uniform(2) == 0
}

// isExistLadder함수의 결과로 ture일 경우 "-"를 생성, false일 경우 " "을 생성
func createLadderOrSpace() -> String{
    guard isExistLadder() else{
        return " "
    }
    return "-"
}

// 입력받은 사람 수와 사다리 최대 높이에 따라 사다리를 초기화
func initializeLadder(peopleCount : Int, heightLadder : Int) -> [[String]]{
    return Array(repeating: Array(repeating: "|", count: peopleCount), count: heightLadder)
}

// 사람과 사람 사이 랜덤으로 "-", " " 둘 중 하나를 생성시킴
func addRandomLadder(initialLadder : [[String]], peopleCount : Int, heightLadder : Int) -> [[String]]{
    var completeLadder : [[String]] = initialLadder
    for i in 0..<heightLadder{
        completeLadder[i] = addColummRandomLadder(rowLadder: completeLadder[i])
    }
    return completeLadder
}

// 각 행별로 따로 때어와서 addColummRandomLadder()에서 열에 랜덤으로 "-", " " 추가
func addColummRandomLadder(rowLadder : [String]) -> [String]{
    var addElementInLadder : [String] = rowLadder
    for index in 0..<rowLadder.count-1{
        addElementInLadder.insert(createLadderOrSpace(), at: 2*index+1)
    }
    return addElementInLadder
}

// 생성된 사다리 콘솔창에 출력
func printLadder(outputLadder : [[String]], heightLadder : Int){
    for i in 0..<heightLadder{
        printColummElement(rowLadder: outputLadder[i])
        print("")
    }
}

// 각 행별로 존재하는 Columm 요소 콘솔창에 출력
func printColummElement(rowLadder : [String]){
    for colummElement in rowLadder{
        print("\(colummElement)", terminator: "")
    }
}

func main(){
    var inputFromUserPeopleCount : Int = -1
    var inputFromUserHeightLadder : Int = -1

    var peopleInputState : stateInput = .faultInput
    var heightInputState : stateInput = .faultInput

    while peopleInputState != .completeInput || heightInputState != .completeInput{
        if peopleInputState == .faultInput{
            print("참여할 사람은 몇 명 인가요?")
            inputFromUserPeopleCount = inputNumberOfPeoples()
            if isRightUserInput(userInput: inputFromUserPeopleCount){
                peopleInputState = .completeInput
            }
        }

        if heightInputState == .faultInput{
            print("최대 사다리 높이는 몇 개인가요?")
            inputFromUserHeightLadder = inputHeightOfLadder()
            if isRightUserInput(userInput: inputFromUserHeightLadder){
                heightInputState = .completeInput
            }
        }
    }

    var ladder : [[String]] = initializeLadder(peopleCount: inputFromUserPeopleCount, heightLadder: inputFromUserHeightLadder)
    ladder = addRandomLadder(initialLadder: ladder, peopleCount: inputFromUserPeopleCount, heightLadder: inputFromUserHeightLadder)

    printLadder(outputLadder: ladder, heightLadder: inputFromUserHeightLadder)
}

main()
