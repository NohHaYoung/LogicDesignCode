---


---

<h1 id="lab-10">Lab 10</h1>
<h2 id="실습-내용">실습 내용</h2>
<h3 id="적외선-컨트롤러ir-controller-동작-원리"><strong>적외선 컨트롤러(IR Controller) 동작 원리</strong></h3>
<h4 id="송신부적외선-발광-다이오드-수신부포토다이오드로-구성.-송신부적외선-발광다이오드에서-적외선을-발생시키고-수신부에서-적외선을-받아-전기에너지로-바꾸어-전류를-생성함.">송신부(적외선 발광 다이오드), 수신부(포토다이오드)로 구성. 송신부(적외선 발광다이오드)에서 적외선을 발생시키고, 수신부에서 적외선을 받아 전기에너지로 바꾸어 전류를 생성함.</h4>
<h4 id="nec-적외선-통신규약--leadercode프레임의-모드-선택-costomcode특정-회사-코드-datacode송신데이터">NEC 적외선 통신규약 : LeaderCode(프레임의 모드 선택), CostomCode(특정 회사 코드), DataCode(송신데이터)</h4>
<h2 id="각-모듈-설명">각 모듈 설명</h2>
<h3 id="submodule-1---ir_rx"><strong>Submodule 1 - ir_rx</strong></h3>
<p>IDLE - Reference State : state를 leadcode로 바꾸고, 카운터를 0으로 리셋<br>
LEADCODE  : datacode가 들어오기 전 단계. cnt_high가 9ms이상, cnt_low가 4.5ms 이상이 되면, state를 datacode로 바꿈.<br>
DATACODE - 32bit DATA : 데이터가 0에서 1로 바뀔 때 1부터 32까지 세는 카운터(cnt32)에 1을 더하고 카운터가 32가 되면, state를 complete로 바꿈.<br>
COMPLETE :  받은 데이터를 출력. state를 다시 leadcode로 반환.</p>
<h3 id="submodule-2---fnd_dec--015에-해당하는-segment-출력값-정의"><strong>Submodule 2 - fnd_dec</strong> : 0~15에 해당하는 segment 출력값 정의</h3>
<h3 id="submodule-3---led_disp--7-segment-display"><strong>Submodule 3 - led_disp</strong> : 7-segment display</h3>
<h3 id="top-module---ir-controller로-부터-data를-받아-7-segment에-해당하는-data를-출력"><strong>Top Module</strong> :  IR Controller로 부터 DATA를 받아 7-segment에 해당하는 DATA를 출력</h3>
<h2 id="결과">결과</h2>
<h3 id="top-module-의-duttestbench-code-및-waveform-검증"><strong>Top Module 의 DUT/TestBench Code 및 Waveform 검증</strong></h3>
<p><img src="https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/waveform.PNG?raw=true" alt="wave form"></p>
<h3 id="fpga-동작-사진"><strong>FPGA 동작 사진</strong></h3>
<p><code>POWER Button data : FD00FF</code><br>
<img src="https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%281%29.jpg?raw=true" alt="PowerButton Data : FD00FF"></p>
<p><code>#3 data : FD48B7</code><br>
<img src="https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%282%29.jpg?raw=true" alt="#3 data : FD48B7"></p>

