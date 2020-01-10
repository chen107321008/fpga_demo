module demo(output reg [7:0] DATA_R, DATA_G, DATA_B,
output reg [3:0] A_count,
input  left,right,fire,mod,
output reg [1:0]left_shift,right_shift,up,fallBall,
output reg a,b,c,d,e,f,g,
input CLK);

 reg  [0:5][7:0] R_Char [7:0]=
'{'{8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000110,8'b10000111},      //0~6關地圖
  '{8'b10000000,8'b10000000,8'b10000000,8'b10000110,8'b10000111,8'b10000101},
  '{8'b10000000,8'b10000100,8'b10000111,8'b10000111,8'b10000111,8'b10000101},
  '{8'b10000000,8'b10000011,8'b10000111,8'b10000111,8'b10000111,8'b10000111},
  '{8'b10000000,8'b10000011,8'b10000111,8'b10000111,8'b10000111,8'b10000111},
  '{8'b10000000,8'b10000100,8'b10000111,8'b10000111,8'b10000111,8'b10000101},
  '{8'b10000000,8'b10000000,8'b10000000,8'b10000110,8'b10000111,8'b10000101},
  '{8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000110,8'b10000111}};


 reg [0:5][7:0] G_Char [7:0]=
'{'{8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000},
  '{8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000},
  '{8'b10001001,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000},
  '{8'b10001001,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000},
  '{8'b10001001,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000},
  '{8'b11111111,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000},
  '{8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000},
  '{8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000,8'b10000000}};
 reg [0:5][7:0] B_Char [7:0]=
'{'{8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000},
  '{8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000},
  '{8'b00001001,8'b00000100,8'b00000000,8'b00000000,8'b00000000,8'b00000000},
  '{8'b00001001,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000},
  '{8'b00001001,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000},
  '{8'b01111111,8'b00000100,8'b00000000,8'b00000000,8'b00000000,8'b00000000},
  '{8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000},
  '{8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000}};
  
 bit [5:0] level;                   //第幾關

 bit [2:0] cnt;
 bit E,pass,start;                  //當為fail,E為1   如果過關 pass=1,之後pass歸零                                 
integer i,j;
 bit [1:0] mode;
 bit [2:0] point;
 bit [1:0] fall_ball;
 bit [1:0][3:0] ball_x;
 bit [1:0][3:0] last_ball_x;
 bit [1:0][3:0] ball_y;
 bit [1:0][3:0] last_ball_y;
 bit [3:0] prepoint;
 
 divfreq F1(CLK,CLK_div);
 divfreq2 F2(CLK,CLK_div2);

 
 initial
  begin
   mode=0;
	start =0;
	E=0;
   level=1;
   
	for (i=0;i<=1;i=i+1)begin
	up[i]=1;
	left_shift[i]=0;
	right_shift[i]=0;
	last_ball_x[i]=8+i;
	last_ball_y[i]=8+i;
	ball_x[i]=8+i;
	ball_y[i]=8+i;
	fallBall[i]=0;
	end
   cnt = 0;
	point = 3;
	prepoint = 4;
   DATA_R = 8'b11111111;
   DATA_G = 8'b11111111;
   DATA_B = 8'b11111111;
   A_count = 4'b1000;
	
	

	
  end
  
  
  always @(posedge CLK_div2)
  begin
  for(i=0;i<2;i=i+1)begin	
  if(ball_y[i]>7)
	up[i]=1;
  end
  
  if(mod&&start==0)
		mode=mode+1;
	if(mode==1)
		left_shift[0]=1;
	if(mode==2)
		left_shift[0]=0;
	if(mode==2)
		right_shift[0]=1;
	if(mode==3)
		right_shift[0]=0;
	if(mode==3)
		mode=0;
	if(mode==0)
		left_shift[0]=0;
	if(mode==0)
		right_shift[0]=0;
		
  
  if(left&&point>=1)
			point=point-1;
			
	if(right&&point<=6)
			point=point+1;
			
	prepoint=point+1;
	
	R_Char[point][level][7]=0;
	
	if(prepoint!=point)
	R_Char[prepoint][level][7]=1;

	if(right)
		R_Char[prepoint-2][level][7]=1;
		
		
	for(i=0;i<2;i=i+1)begin	
		if((R_Char[ball_x[i]][level][ball_y[i]]!=0&&ball_y[i]<7)||(ball_y[i]==0))begin
			if(up[i]==1)
				up[i]=0;
			else
				up[i]=1;
		end
	
		if(ball_y[i]<=0&&up[i])begin
			ball_y[i]=8+i;
			ball_x[i]=8+i;
		end
		
		if(ball_y[i]==7&&up[i]==0)begin
			ball_y[i]=8+i;
			ball_x[i]=8+i;
		end
	
		if(fire&&left==0&&right==0&&ball_y[i]==8+i&&start==0)begin
			if(i==1)
				start=1;
			ball_x[i]=point;
			ball_y[i]=ball_y[i]-1;
			for(j=0;j<2;j=j+1)begin	
				left_shift[j]=left_shift[0];
				right_shift[j]=right_shift[0];
			end
		end
	
		if(left_shift[i]&&ball_x[i]>=1&&ball_x[i]!=8+i&&ball_y[i]<=7)begin
			ball_x[i]=ball_x[i]-1;
		end
		
		if(right_shift[i]&&ball_x[i]<=6&&ball_x[i]!=8+i&&ball_y[i]<=7)begin
			ball_x[i]=ball_x[i]+1;
		end
	end
	
	for(i=0;i<2;i=i+1)begin		
		if(ball_x[i]==0&&left_shift[i])begin
			if(i==0)
				mode=2;
			left_shift[i]=0;
			right_shift[i]=1;
		end
	
		if(ball_x[i]==7&&right_shift[i])begin
			if(i==0)
				mode=1;
			right_shift[i]=0;
			left_shift[i]=1;
		end
		
		if(ball_y[i]<7&&ball_y[i]!=8+i&&up[i]==0)
			ball_y[i]=ball_y[i]+1;
	
		if(ball_y[i]>0&&ball_y[i]!=8+i&&up[i])
			ball_y[i]=ball_y[i]-1;
	end
	
	
	
	
	for(i=0,fall_ball=0;i<2;i=i+1)begin	
		if(last_ball_y[i]<7&&ball_y[i]!=i+8&&start==1&&B_Char[last_ball_x[i]][level][last_ball_y[i]])begin
			R_Char[last_ball_x[i]][level][last_ball_y[i]]=0;
			B_Char[last_ball_x[i]][level][last_ball_y[i]]=0;
			G_Char[last_ball_x[i]][level][last_ball_y[i]]=0;
		end
	
		if(ball_y[i]==8+i)
			fall_ball=fall_ball+1;
	end
		if(fall_ball==0)begin
			fallBall=2'b00;
		end
		if(fall_ball==1)begin
			fallBall=2'b01;
		end
		if(fall_ball==2)begin
			fallBall=2'b11;
		end
			
	
	
		if(fall_ball==2&&start==1)begin
			start=0;
			for(j=0;j<8;j=j+1)begin
				for(i=1;i<7;i=i+1)begin
					R_Char[j][level][i]<=R_Char[j][level][i-1];
					G_Char[j][level][i]<=G_Char[j][level][i-1];
					B_Char[j][level][i]<=B_Char[j][level][i-1];
				end
			end
		
			for(i=0;i<8;i=i+1)begin
				R_Char[i][level][0]=0;
				G_Char[i][level][0]=0;
				B_Char[i][level][0]=0;
			end
		end
		
		
	for(i=0;i<2;i=i+1)begin
	
		if(ball_y[i]<7)begin
			if(B_Char[ball_x[i]][level][ball_y[i]]==1)begin
				B_Char[ball_x[i]][level][ball_y[i]]=0;
			end
			else
				begin
					B_Char[ball_x[i]][level][ball_y[i]]=1;
					G_Char[ball_x[i]][level][ball_y[i]]=1;
					last_ball_x[i]=ball_x[i];
					last_ball_y[i]=ball_y[i];
				end
		end
	end
	

	for(j=0,pass=1;j<8;j=j+1)begin
			for(i=1;i<7;i=i+1)begin
			if(R_Char[j][level][i])begin
			pass=0;
			end
			end
		end
	if(pass)begin
	pass=0;
	start=0;
	level=level+1;
		for(i=0;i<2;i=i+1)begin
		ball_y[i]=8+i;
		ball_x[i]=8+i;
		up[i]=1;
		end
	end
	
	
	if(E)begin
		for(i=0;i<2;i=i+1)begin
		ball_y[i]=8+i;
		ball_x[i]=8+i;
		up[i]=1;
		end
		level=0;
	end
	
	
	
	
	
  end
  
 

   
 always @(posedge CLK_div)
  begin
   if(cnt >= 7)
   cnt=0;
   else
    cnt=cnt+1;
   A_count = {1'b1, cnt};
	
	
	if(R_Char[cnt][level][6])
			E=1;
	
	if(level==0)
		{a,b,c,d,e,f,g}= 7'b0111000;
	if(level==1)
		{a,b,c,d,e,f,g}= 7'b1001111;
	if(level==2)
		{a,b,c,d,e,f,g}= 7'b0010010;
	if(level==3)
		{a,b,c,d,e,f,g}= 7'b0000110;
	if(level==4)
		{a,b,c,d,e,f,g}= 7'b1001100;
	if(level==5)
		{a,b,c,d,e,f,g}= 7'b0100100;
	
	
   DATA_R=R_Char[cnt][level];
   DATA_G=G_Char[cnt][level];
   DATA_B=B_Char[cnt][level];
  end
endmodule


 
  

module divfreq(input CLK, output reg CLK_div);
reg [24:0] Count;
always @(posedge CLK)
begin
if(Count > 25000)
begin
Count <= 25'b0;
CLK_div <= ~CLK_div;
end
else
Count <= Count + 1'b1;
end
endmodule

module divfreq2(input CLK, output reg CLK_div2);
reg [24:0] Count;
always @(posedge CLK)
begin
if(Count > 5500000)
begin
Count <= 25'b0;
CLK_div2 <= ~CLK_div2;
end
else
Count <= Count + 1'b1;
end
endmodule




