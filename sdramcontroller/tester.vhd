library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

entity tester is
port (
	clk : IN std_logic;
	MEM_Clk : OUT std_logic;
	MEM_Cke : OUT std_logic;
	MEM_CS : OUT std_logic;
	nWE : OUT std_logic;
	nCAS : OUT std_logic;
	nRAS : OUT std_logic;
	DQML : OUT std_logic;
	DQMH : OUT std_logic;
	BA : OUT std_logic_vector(1 downto 0);
	ADDR : OUT std_logic_vector(12 downto 0);
	DATA : INOUT std_logic_vector(15 downto 0);
	A : OUT std_logic_vector(15 downto 0);
	reset : IN std_logic;
	up : IN std_logic

);
end tester;

architecture Behavioral of tester is

COMPONENT sdramcontroller PORT (
	clk : IN std_logic;
	addr : IN std_logic_vector(15 downto 0);
	cmd : IN std_logic_vector(1 downto 0);    
	dataIn : IN std_logic_vector(7 downto 0);
	dataOut : OUT std_logic_vector(7 downto 0);
	chipDATA : INOUT std_logic_vector(15 downto 0);
	ready : OUT std_logic;
	--chipClk : OUT std_logic;
	--chipCke : OUT std_logic;
	chipCS : OUT std_logic;
	chipWE : OUT std_logic;
	chipCAS : OUT std_logic;
	chipRAS : OUT std_logic;
	chipDQML : OUT std_logic;
	chipDQMH : OUT std_logic;
	chipBA : OUT std_logic_vector(1 downto 0);
	chipADDR : OUT std_logic_vector(11 downto 0)
);

END COMPONENT;

component clks port (
	CLK_IN1	: in std_logic;
	CLK_OUT1	: out std_logic;
	CLK_OUT2	: out std_logic
);
end component;


signal xaddr : std_logic_vector(15 downto 0);
signal xcmd : std_logic_vector(1 downto 0);    
signal xdataIn : std_logic_vector(7 downto 0);
signal xdataOut : std_logic_vector(7 downto 0);
signal ready : std_logic;

signal clk133out : std_logic;
signal clk133 : std_logic;
signal clk133inv : std_logic;
signal stopClock : std_logic;
signal holdClockLow : std_logic;
signal holdClockHigh : std_logic;
signal nextLights : std_logic_vector(3 downto 0);

signal waitCounter : std_logic_vector (31 downto 0) := (others => '0');

type stateType is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9);

signal currentState : stateType := s0;

begin

   ODDR2_inst : ODDR2
   generic map(
      DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
      INIT => '0', -- Sets initial state of the Q output to '0' or '1'
      SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
   port map (
      Q => clk133out, -- 1-bit output data
      C0 => clk133, -- 1-bit clock input
      C1 => clk133inv, -- 1-bit clock input
      CE => stopClock,  -- 1-bit clock enable input
      D0 => '0',   -- 1-bit data input (associated with C0)
      D1 => '1',   -- 1-bit data input (associated with C1)
      R => holdClockLow,    -- 1-bit reset input
      S => holdClockHigh     -- 1-bit set input
   );


	iClocks : clks port map (
		CLK_IN1 => clk,
		CLK_OUT1 => clk133,
		CLK_OUT2 => clk133inv
	);
	
	MEM_Clk <= clk133out;
	MEM_Cke <= '1';

	iSdram: sdramcontroller PORT MAP(
		clk => clk133,
		addr => xaddr,
		dataIn => xdataIn,
		dataOut => xdataOut,
		cmd => xcmd,
		ready => ready,
		--chipClk => MEM_Clk,
		--chipCke => MEM_Cke,
		chipCS => MEM_CS,
		chipWE => nWE,
		chipCAS => nCAS,
		chipRAS => nRAS,
		chipDQML => DQML,
		chipDQMH => DQMH,
		chipBA => BA,
		chipADDR => ADDR(11 downto 0),
		chipDATA => DATA 
	);

	main:
	process (clk133, reset, up) 
	begin
	
		if (reset = '1') then
			currentState <= s0;
		end if;
	
		if (rising_edge(clk133inv)) then
			case (currentState) is
				when s0 =>
					A(4) <= '1';
					A(5) <= '1';
					A(6) <= '1';
					A(7) <= '0';
					if (ready = '1') then
						currentState <= s1;
					end if;
					nextLights <= "0000";
					
				when s1 =>
					if (waitCounter = "00001111111111111111111111111111") then
						currentState <= s2;
						waitCounter <= (others => '0');
					else 
						waitCounter <= waitCounter + 1;
					end if;
					
				when s2 =>
					-- write
					xaddr <= "0000000000000111";
					
					xcmd <= "11";
					xdataIn <= "00000000";
					xdataIn(3 downto 0) <= nextLights;
					currentState <= s3;
					
				when s3 =>
					if (waitCounter = 2) then
						xcmd <= "00";
						waitCounter <= (others => '0');
						currentState <= s4;
					else 
						waitCounter <= waitCounter + 1;
					end if;
					
				when s4 => 
					-- wait
					if (ready = '1') then
						waitCounter <= (others => '0');
						currentState <= s5;
					else 
						waitCounter <= waitCounter + 1;
					end if;

				when s5 =>
					xaddr <= "0000000000000111";
					xcmd <= "01";
					currentState <= s6;
					
				when s6 =>
					if (waitCounter = 2) then
						xcmd <= "00";
						waitCounter <= (others => '0');
						currentState <= s7;
					else 
						waitCounter <= waitCounter + 1;
					end if;

				when s7 =>
					-- wait
					if (ready = '1') then
						currentState <= s8;
						waitCounter <= (others => '0');
					else 
						A(4) <= '0';
						A(5) <= '0';
						A(6) <= '0';
						A(7) <= '0';
						waitCounter <= waitCounter + 1;
					end if;

				when s8 =>
					-- read and set LEDs
					A(4)<=xdataOut(0);
					A(5)<=xdataOut(1);
					A(6)<=xdataOut(2);
					A(7)<=xdataOut(3);
					currentState <= s9;

				when s9 =>
					if (waitCounter = "00000000111111111111111111111111") then
						currentState <= s2;
						nextLights <= nextLights + 1;
						waitCounter <= (others => '0');
					else 
						waitCounter <= waitCounter + 1;
					end if;
					
			end case;
		end if;
	end process main;

end Behavioral;

