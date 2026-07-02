class env_config extends uvm_object;

  `uvm_object_utils(env_config)

  bit has_v_sequencer = 1;
  bit has_apb_agent = 1;
  bit has_uart_agent = 1;
  bit has_sb = 1;

  apb_agent_config agt_cfg[];
  uart_agent_config m_cfg[];

  extern function new(string name = "env_config");

endclass : env_config

function env_config::new(string name = "env_config");
  super.new(name);
endfunction : new
