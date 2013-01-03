#Booth乘法器报告

##一、设计要求
完成16*16有符号乘法器的设计、验证工作。
具体设计方案要求如下：
* 编码方式：经典booth算法编码* 拓扑结构：Wallace树* 加法器：Square Root Carry Select 加法器##二、设计原理
###进位选择加法器
所谓进位选择加法器，就是提前计算出针对进位输入两种可能值的结果，然后根据实际的进位输入选择其一进行输出。如下图所示：
![principle1](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle1.png)
如果是一个16位的加法器，可以按照如下方法排列，称为线性进位选择加法器：
![principle2](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle2.png)
可以看到，如果每一级的位数都相同，那么第一级的进位输入最后的延时将非常大，而且诶都是浪费在等待后一级的计算结果上面。这完全可以通过更改设计来规避。
而本设计中的平方根进位选择加法器，就是在解决了上述问题之后的改进版本。如下图所示，每一级的位数不再相等，而是每一级恰恰比前一级多1，这样就免去了进位输入等待的情况，最后的结果也证实可以减少延时。
![principle3]( https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle3.png )

###Booth乘法器

Booth算法是一种十分有效的计算有符号数乘法的算法。算法的新型之处在于减法也可用于计算乘积。Booth发现加法和减法可以得到同样的结果。因为在当时移位比加法快得多，所以Booth发现了这个算法，Booth算法的关键在于把1分类为开始、中间、结束三种，如下图所示

![principle4](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle4.png)

当然一串0或者1的时候不操作，所以Booth算法可以归类为以下四种情况：

![principle5](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle5.png)

Booth算法根据乘数的相邻2位来决定操作，第一步根据相邻2位的4中情况来进行加或减操作，第二部仍然是将积寄存器右移，算法描述如下：

####1.根据当前位和其右边的位，做如下操作：

*    00:	0的中间，无任何操作；*   01:	1的结束，将被乘数加到积的左半部分；*   10:	1的开始，积的左半部分减去被乘数；*   11:	1的中间，无任何操作。
####2.将寄存器右移1位
因为Booth算法是有符号数的乘法，因此积寄存器移位的时候，为了保留符号位，进行算术右移。同时如果乘数或者被乘数为负数，则其输入为该数的补码，若积为负数，则输出结果同样为该数的补码。
本设计中要求采用的经典Booth算法，规则如下：
![principle6](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle6.png)
###Wallace树型乘法器
当部分积生成后，必须将它们相加以获得最终的结果。将部分积相加进行压缩的部分有两种：Counter/Compressor。Counter包括1位全加器与3:2计数器，Compressor则包含部分积压缩器，4:2压缩器等。
而乘法器中压缩部分积的结构就被称为拓扑结构。有规整拓扑结构，也有不规整拓扑结构。常用的简单阵列、双阵列、二进制树等结构就属于规整的拓扑结构，而我们要使用的Wallace树就属于非规整的拓扑结构。
不规整的拓扑结构可以有效减少延时，但由于不规则的连接方式，增加了版图设计的难度。
下图就是一个4位wallace树的拓扑结构设计过程，半加器用一个包含2个位的圈表示，全加器用一个包含3个位的圈表示：
![principle7](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle7.png)
以下就是设计好的结构图：
![principle8](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle8.png)
##三、设计思路
本设计的难点主要在两个方面，一是Booth编码的处理，二是Wallace树乘法器的构建。
下面将就这两个方面进行讨论。###Booth编码生成Booth编码部分，我的设计中主要是由Booth_Classic模块来处理的。这个模块的输入就是整个乘法器的16位乘数和被乘数，而输出则是生成的16个部分积（PP）以及由它们各自的符号位组成的数组，如下表：

端口 | 说明 
---------- | -------------
M [15:0]	|	输入端口，被乘数R [15:0]	|	输入端口，乘数pp0[15:0] - pp15[15:0]	|	输出端口，生成的16个16位长的部分积S [15:0]	|	输出端口，16个部分积各自的符号位
由于要求采用经典的Booth编码方式，因此采用逐位检查乘数的各位数字来确定部分积的方式。其中乘数末位需要补0，并重叠地每2位一组确定部分积，如下图：
![design1](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/design1.png)

采用的规则如下：

![design2](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/design2.png)

经典Booth编码在编码方面相比较Booth2等编码，方法更简单，硬件实现更容易，但是带来的问题也是十分明显的。首先，经典Booth编码并没有减少部分积的数目，这就给之后Wallace树的构建制造了麻烦，这点我们会在之后的章节中提到；此外，因为有可能需要生成“-X”部分积，因此16位的带符号操作数还需要特别对符号位进行处理。
针对这个问题，我们首先利用如下推理来将问题化简：
假设一个4位有符号数：SXXX，我们可将其扩展为8位有符号数：SSSS_SXXX。那么如下等式始终成立：
SSSS_SXXX = 1111_S\*XXX + 0000_1000	（S*表示S位取反）
这就是我的Booth_Classic模块还需要生成符号位输出S的原因。我们可以在16个部分积前再补上一位符号位。这样，在顶层模块的处理中，我们可以将生成的16个部分积的相加表示成这样：
![principle9](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/principle9.png)
事实上这些补上的1向量都可以在随后的相加中约去，我们只需要在Wallace树的结果出来之后，再加上符号位取反向量 {~sign, 16'b0} 以及 {15'b0, 1'b1, 16'b0}，就可以得到最终的运算结果。
以上就是我们对经典Booth码的处理方法。
###Wallace树部分
由于采用了经典Booth码，整个Wallace树部分的主要工作实际上就是对一个16*16的拓扑结构的化简。
在整个化简的过程中，我们仅采用3位全加器和2位半加器进行“圈划”。由于画圈和连线的工作量实在太大，为了保证准确性，我们采用相对保守的圈划方式，并在Verilog代码中对每一组加法器及其输出制定如下的命名规则：
* 将整个过程分成了6个步骤（stage），分别命名为Fir，Sec，Thi，Fou，Fif，Six；* 每个stage又会有若干层，相应的，各层就被叫做Fir1，Fir2，Sec3，Fou2等；* 每一层的加法器就被称为fir1ha0，fir2fa3等，ha/fa分别代表半加器/全加器；
* 每一层所有加法器的输出就被连接到2组线之中，比如Fir1_S[15:0]，Fir1_C[15:0]，Sec2_S[17:0]，Sec2_C[17:0]，以此类推。每组线的宽度有各层的加法器数量决定。如此，以下就是我们的Wallace树的圈划过程：
![wallace1](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wallace1.png)![wallace2](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wallace2.png)

![wallace3](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wallace3.png)

![wallace4](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wallace4.png)

![wallace5](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wallace5.png)

![wallace6](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wallace6.png)

![wallace7](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wallace7.png)

Wallace树模块最后的输出结果就是两个32位的操作数opa/opb。将这两个操作数送入平方根进位选择加法器CS_Adder32后，就可以得到这16个部分积相加的结果。

###平方根进位选择加法器
除了上述两个模块外，整个乘法器还有一个不能被忽视的模块，那就是平方根进位选择加法器。
CS_Adder32模块的输入为两个32位的操作数a、b以及前级进位输入cin，输出则是32位的结果sum和进位输出cout。
进位选择加法器的原理上文中已经提及。在这个具体设计实例中，我们将32位的加法器分成6个阶段。各个阶段的加法位数分别为：3、4、5、6、7、7。如此划分符合平方根进位的要求，可以使得进位的延时最小，也就减小了关键路径延时。
###其他模块
整个系统还有全加器Fulladder，半加器Halfadder等模块，因为结构简单，原理清晰，在这里就不一一详细说明了。
###系统设计框图
![systemdesign](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/systemdesign.png)
##四、功能仿真
###仿真策略
由于乘法器涉及的是16位乘16位的乘法，如果采用遍历的形式进行功能仿真，花费的时间太长，因此，这次的模块功能仿真我们采用随机法。
首先编写一个简单的小模块multipiler_check.v，直接用乘法符号来计算结果，用来产生正确的计算结果，以便后续检查模块计算是否正确。代码如下：
	module multiplier_check(a, b, p);

	input signed[15:0] a, b;
	output signed[31:0] p;
	assign p = a*b;

	endmodule
之后testbench的编写中，我们将生成200对符合范围内的16位随机有符号数，分别输入到乘法器和之前的check模块中，比对结果是否相符。如果有错误的结果，计数器就将加1。并保留当前计算结果以及之前的2个计算结果，方便出错时观察。

###testbench代码

以下是乘法器总的testbench的代码：

	`timescale 1ns/1ps
	
	module multiplier_tb;
	
	parameter	TCLK = 10;
	reg		clk;
	
	reg		[15: 0]	x, y;
	wire	[31: 0] res;
	wire   	[31: 0] res_check;
	
	initial	clk = 1'b0;
	always #(TCLK/2)	clk = ~clk;
	
	reg[31: 0] res_check1, res_check2, res_check3;
	reg[5 : 0] counter;
	initial counter = 0;
	always @(posedge clk)
	begin
   		res_check1 <= res_check;
    	res_check2 <= res_check1;
    	res_check3 <= res_check2;
    	if (res != res_check)
       		counter <= counter+1;
	end
	
	initial
	begin
    	repeat(200)
    	begin
       		x = {$random}%17'h10000;
       		y = {$random}%17'h10000;
       		#TCLK ;
    	end
    	$stop;
	end
	
	TopMultiplier	multiplier_test	(
										.x_in (x),
										.y_in (y),
										.result_out (res)
									);
	
	multiplier_check	multiplier_check0 (
											.a(x),
											.b(y),
											.p(res_check)
										);
	
	endmodule###功能验证截图
采用modelsim软件进行功能验证。
由于波形较长，截取头尾两端截图：

![sim1](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wave1.jpg)

![sim2](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/wave2.jpg)

可以看到计数器counter始终为零。说明两个模块在200个随机数的验证情况下，也没有出现不一致的情况。因此我们认为，这个乘法器模块的功能实现是正确的。

##五、逻辑综合

可以看到计数器counter始终为零。说明两个模块在200个随机数的验证情况下，也没有出现不一致的情况。因此我们认为，这个乘法器模块的功能实现是正确的。

###相关脚本文件
一共有2个相关的脚本文件：TopMultiplier_CONST.con和TopMultiplier.tcl。其中, TopMultiplier_CONST.con文件中定义了一些关键性的设计约束，而TopMultiplier.tcl文件则是顶层的逻辑综合流程,在综合时只需要执行top.tcl文件,就会调用其他的脚本文件。
###设计约束
####·时钟及输入输出延时
由于这个ALU是纯组合逻辑,在DC综合时需要加上一个虚拟时钟。时钟部分的设计约束如下:

![clock](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/clock.png)

####·驱动和负载

![drive&load](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/constraint_load.png)

###逻辑综合结果
####·性能
根据timing report，该电路的时钟频率约为305MHz。关键路径如下：

![critica_path](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/critical_path.png)

####·功耗
根据DC report中的power部分可知,整个电路的动态功耗为32.1228mW,静态功耗为3.6027uw。由下图可以看出各部分所占功耗的百分比,因为全部由组合逻辑组成,组合逻辑部分占到了100%。

![power](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/power.png)

####·面积
根据DC report中的power部分可知,整个电路的动态功耗为32.1228mW,静态功耗为3.6027uw。由下图可以看出各部分所占功耗的百分比,因为全部由组合逻辑组成,组合逻辑部分占到了100%。

![area](https://github.com/wuzeyou/Multiplier16X16/blob/master/readme_pic/area.png)

可以看到整个电路的面积还是非常大的。一方面是因为Wallace树中我仅仅采用了半加器和全加器，而没有使用4-2压缩器等模块；另一方面也由于我使用了三次CSAdder模块，在后续的设计中应该改进策略，把符号位的处理放到Wallace树模块中，应该可以进一步减小电路面积。
Joe Wu

12/12/29