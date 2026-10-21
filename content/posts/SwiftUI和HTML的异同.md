---
title: "SwiftUI和HTML的异同"
date: 2026-10-21T13:06:15+08:00
draft: false
slug: "similarities-and-differences-between-swiftui-and-html"
---

{{< bubble >}}那我再问你一个事情，就是我知道html的话，是个div，然后根据屏幕宽度不同，可以自适应，相当于一个可以拉伸的盒子。那么苹果这些界面，是个什么原理呢？也是这样一个个类似div的东西吗？{{< /bubble >}}

是，本质上是同类东西，但有一个**根本性的默认值差异**，这一点会让人困惑。

## 最大的区别：SwiftUI 的盒子默认“只包住自己”

HTML 里 `<div>` 默认**撑满父容器的宽度**，从左上往右下排。

SwiftUI 完全相反：**任何视图默认只占它内容需要的尺寸**，类似 CSS 里的 `display: inline-block` 或 `width: fit-content`。

所以：

- `Text("早")` 只有这一个字的宽度
- `VStack` 的宽度 = 它最宽的那个子视图
- 想让它撑满 → 必须**明确写出** `.frame(maxWidth: .infinity)`

这就是为什么你看我们的代码，几乎每张卡片里都有一句 `.frame(maxWidth: .infinity)`：没有它，卡片宽度就是内容宽度，会缩在左边。在 HTML 里，这类宽度本来由浏览器自动处理，不需要额外写规则。

## 第二个区别：布局按“父视图提议、子视图回应”进行，并非由父视图决定尺寸

CSS 的思路是：父容器确定宽度 → 子元素按规则计算。

SwiftUI 的流程是：

1. 父视图向子视图**提议**一个尺寸（“你有 390pt 宽”）
2. 子视图**自己决定**要多宽（“我只要 120pt”，或者“我要你给的 390pt”）
3. 父视图按子视图实际返回的尺寸摆放

`Text` 会拒绝过窄的提议（宁可换行）；`Spacer` 会把剩余空间全部吃掉；`ScrollView` 会提议无限大，因此它里面的内容永远“放得下”。

这个机制决定了：**内容会“协商”，不像 CSS 那样由父视图单向命令。**

## 对照表

| HTML / CSS | SwiftUI |
|---|---|
| `<div>` | `VStack` / `HStack` / `ZStack`（**必须选一个方向**） |
| `display: flex` | 默认就是这个（VStack = 竖排 flex） |
| `width: 100%` | `.frame(maxWidth: .infinity)` |
| `flex: 1` | `Spacer()` 或 `.layoutPriority()` |
| `max-width: 680px; margin: 0 auto` | `.frame(maxWidth: 680).frame(maxWidth: .infinity)` |
| `padding` | `.padding()` |
| `@media (max-width: 768px)` | `horizontalSizeClass`、`GeometryReader` |
| `overflow: auto` | `ScrollView` |
| `position: absolute` | `.overlay` / `.position` |
| `z-index` | `ZStack` 里的顺序 |

注意第一行：**HTML 的 div 不需要选方向**，浏览器按块级/行内决定。SwiftUI 里你必须**明确说**是横排还是竖排还是叠放，没有“默认流”。

## 第三个区别：没有 DOM，不能“找到那个元素去改”

HTML 有真实的节点树，JS 能 `querySelector` 拿到元素、改样式。

SwiftUI 里 `View` 是**结构体**，`body` 只是一份“图纸描述”。你不能“拿到那个按钮把它的颜色改掉”，只能**根据状态重新描述一遍界面**：`@State` 一变，整份 body 重新计算，系统内部对比出差异，只更新变了的那些。

所以它更像 React，而不是 jQuery。

## 还有一个差异：单位是“点”，不是像素

不用管 2x/3x、不用管 `rem`、不用管刘海遮挡：系统按逻辑点布局，其余由系统处理。屏幕安全区也会自动告诉你。

## 回到我们要做的事

我们的卡片结构长这样：

```
List
└ Section
   └ GroupedLogRow        ← 自己画圆角背景的那一层
      └ HStack
         ├ Text(时间)
         ├ Image(图标)
         ├ Text(内容)
         └ Spacer
```

`GroupedLogRow` 里用 `.frame(maxWidth: .infinity)` 让内容撑满整行；外层 `.padding(.horizontal, 20)` 让它离屏幕边 20pt。

**要在 iPad 上限宽 680 居中，只需要在容器上加一层：**

```
.frame(maxWidth: 680)          // 最多 680 宽
.frame(maxWidth: .infinity)    // 但在父容器里居中
```

这跟 CSS 的 `max-width: 680px; margin: 0 auto` **完全是一回事**，只需要加两行。

所以前面说的“限宽”那一步，成本比听起来低得多：**难点从来不在“怎么限宽”，而在“限宽之后，左右分栏怎么拆”。**