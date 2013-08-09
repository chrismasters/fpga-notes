library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity vga_test is

	port ( 
		red : out  STD_LOGIC_VECTOR (3 downto 0);
		green : out  STD_LOGIC_VECTOR (3 downto 0);
		blue : out  STD_LOGIC_VECTOR (3 downto 0);
		hsync : out  STD_LOGIC;
		vsync : out  STD_LOGIC;
		sw1 : in  STD_LOGIC;
		sw2 : in  STD_LOGIC;
		sw3 : in  STD_LOGIC;
		clk : in STD_LOGIC
	);
	
end vga_test;

architecture Behavioral of vga_test is

component vga_clk
	port (
		CLK_IN1 : in std_logic;
		CLK_OUT1 : out    std_logic
	);
	
end component;

signal c25 : STD_LOGIC := '0';
signal hcount : STD_LOGIC_VECTOR(9 downto 0);
signal vcount : STD_LOGIC_VECTOR(9 downto 0);

begin

cc : vga_clk
	port map (
		CLK_IN1 => clk,
		CLK_OUT1 => c25
	);
	 
process (c25)
begin
	if rising_edge(c25) then
		if (hcount = 799) then
			hcount <= (others => '0');
			if vcount = 524 then
				vcount <=  (others => '0');
			else
				vcount <= vcount + 1;
			end if;
		else
			hcount<= hcount + 1;
		end if;
		if vcount >= 490 and vcount < 492 then
			vsync <= '0';
		else 
			vsync <= '1';
		end if;
		if hcount >=656 and hcount <752 then
			hsync <= '0';
		else
			hsync <= '1';
		end if;
		if hcount< 630 and vcount < 480 then
			if (sw1 = '1') then
				red<="1111";
			else 
				red<="0000";
			end if;
			if (sw2 = '1') then
				green<="1111";
			else 
				green<="0000";
			end if;
			if (sw3 = '1') then
				blue<="1111";
			else 
				blue<="0000";
			end if;
		else
			red <= "0000";
			green <= "0000";
			blue <= "0000";			
		end if;
	end if;
end process;

end Behavioral;

