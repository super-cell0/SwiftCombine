# 1.Swift Combine
Combine 是一个声明式的响应式框架，用于随着时间的推移处理异步事件。
它旨在解决现有问题，例如统一异步编程工具，处理可变状态以及使用错误处理
Combine 围绕三种主要类型展开：发布者随时间推移发出事件，运算符异步处理和操作上游事件，订阅者使用结果并对其进行有用的操作。

<!---->
# 2.Publishers & Subscribers

<!---->
##publisher发出两种事件：
1 elements
2 completion event

<!--publisher-->
发布者可以发出零个或更多值，但只有一个完成事件，这可以是正常的完成事件，也可以是错误。一旦发布者发出完成事件，它就完成了，不能再发出任何事件

<!--订阅-->
sink操作员将继续收到出版商发出的尽可能多的值——这被称为无限需求。尽管您在上一个示例中忽略了它们，但sink运算符实际上提供了两个闭包：
1 一个用于处理接收完成事件（成功或失败 receiveCompletion
2一个用于处理接收值 receiveValue

<!---->
just 是一个publisher

<!--订阅-->
除了sink外，内置的assign(to:on:)运算符允许您将接收值分配给对象的KVO兼容属性。

PassthroughSubject 的特点是没有任何缓冲，它会立即将接收到的任何值发送给所有当前的订阅者
CurrentValueSubject 的特点是它会保留最新的值，并将其发送给新的订阅者
