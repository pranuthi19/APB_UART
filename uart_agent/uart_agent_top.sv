class uart_agent_top extends uvm_agent;

  `uvm_component_utils(uart_agent_top)

  env_config env_cfg;

  uart_agent agth[];

  extern function new(string name = "uart_agent_top", uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : uart_agent_top

function uart_agent_top::new(string name = "uart_agent_top", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void uart_agent_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg))
    `uvm_fatal("UART_AGENT_TOP", "GET failed")

   foreach (agth[i]) begin
    uvm_config_db #(uart_agent_config)::set(this, $sformatf("agth[%0d]*", i), "uart_agent_config",env_cfg.m_cfg[i]);
    agth[i] = uart_agent::type_id::create($sformatf("agth[%0d]", i), this);
  end

endfunction : build_phase
