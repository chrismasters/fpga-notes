
-- VHDL Instantiation Created from source file sdramcontroller.vhd -- 22:02:59 08/03/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT sdramcontroller
	PORT(
		clk : IN std_logic;
		addr : IN std_logic_vector(15 downto 0);
		cmd : IN std_logic_vector(1 downto 0);    
		data : INOUT std_logic_vector(7 downto 0);
		chipDATA : INOUT std_logic_vector(15 downto 0);      
		ready : OUT std_logic;
		chipClk : OUT std_logic;
		chipCke : OUT std_logic;
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

	Inst_sdramcontroller: sdramcontroller PORT MAP(
		clk => ,
		addr => ,
		data => ,
		cmd => ,
		ready => ,
		chipClk => ,
		chipCke => ,
		chipCS => ,
		chipWE => ,
		chipCAS => ,
		chipRAS => ,
		chipDQML => ,
		chipDQMH => ,
		chipBA => ,
		chipADDR => ,
		chipDATA => 
	);


