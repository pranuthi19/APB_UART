class apb_agent_top extends uvm_agent;

  `uvm_component_utils(apb_agent_top)

  env_config env_cfg;

  apb_agent agth[];

  extern function new(string name = "apb_agent_top", uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : apb_agent_top

function apb_agent_top::new(string name = "apb_agent_top", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void apb_agent_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg))
    `uvm_fatal("APB_AGENT_TOP", "GET failed")


    foreach (agth[i]) begin
    uvm_config_db #(apb_agent_config)::set(this, $sformatf("agth[%0d]*", i), "apb_agent_config", env_cfg.agt_cfg[i]);
    agth[i] = apb_agent::type_id::create($sformatf("agth[%0d]", i), this);
  end

endfunction : build_phase
