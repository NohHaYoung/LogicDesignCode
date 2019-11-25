---


---

<h1 id="lab-10">Lab 10</h1>
<h2 id="실습-내용">실습 내용</h2>
<h3 id="적외선-컨트롤러ir-controller"><strong>적외선 컨트롤러(IR Controller)</strong></h3>
<h4 id="submodule-1---ir_rx-"><strong>Submodule 1 - ir_rx</strong> :</h4>
<h4 id="submodule-2---fnd_dec--015에-해당하는-segment-출력값-정의"><strong>Submodule 2 - fnd_dec</strong> : 0~15에 해당하는 segment 출력값 정의</h4>
<h4 id="submodule-3---led_disp--7-segment-display"><strong>Submodule 3 - led_disp</strong> : 7-segment display</h4>
<h4 id="top-module---ir-controller로-부터-data를-받아-7-segment에-해당하는-data를-출력"><strong>Top Module</strong> :  IR Controller로 부터 DATA를 받아 7-segment에 해당하는 DATA를 출력</h4>
<h2 id="결과">결과</h2>
<h3 id="top-module-의-duttestbench-code-및-waveform-검증"><strong>Top Module 의 DUT/TestBench Code 및 Waveform 검증</strong></h3>
<p><img src="https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/waveform.PNG?raw=true" alt="wave form"></p>
<h3 id="fpga-동작-사진"><strong>FPGA 동작 사진</strong></h3>
<p><code>POWER Button data : FD00FF</code><br>
<img src="https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%281%29.jpg?raw=true" alt="PowerButton Data : FD00FF"></p>
<p><code>#3 data : FD48B7</code><br>
<img src="https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%282%29.jpg?raw=true" alt="#3 data : FD48B7"></p>

