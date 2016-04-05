library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Train_Logic is
    Port (H1, H2 : in Std_Logic;
         Em, CLK : in Std_Logic;
      Rev1, Rev2 : in Std_Logic;
           speed : in unsigned (1 downto 0);
             QT1 : buffer unsigned (2 downto 0);
             QT2 : buffer unsigned (2 downto 0));
end Train_Logic;

architecture Behavioral of Train_Logic is

signal count : unsigned (27 downto 0) := (others => '0');

begin
Anti_Collision: process
begin
  if (rising_edge(clk)) then
      count <= count +1 + (speed * 3);  --slows down the clock, adjusted for speed toggle
  end if;
if (rising_edge(count(26))) then

    if (Em = '1') then
        QT1 <= "000";  --initalize values, Em acts as CLR
        QT2 <= "000";
    else
        if (Rev1 = '0' and Rev2 = '0') then --normal state, both trains advancing
            if (H1 = '0' and H2 = '0') then
                if (QT1 = QT2) then
                    QT1 <= QT1 +1;
                    QT2 <= QT2;
                 elsif (QT1+1 = QT2+1 and (QT1+1) /= "000") then
                    QT1 <= QT1 +1;
                    QT2 <= QT2;
                 else
                    QT1 <= QT1 +1;
                    QT2 <= QT2 +1;
                 end if;
            elsif (H1 = '1' and H2 = '0') then --train 1 hold, train two advances normally unless next state t2 = current state train1
                if ((QT1 = QT2+1) and QT1 /= "000" ) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                else 
                    QT1 <= QT1;
                    QT2 <= QT2 +1;
                end if;
            elsif (H1 = '0' and H2 = '1') then  --train 2 hold, train1 advances normally unless next state t1 = current state train2
                if ((QT1+1 = QT2) and QT2 /= "000" ) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                else 
                    QT1 <= QT1 +1;
                    QT2 <= QT2;
                 end if;
            elsif (H1 = '1' and H2 = '1') then  --both hold, both trains copy current state to next state
                    QT1 <= QT1;
                    QT2 <= QT2;
            else  --Error Condition
                    QT1 <= QT1;
                    QT2 <= QT2;
            end if;
        elsif (Rev1 = '1' and Rev2 = '0') then  --train 1 backwards, train 2 forwards
            if (H1 = '0' and H2 = '0') then  
                if ((QT1-1 = QT2) and ((QT1-1) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;                
                elsif (QT1 = QT2+1 and ((QT2+1) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                elsif ((QT1-1 = QT2+1) and ((QT1-1 /= "000"))) then
                    QT1 <= QT1 -1;
                    QT2 <= QT2;
                else 
                    QT1 <= QT1 -1;
                    QT2 <= QT2 +1;
                end if;
            elsif (H1 = '1' and H2 = '0') then
                if (QT1 = QT2+1 and ((QT1) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                else
                    QT1 <= QT1;
                    QT2 <= QT2 +1;
                end if;
            elsif (H1 = '0' and H2 = '1') then
                if (QT1-1 = QT2 and ((QT2) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                else
                    QT1 <= QT1 -1;
                    QT2 <= QT2;
                end if;
            elsif (H1 = '1' and H2 = '1') then
                    QT1 <= QT1;
                    QT2 <= QT2;
            end if;        
       
        elsif (Rev1 = '0' and Rev2 = '1') then --train 1 forwards, train 2 backwards
            if (H1 = '0' and H2 = '0') then  
                if ((QT1+1 = QT2) and ((QT1+1) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                elsif (QT1 = QT2-1 and ((QT2-1) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                elsif ((QT1+1 = QT2-1) and ((QT1+1 /= "000"))) then
                    QT1 <= QT1 +1;
                    QT2 <= QT2;
                else 
                    QT1 <= QT1 +1;
                    QT2 <= QT2 -1;
                end if;
            elsif (H1 = '1' and H2 = '0') then
                if (QT1 = QT2-1 and ((QT1) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                else
                    QT1 <= QT1;
                    QT2 <= QT2 -1;
                end if;
            elsif (H1 = '0' and H2 = '1') then
                if (QT1+1 = QT2 and ((QT2) /= "000")) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                 else
                    QT1 <= QT1 +1;
                    QT2 <= QT2;
                 end if;
            elsif (H1 = '1' and H2 = '1') then
                    QT1 <= QT1;
                    QT2 <= QT2;
            end if;              
        elsif (Rev1 = '1' and Rev2 = '1') then -- both trains backwards
            if (H1 = '0' and H2 = '0') then
                 if (QT1 = QT2) then
                    QT1 <= QT1 -1;
                    QT2 <= QT2;
                 elsif (QT1-1 = QT2-1 and (QT1-1) /= "000") then
                    QT1 <= QT1 -1;
                    QT2 <= QT2;
                 else
                    QT1 <= QT1 -1;
                    QT2 <= QT2 -1;
                 end if;
            elsif (H1 = '1' and H2 = '0') then --train 1 hold, train two advances normally unless next state t2 = current state train1
                if ((QT1 = QT2-1) and QT1 /= "000" ) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                else 
                    QT1 <= QT1;
                    QT2 <= QT2 -1;
                end if;
            elsif (H1 = '0' and H2 = '1') then  --train 2 hold, train one advances normally unless next state t1 = current state train2
                if ((QT1-1 = QT2) and QT2 /= "000" ) then
                    QT1 <= QT1;
                    QT2 <= QT2;
                 else 
                    QT1 <= QT1 -1;
                    QT2 <= QT2;
                 end if;
            elsif (H1 = '1' and H2 = '1') then  --both hold, both trains copy current state to next state
                    QT1 <= QT1;
                    QT2 <= QT2;
            else  --Error Condition
                    QT1 <= QT1;
                    QT2 <= QT2;
            end if;
        else  -- last case error condition
                    QT1 <= QT1;
                    QT2 <= QT2;
        end if;
    end if;
end if;
end process;
end Behavioral;
