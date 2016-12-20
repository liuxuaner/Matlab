#matlab


# 1612_lowpassFilter

- 题目: 低通滤波示例
- 参数: 
	- 带通频率 f-pass(kHz)
	- 带阻频率 f-stop(kHz)
	- passband ripple in decibels Rp
	- 衰减值Rs
- 功能：低通去噪
- 调用：
	-  tools   -- 信号处理辅助函数
- 作者: 马骋
- 2016.04.21 @HIT


# 1612_wavelet

- 题目: 导波测试信号的小波时频谱分析
- 参数: 
	- 降低采样倍数 q
	- 小波类型
	- 尺度序列的长度totalscal
	- 频率显示范围 kHz
- 功能：
	- csv数据导入
	- cheby1低通滤波
	- 信号降低采样
	- 小波分析、分辨率设置
	- 时频图绘制
- 调用：
	-  tools   -- 信号处理辅助函数
- 作者：马骋，丁昊青
- 2016.12.12 @HIT

# 1612_guwCurve


- 题目：GUIGUW导波曲线模态匹配分组
- 参数：无
- 功能：根据导波波数分组，区分能量速度曲线
	- 对wn数据曲线分组
	- 生成定位矩阵
	- 对相应的导波Ev数据重排列
- 调用：
	- tools       -- 信号绘图工具箱，绘图优化
	- fun_sort    -- 根据定位矩阵I重新排列A
	- fun_plot0   -- 绘图中去掉Y中为0的点
- 作者：马骋
- 2016.12.19 @HIT

# 1612_figureSubplot

- 题目：多个fiure文件以子图的形式重绘到一个figure中
- 参数：无
- 功能：
	- 读取多个子图的figure文件
	- 按subplot方式，重绘到一个figure图像中
	- 对相应的导波Ev数据重排列
- 调用：无
- 作者：马骋
- 2016.12.20 @HIT

