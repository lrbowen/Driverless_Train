library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX_3x8 is
    port (I : in unsigned (2 downto 0); 
          O : out std_logic_vector (7 downto 0));
end MUX_3x8;

architecture arch_MU of MUX_3x8 is
begin
    process (I)
        begin
            case I is 
                when "000" => O <= "00000001";
                when "001" => O <= "00000010";
                when "010" => O <= "00000100";
                when "011" => O <= "00001000";
                when "100" => O <= "00010000";
                when "101" => O <= "00100000";
                when "110" => O <= "01000000";
                when "111" => O <= "10000000";
               when others => O <= "00000000";
             end case;
    end process;
end arch_MU;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity seven_display_station is
   port (    clk : in std_logic;
          digit1 : in std_logic_vector (7 downto 0);
          digit2 : in std_logic_vector (7 downto 0);
              an : out std_logic_vector (3 downto 0);          
        segments : out STD_LOGIC_VECTOR (6 downto 0)); 
end seven_display_station;

architecture arch_seven_dis of seven_display_station is

    signal r_anodes : STD_LOGIC_VECTOR (3 downto 0 ):= (others => '0');      
    signal count : unsigned (3 downto 0) := (others => '0');
    signal slower : unsigned (10 downto 0) := (others => '0');
    
begin
    decode: process(digit1, digit2, clk)
    begin
        if (rising_edge(clk)) then
           slower <= slower+1;
        end if;
        if (rising_edge(slower(10)))then 
            count <= count + 1;
        end if;          
           case count is
                       when "00" => r_anodes <= "1110"; -- AN 0
                       when "01" => r_anodes <= "1101"; -- AN 1
                       when "10" => r_anodes <= "1011"; -- AN 2
                       when "11" => r_anodes <= "0111"; -- AN 3
                       when others => r_anodes <= "1111"; -- nothing
           end case;
           an <= r_anodes;
           case r_anodes(3 downto 0) is
               when "1110" => 
                    case digit1 is 
                         when "00000001" => segments <= "1111001";  --station 1
                         when "00000010" => segments <= "0100100";
                         when "00000100" => segments <= "0110000";  --station 2
                         when "00001000" => segments <= "0011001";
                         when "00010000" => segments <= "0010010";  --station 3
                         when "00100000" => segments <= "0000010";
                         when "01000000" => segments <= "1111000";  --station 4
                         when "10000000" => segments <= "0000000";
                         when others => segments <= "0111111";
                     end case;
                 when "1101" => 
                     case digit2 is 
                         when "00000001" => segments <= "1111001";  --station 1
                         when "00000010" => segments <= "0100100";
                         when "00000100" => segments <= "0110000";  --station 2
                         when "00001000" => segments <= "0011001";
                         when "00010000" => segments <= "0010010";  --station 3
                         when "00100000" => segments <= "0000010";
                         when "01000000" => segments <= "1111000";  --station 4
                         when "10000000" => segments <= "0000000";
                         when others => segments <= "0111111";
                      end case; 
                 when "1011" =>
                      if(digit1 = "00000001" or digit2 = "00000001") then
                            if (digit1 = "00000010" or digit2 = "00000010") then
                                 segments <= "1111001";
                            elsif (digit1 = "00000100" or digit2 = "00000100") then
                                 segments <= "1111010";
                            elsif (digit1 = "10000000" or digit2 = "10000000") then
                                 segments <= "1110011";
                            else 
                                 segments <= "1111011";
                            end if;        
   
                       elsif (digit1 = "00000010" or digit2 = "00000010") then
                            if (digit1 = "00000100" or digit2 = "00000100") then
                                 segments <= "1111100";
                            elsif (digit1 = "10000000" or digit2 = "10000000") then
                                 segments <= "1110101";
                            else
                                 segments <= "1111101";
                            end if;       
                              
                       elsif (digit1 = "00000100" or digit2 = "00000100") then
                            if(digit1 = "10000000" or digit2 = "10000000") then
                                 segments <= "1110110";
                            else
                                 segments <= "1111110";
                            end if;
                       elsif (digit1 = "10000000" or digit2 = "10000000") then
                                 segments <= "1110111";
                                
                       else segments <= "1111111";
                       end if;
               when "0111" =>
                       if(digit1 = "00001000" or digit2 = "00001000") then
                            if (digit1 = "00010000" or digit2 = "00010000") then
                                 segments <= "1011110";
                            elsif (digit1 = "00100000" or digit2 = "00100000") then
                                 segments <= "1101110";
                            elsif (digit1 = "01000000" or digit2 = "01000000") then
                                 segments <= "1110110";                         
                            else
                                 segments <= "1111110";
                            end if;    
                        elsif (digit1 = "00010000" or digit2 = "00010000") then
                            if (digit1 = "00100000" or digit2 = "00100000") then
                                 segments <= "1001111";
                            elsif (digit1 = "01000000" or digit2 = "01000000") then
                                 segments <= "1010111";
                            else
                                 segments <= "1011111";
                            end if;   
                        elsif (digit1 = "00100000" or digit2 = "00100000") then
                            if (digit1 = "01000000" or digit2 = "01000000") then
                                    segments <= "1100111";
                            else
                                    segments <= "1101111";
                            end if;
                         elsif (digit1 = "01000000" or digit2 = "01000000") then
                                segments <= "1110111";
                         else segments <= "1111111";
                            end if;          
                when others =>  segments <= "1111111"; -- nothing
         end case;
   end process;
end arch_seven_dis;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
 
entity TrainStruct is
    Port (H1, H2 : in Std_Logic;
         Em, CLK : in Std_Logic;
      Rev1, Rev2 : in Std_Logic;
           Speed : in unsigned (1 downto 0);
             TF1 : buffer std_logic_vector (7 downto 0);
             TF2 : buffer std_logic_vector (7 downto 0);
          anodes : out STD_LOGIC_VECTOR (3 downto 0);
        segments : out STD_LOGIC_VECTOR (6 downto 0));            
end TrainStruct;

architecture Train_Struct of TrainStruct is

component MUX_3x8 is
    port (I : in unsigned (2 downto 0); 
          O : out std_logic_vector (7 downto 0));
end component;

component seven_display_station is
   port ( clk : in std_logic;
       digit1 : in std_logic_vector (7 downto 0);
       digit2 : in std_logic_vector (7 downto 0);
           an : out std_logic_vector (3 downto 0);          
     segments : out STD_LOGIC_VECTOR (6 downto 0));       
end component;

component Train_Logic is
    Port (H1, H2 : in Std_Logic;
         Em, CLK : in Std_Logic;
      Rev1, Rev2 : in Std_Logic;
           speed : in unsigned (1 downto 0);
             QT1 : buffer unsigned (2 downto 0);
             QT2 : buffer unsigned (2 downto 0));
end component;
   signal QT1 : unsigned (2 downto 0);
   signal QT2 : unsigned (2 downto 0);   
begin

Logic: Train_Logic port map (H1, H2, Em, CLK, Rev1, Rev2, Speed, QT1, QT2);
Train1_Flags: MUX_3x8 port map (QT1, TF1);
Train2_Flags: MUX_3x8 port map (QT2, TF2);
Station1: seven_display_station port map (CLK, TF1, TF2, anodes, segments);

end Train_Struct;