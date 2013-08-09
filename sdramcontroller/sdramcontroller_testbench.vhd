-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 
		 
	COMPONENT sdramcontroller
	PORT(
		clk : IN std_logic;
		addr : IN std_logic_vector(15 downto 0);
		cmd : IN std_logic_vector(1 downto 0);    
		dataIn : IN std_logic_vector(7 downto 0);
		dataOut : OUT std_logic_vector(7 downto 0);
		ready : OUT std_logic;
		chipCS : OUT std_logic;
		chipWE : OUT std_logic;
		chipCAS : OUT std_logic;
		chipRAS : OUT std_logic;
		chipDQML : OUT std_logic;
		chipDQMH : OUT std_logic;
		chipBA : OUT std_logic_vector(1 downto 0);
		chipADDR : OUT std_logic_vector(11 downto 0);
		chipDATA : INOUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mt48lc4m16a2
	PORT(
		Addr : IN std_logic_vector(11 downto 0);
		Ba : IN std_logic_vector(1 downto 0);
		Clk : IN std_logic;
		Cke : IN std_logic;
		Cs_n : IN std_logic;
		Ras_n : IN std_logic;
		Cas_n : IN std_logic;
		We_n : IN std_logic;
		Dqm : IN std_logic_vector(1 downto 0);       
		Dq : INOUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	
	SIGNAL clk : std_logic;
	SIGNAL clkinv : std_logic;

	SIGNAL addr : std_logic_vector(15 downto 0) := (others => '0');
	SIGNAL cmd : std_logic_vector(1 downto 0) := "00";    
	SIGNAL dataIn : std_logic_vector(7 downto 0) := (others => 'Z'); 
	SIGNAL dataOut : std_logic_vector(7 downto 0) := (others => 'Z'); 
	SIGNAL ready : std_logic;
	SIGNAL chipCS : std_logic;
	SIGNAL chipWE : std_logic;
	SIGNAL chipCAS : std_logic;
	SIGNAL chipRAS : std_logic;
	
	SIGNAL chipDQML : std_logic;
	SIGNAL chipDQMH : std_logic;
	SIGNAL dqm : std_logic_vector(1 downto 0);

	SIGNAL chipBA : std_logic_vector(1 downto 0);
	SIGNAL chipADDR : std_logic_vector(11 downto 0);
	SIGNAL chipDATA : std_logic_vector(15 downto 0) := (others => 'Z');

	constant clk_period : time := 7.518ns;

BEGIN
  
	dqm <= chipDQMH & chipDQML;
	clkinv <= not clk;
	
	uut: sdramcontroller PORT MAP(
		clk => clk,
		addr => addr,
		dataIn => dataIn,
		dataOut => dataOut,
		cmd => cmd,
		ready => ready,
		chipCS => chipCS,
		chipWE => chipWE,
		chipCAS => chipCAS,
		chipRAS => chipRAS,
		chipDQML => chipDQML,
		chipDQMH => chipDQMH,
		chipBA => chipBA,
		chipADDR => chipADDR,
		chipDATA => chipDATA
	);

	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process clk_process;

	Inst_mt48lc4m16a2: mt48lc4m16a2 PORT MAP(
		Dq => chipDATA,
		Addr => chipADDR,
		Ba => chipBA,
		Clk => clkinv,
		Cke => '1',
		Cs_n => chipCS,
		Ras_n => chipRAS,
		Cas_n => chipCAS,
		We_n => chipWE,
		Dqm => dqm
	);

	tb : PROCESS
	BEGIN
		wait for 100 ns; -- wait until global set/reset completes
		
		wait for 1000 ns;
		--assert ready = '1' report "end of init sequence and controller not ready" severity failure;
			
		addr <= "0000000000011110";
		dataIn <= "11110101";
		cmd <= "11";
		
		wait for 20ns;
		cmd <= "00";
		
		wait for 30ns;
		assert chipData = "0000000011110101" report "chipData out didn't contain right data" severity failure;

		--chipDATA <= "0000000001010101";

		addr <= "0000000000011110";
		cmd <= "01";
		
		wait for 20ns;
		cmd <= "00";
		
		wait for 60ns;
		
		assert ready = '1' report "end of read sequence and controller not ready" severity failure;
		assert dataOut = "11110101" report "data out didn't contain right data" severity failure;
		
		--chipDATA <= (others => 'Z');

		wait; -- will wait forever
	END PROCESS tb;

END;
