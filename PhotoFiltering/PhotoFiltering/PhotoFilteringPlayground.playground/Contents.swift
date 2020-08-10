import UIKit
import RxSwift
import RxCocoa

//Preventing memory leak - it will keep track of the observable to dispose in the correct moment
let disposableBag = DisposeBag()

//Creating observers
let observable = Observable.from([1,2,3,4])

//subscribing (iterating)
observable.subscribe { event in
    if let element = event.element {
        print(element)
    }
}.disposed(by: disposableBag)

//another way of subscribe
let subscription = observable.subscribe(onNext: {element in
    print(element)
})

//preventing memory leak
subscription.dispose()
