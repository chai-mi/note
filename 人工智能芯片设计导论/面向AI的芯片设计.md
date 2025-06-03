# 面向 AI 的处理器设计

- [面向 AI 的处理器设计](#面向-ai-的处理器设计)
  - [AI 背景介绍](#ai-背景介绍)
  - [CNN 的 IP 方案介绍](#cnn-的-ip-方案介绍)
    - [GPU 类](#gpu-类)
    - [DSP 类](#dsp-类)
    - [ASIC 类](#asic-类)
    - [ASIP 类](#asip-类)
  - [AI ASIP 处理器架构设计](#ai-asip-处理器架构设计)
    - [需求分析](#需求分析)
    - [软硬件切割](#软硬件切割)
    - [架构定义](#架构定义)
      - [数据重用](#数据重用)
      - [weight 重用](#weight-重用)
      - [计算并行度](#计算并行度)
      - [DDR 带宽](#ddr-带宽)
      - [MAC 利用率](#mac-利用率)
    - [指令集定义](#指令集定义)
    - [指令集模拟器开发 (ISS)](#指令集模拟器开发-iss)
    - [ISS 仿真 \& 架构优化迭代](#iss-仿真--架构优化迭代)
  - [AI ASIP 处理器实现难点](#ai-asip-处理器实现难点)
    - [AI ASIP 处理器 RTL 开发过程中的注意事项](#ai-asip-处理器-rtl-开发过程中的注意事项)
    - [AI ASIP 处理器验证过程中的难点](#ai-asip-处理器验证过程中的难点)
    - [AI ASIP 处理器物理实现的难点](#ai-asip-处理器物理实现的难点)
  - [AI ASIP 处理器配套工具链](#ai-asip-处理器配套工具链)

## AI 背景介绍

世界三大尖端技术

- 空间技术
- 能源技术
- 人工智能

卷积神经网络由很多层组成

- 卷积层：卷积运算的目的是提取输入的不同特征
- 池化层
  - 对输入的特征图进行压缩，使特征图变小，简化计算
  - 进行特征压缩，取其最大、最小或平均值，得到新的、维度较小的特征
- 线性整流层：引入非线性，引入非线性之后就可以逼近任意函数
- 全连接层：把所有局部特征结合变成全局特征，用来计算最后每一类的得分

## CNN 的 IP 方案介绍

CNN 计算特点

- 操作相对固定
- 计算量大
- 需要的带宽大

CNN IP 方案分类

- GPU 类
- DSP (digital signal processor，数字信号处理器) 类
- ASIC (Application Specific Integrated Circuit，专用集成电路) 类
- ASIP (Application Specific Integrated Processor，专用集成处理器) 类

### GPU 类

GPU 特点

- 多核并行计算，且核心数非常多，可以支撑大量数据的并行计算
- 拥有更高的访存速度
- 更高的浮点运算能力
- GPU 在深度学习领域，特别是训练方面非常适合

NVIDIA

- NVIDIA GPU 有完善的工具包，可用于所有主要的深度学习
- NVIDIA GPU 通过 PCI-e 接口可以直接部署在服务器中，方便
而快速

框架：TensorFlow、Caffe 等

### DSP 类

Cadence VP6

- 指令丰富，专门定制了一些针对深度学习的指令
- 提供深度学习库
- VLIW
- SIMD
- 256 MACS

### ASIC 类

NVDLA

- CSB/Interrupt interface：主控通过 CSB 配置 NVLDA，NVDLA 完成任务后，返回中断
- DBB interface：memory 总线接口，连接 DDR
- second DBB interface : memory 总线接口，连接片上 SRAM
- Convolution core : 负责 CONV 和 FC 操作
- Activation engine (SDP) ：负责 RELU/BN/ELTWISE 等操作
- Pooling engine (PDP) ：负责 POOLING 操作
- Local resp. norm (CDP) ：负责 cross channel – LRNReshape
- RUBIK/DMA：负责 SPLIT / CONCAT/RESHAPE等

### ASIP 类

寒武纪

- 专门针对某种特定的应用和算法定制的处理器，自定义指令集
- 具备 ASIC 的高效性和 DSP 的灵活性
- Control Processor：给各个模块下发自定义指令
- Nbin：存储 input feature map
- SB：存储 kernel
- Nbout：存储 output feature map
- DMA：用于 Buffer 的数据搬运
- NFU：用于 CNN 各个 layer 的计算

云天励飞 NNP

- 自定义指令
  - 100+ 条自定义指令
  - 50% 针对 AI 操作特殊定制
- NU
  - CNN 处理核心
  - 多个基本处理单元 PE 组成
  - 15 级流水
- CU
  - 指令广播、任务调度
  - 8 级流水

## AI ASIP 处理器架构设计

步骤（流程）

- 算法需求分析
- 软硬件切割
- 架构定义
- 指令集定义
- 指令集模拟器开发 ( ISS)
- ISS 仿真 & 架构优化迭代
- 确定微架构和指令集，进入开发阶段

### 需求分析

算法需求分析

- AI 算法的基本流程、算法中使用的 CNN 模型
- CNN 模型中需要哪些层、哪些基本操作、哪些特殊的操作
- 操作是否具有通用性，扩展性
- ASIP 是否能独立完成算法，是否需要系统其它模块配合

产品需求分析

- 产品应用场景
- ASIP 处理能力 (频率、算力)
- 系统能提供多少带宽，以及结合算法和应用，需要多少带宽

### 软硬件切割

ASIP 是针对特定的算法和应用定制的处理器，它兼顾了 ASIC 高效性的以及 DSP 的灵活性。ASIP 可以支持丰富的指令集，例如

- 循环、跳转、子程序调用指令
- 基本的算术和逻辑运算指令
- 针对 CNN 特殊定制的运算指令

针对 ASIP 的合理的软硬件切割，可以事半功倍

- 一些复杂的控制以及状态机可以通过使用 ASIP 指令编程实现
- ASIP 中的数据搬运直接使用 DMA 硬件实现
- 使用大颗粒度指令，提高 ASIP 编程和硬件操作效率

某些情况下，可以考虑 ASIP + ASIC 的方式，把 ASIC 作为 ASIP 的加速单元完成某类特定运算

- 某些运算比较难融入到当前 ASIP 处理器的设计中，或者某些运算使用频率非常高，使用 ASIP 来计算不划算的时候，可以利用加速器对 ASIP 扩展
- ASIP 处理器的指令集以及硬件架构需要具备一定的扩展能力
- 例如：ASIP 已经实现了 convlution、pooling、Relu 等基本操作。resize 操作、FFT 操作可以作为 ASIC 加速器对 ASIP 进行扩展

### 架构定义

AI ASIP 处理器架构设计重点分为以下 8 点

- 数据重用
- weight 重用
- 计算并行度
- DDR 带宽
- MAC 利用率
- 硬件拓展性
- 初步流水时序
- 后端可实现性

#### 数据重用

- input channel(ci) 数据重用
  - 一个 ci 读入 buffer 之后，应用到所有 co 的计算中
- onput channel(co) 数据重用
  - 一个 co 的 partial sum 累计完毕之后，才存回 DDR
  - 当前层的 CO 作为下一层的 CI，在 local buffer 里面迭代

#### weight 重用

多 batch 并行

- 多个 NN 运算单元计算同一个模型
- input feature map 不一样
- weight 一样

#### 计算并行度

- 同时计算多个 co
- 同时计算一个 co 的不同的 partial sum
- Skip zero
  - ci/co skip zero
  - 0 kernel skip

#### DDR 带宽

有效的数据和 WEIGHT 重用能够降低 DDR 的带宽需求

- 数据压缩
  - 经过 Relu 之后，feature map 中存在很多 0 值，可以考虑对 feature map 进行压缩
- 模型压缩
  - 网络剪枝
  - 训练量化
  - 哈夫曼编码

#### MAC 利用率

单纯的堆叠 MAC 没有用，IO 是瓶颈

数据重用、WEIGHT 重用、降低 DDR 带宽、提高计算并行度都是为了提高 MAC 利用率

### 指令集定义

两类指令

- 循环、跳转、算术逻辑运算等基本指令用于控制和 NN Core 调度
- NN 指令用于 CNN 计算

指令集的规整以及扩展性

指令的颗粒度

- 大颗粒度
  - 例如定义了一条 convlution 指令，一条指令能够执行成千上万个 cycle
  - 特点：效率高
- 小颗粒度
  - 例如 convlution 操作通过使用乘法指令和加法指令编程完成
  - 特点：灵活

### 指令集模拟器开发 (ISS)

指令集模拟器（Instruction Set Simulator）是利用高级语言编写的 ASIP 处理器模型

可用于 ASIP 处理器架构设计阶段对处理器架构的性能仿真的工具。并且可用于后续 RTL 验证以及软件开发的参考模型

ISS 开发需要注意以下几点

- 重要参数可灵活配置调整
  - 例如：Memory 大小、Buffer 的大小、MAC 个数、DDR 带宽
- 丰富的 profiling 能力
  - 例如 MAC 的利用率、Buffer/Mac 是否饥饿
- 基本能够反映出硬件真实性能

指令集模拟器（ISS）有以下几类

- behavior model
  - 只模拟处理器的行为，没有时序概念
  - 主要用于 ASIP 处理器架构设计阶段，用于快速建模，并对处理器架构进行评估以及调整
  - 也可以作为 RTL 验证阶段的参考模型
- cycle accurate model
  - 有时序概念，每个 cycle 都可以与硬件完全比对上
  - 主要作为后续软件开发的参考模型，能够反映出软件在 ASIP 处理器上运行的真实情况

### ISS 仿真 & 架构优化迭代

选择 Benchmark

- 对于 AI 处理器来说，当前基本没有通用的 Benchmark (阿里也是刚发布用于 AI 处理器的 Benchmark：AI Matrix)
- 对于 AI ASIP 处理器来说，需要针对特定的应用和算法开发自己的 Benchmark。除此之外，也需要考虑一些通用的 CNN 模型的性能

利用 Benchmark 进行 ISS 架构仿真，并进行迭代

- 指令集是否完备，是否过设计、是否便于编程
- 确定 Memory/Buffer size
- 每种 Benchmark 下的 MAC 利用率
- 最常用的操作是否足够高效、是否还需要优化
- 频率、算力、带宽是否达到需求的指标

## AI ASIP 处理器实现难点

### AI ASIP 处理器 RTL 开发过程中的注意事项

时序

- 合理的流水线切割，保证每一级流水时序平衡
- 合理的 memory 切割，保证 memory 的读写时序
- 良好的 coding style

功耗

- memory：不读写的时候关闭时钟、有些 memroy 具有低功耗控制端口
- clock gating：工具自动插入、手动插入控制整个模块的 clock
- data gating：防止不使用的模块或者组合逻辑输入数据翻转

与后端密切迭代

- 面向 AI 的 ASIP 处理器，由于计算资源较多，走线复杂，通常会遇到 congestion 的问题
- Memory size 以及 Memory 的块数也会影响后端 floorplan、走线、DFT 等
- ASIP 处理器 RTL 开发初期甚至微架构设计时就要和后端建立良好的沟通机制，充分考虑后端实现

处理器的设计要考虑有效的 debug 机制

- 侵入式
  - 需要支持 breakpoint、step、continue 等，最基本的调试指令
  - 通过 JTAG 访问内部 memory 以及内部寄存器
- 非侵入式
  - 通过有效的 trace 机制，记录处理器正常运行期间发生的事件以及状态

处理器的设计中要设计合理的 profile 机制

- 收集处理器运行过程中各种应用场景以及算法下的性能、带宽等信息，以便对软硬件进行优化

### AI ASIP 处理器验证过程中的难点

指令集灵活，每个 bit 域都有很多种变化，加上处理器指令组合太多，验证难度非常大

- 通过随机指令发生器，策略性的产生随机指令，输入到参考模型以及 RTL 中，进行对比
  - 约束每个 bit 域的范围以及相互关系
  - 约束指令之间的前后关系 (有数据依赖的指令、NN 指令)

CNN 计算中，layer 的层数多，每层计算级联多，定位问题困难

- RTL 中加入适当的 debug 信息，例如：CNN Layer Counter，Input Channel Counter，Output Channel Counter
- 验证环境需要抓取各个硬件模块在 CNN 模型中每层的输出，与参考模型的结果进行对比

### AI ASIP 处理器物理实现的难点

难点

- memory size 如果过大，可能导致 memory timing 有问题
- memory 碎片化严重，导致 Floorplan、功耗、DFT 等各种问题
- CNN 计算的特点就是计算比较密集，导致功耗和 IR DROP 问题
- AI ASIP 处理器一般来说 MAC 数较多，这种情况下会导致连线异常复杂，导致 congestion 问题

解决方法

- memory size 过大，前端可以通过 memory 切割缓解部分 timing 问题
- 前端尽量避免有很多的小块 memory 设计
- 前端做好低功耗设计，控制 clock、memory、计算单元的功耗
- 后端优化 Power Mesh 策略
- Floorplan 按照数据流来摆放

## AI ASIP 处理器配套工具链

![AI ASIP 处理器配套工具链](./image/AI-ASIP%20处理器配套工具链.png)
