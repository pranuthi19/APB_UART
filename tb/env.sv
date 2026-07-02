class env extends uvm_env;

  `uvm_component_utils(env)

  env_config env_cfg;

  // Components
  virtual_sequencer    vseqrh;
  uart_agent_top agt_toph;
  apb_agent_top  apb_agt_top;
  scoreboard     sbh;

  extern function new(string name = "env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : env


// ================================
// Constructor
// ================================
function env::new(string name = "env", uvm_component parent);
  super.new(name, parent);
endfunction : new


// ================================
// Build Phase
// ================================
function void env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Get config (ONLY ONCE)
  if (!uvm_config_db#(env_config)::get(this, "", "env_config", env_cfg))
    `uvm_fatal("ENV", "GET failed")

  // Virtual Sequencer
  if (env_cfg.has_v_sequencer)
    vseqrh = virtual_sequencer::type_id::create("vseqrh", this);

  // APB Agent
  if (env_cfg.has_apb_agent) begin
    uvm_config_db #(env_config)::set(this, "apb_agt_top", "env_config", env_cfg);
    apb_agt_top = apb_agent_top::type_id::create("apb_agt_top", this);
  end

  // UART Agent
  if (env_cfg.has_uart_agent) begin
    uvm_config_db #(env_config)::set(this, "agt_toph", "env_config", env_cfg);
    agt_toph = uart_agent_top::type_id::create("agt_toph", this);
  end

  // Scoreboard (ONLY ONCE)
  if (env_cfg.has_sb)
    sbh = scoreboard::type_id::create("sbh", this);

endfunction : build_phase


// ================================
// Connect Phase
// ================================
function void env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  // ---------------- APB ----------------
  if (env_cfg.has_v_sequencer && env_cfg.has_apb_agent) begin
    foreach (apb_agt_top.agth[i]) begin
      vseqrh.apb_seqrh[i] = apb_agt_top.agth[i].apb_seqrh;
    end
  end

  if (env_cfg.has_sb && env_cfg.has_apb_agent) begin
    foreach (apb_agt_top.agth[i]) begin
      apb_agt_top.agth[i].monh.mon_analysis_port.connect( sbh.fifo_h_w.analysis_export);
    end
  end


  // ---------------- UART ----------------
  if (env_cfg.has_v_sequencer && env_cfg.has_uart_agent) begin
    foreach (agt_toph.agth[i]) begin
      vseqrh.uart_seqrh[i] = agt_toph.agth[i].uart_seqrh;
    end
  end

  if (env_cfg.has_sb && env_cfg.has_uart_agent) begin
    foreach (agt_toph.agth[i]) begin
      agt_toph.agth[i].monh.monitor_port.connect(sbh.fifo_h_r.analysis_export);
    end
  end

endfunction : connect_phase
