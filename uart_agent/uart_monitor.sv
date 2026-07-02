class uart_monitor extends uvm_monitor;

  `uvm_component_utils(uart_monitor)

  uart_agent_config m_cfg;
  virtual uart_if  vif;

  uart_xtn r_xtn;
  bit [7:0] LCR;

  uvm_analysis_port #(uart_xtn) monitor_port;

  extern function new(string name = "uart_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_uart(ref logic line, ref bit [7:0] data, ref bit parity);

endclass : uart_monitor


// Constructor
function uart_monitor::new(string name = "uart_monitor", uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);
endfunction : new

// Build Phase
function void uart_monitor:: build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(uart_agent_config)::get(this, "", "uart_agent_config", m_cfg))
      `uvm_fatal("CONFIG", "Cannot get config in uart_monitor")

    if (!uvm_config_db #(bit [7:0])::get(this, "*", "lcr", LCR))
      `uvm_fatal("UART_MON", "Cannot get LCR in monitor")

    r_xtn = uart_xtn::type_id::create("r_xtn");
endfunction : build_phase

// Connect Phase
function void  uart_monitor:: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
endfunction : connect_phase

// Run Phase
task uart_monitor::run_phase(uvm_phase phase);
    bit rx_busy, tx_busy;

    fork

      // Monitor RX line
      forever begin
        if (rx_busy == 1'b0) begin
          rx_busy = 1'b1;
          collect_uart(vif.rx, r_xtn.rx, r_xtn.parity);
          rx_busy = 1'b0;
        end
        else begin
          @(posedge vif.mon_cb);
        end
      end

      // Monitor TX line
      forever begin
        if (tx_busy == 1'b0) begin
          tx_busy = 1'b1;
          collect_uart(vif.tx, r_xtn.tx, r_xtn.parity);
          tx_busy = 1'b0;
        end
        else begin
          @(posedge vif.mon_cb);
        end
      end

    join
endtask : run_phase

// Collect UART transaction from serial line
task uart_monitor::collect_uart(ref logic line, ref bit [7:0] data, ref bit parity);
    int bits;

    bits = LCR[1:0] + 5;  // Number of data bits

    // Wait for idle
    wait (line == 1'b1);
    @(posedge vif.mon_cb);

    // Wait for start bit
    wait (line == 1'b0);

    // Align to middle of bit
    repeat (24) @(posedge vif.mon_cb);

    // Collect data bits
    for (int i = 0; i < bits; i++) begin
      data[i] = line;
      repeat (16) @(posedge vif.mon_cb);
    end

    // Collect parity bit if enabled
    if (LCR[3]) begin
      parity = line;
    end

    // Wait for stop bit
    repeat (16) @(posedge vif.mon_cb);

    `uvm_info(get_type_name(),$sformatf("monitor data=%0b", data),UVM_LOW)

    monitor_port.write(r_xtn);
endtask : collect_uart
