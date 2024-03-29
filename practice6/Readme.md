# Lab 10

## 실습 내용

### **적외선 컨트롤러(IR Controller) 동작 원리** 
#### 송신부(적외선 발광 다이오드), 수신부(포토다이오드)로 구성. 송신부(적외선 발광다이오드)에서 적외선을 발생시키고, 수신부에서 적외선을 받아 전기에너지로 바꾸어 전류를 생성함.

#### NEC 적외선 통신규약 : LeaderCode(프레임의 모드 선택), CostomCode(특정 회사 코드), DataCode(송신데이터)

## 각 모듈 설명
### **Submodule 1 - ir_rx**
ST
IDLE - Reference State : state를 leadcode로 바꾸고, 카운터를 0으로 리셋
LEADCODE  : datacode가 들어오기 전 단계. cnt_high가 9ms이상, cnt_low가 4.5ms 이상이 되면, state를 datacode로 바꿈.
 DATACODE - 32bit DATA : 데이터가 0에서 1로 바뀔 때 1부터 32까지 세는 카운터(cnt32)에 1을 더하고 카운터가 32가 되면, state를 complete로 바꿈.
COMPLETE :  받은 데이터를 출력. state를 다시 leadcode로 반환.

### **Submodule 2 - fnd_dec** : 0~15에 해당하는 segment 출력값 정의

### **Submodule 3 - led_disp** : 7-segment display

### **Top Module** :  IR Controller로 부터 DATA를 받아 7-segment에 해당하는 DATA를 출력

## 결과

### **Top Module 의 DUT/TestBench Code 및 Waveform 검증**
![wave form](https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/waveform.PNG?raw=true)


### **FPGA 동작 사진**
`POWER Button data : FD00FF`
![PowerButton Data : FD00FF](https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%281%29.jpg?raw=true)

`#3 data : FD48B7`
![#3 data : FD48B7](https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%282%29.jpg?raw=true)

<!--stackedit_data:
eyJoaXN0b3J5IjpbMzkxOTI5Njc5LDg5MTE3NzUxNiw0MzU1Nz
czNTYsMTM1MTY2Njc1Ml19
-->