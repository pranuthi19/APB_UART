class apb_driver extends uvm_driver #(apb_xtn);

  `uvm_component_utils(apb_driver)

  apb_agent_config agt_cfg;

  virtual apb_if.DRV_MP vif;

  extern function new(string name = "apb_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task reset_duv;
  extern task send_to_duv(apb_xtn th);

endclass : apb_driver

function apb_driver::new(string name = "apb_driver", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void apb_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", agt_cfg))
    `uvm_fatal("APB_DRIVER", "GET failed")
endfunction : build_phase

function void apb_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    vif = agt_cfg.vif;
endfunction : connect_phase

task apb_driver::run_phase(uvm_phase phase);
  reset_duv;
  forever begin
    seq_item_port.get_next_item(req);
    send_to_duv(req);
    seq_item_port.item_done;
  end
endtask : run_phase

task apb_driver::reset_duv;
  @(vif.drv_cb);
  vif.drv_cb.Presetn <= 1'b0;
  @(vif.drv_cb);
  vif.drv_cb.Presetn <= 1'b1;
endtask : reset_duv

task apb_driver::send_to_duv(apb_xtn th);

  vif.drv_cb.Psel <= 1'b1;
  vif.drv_cb.Pwrite <= th.Pwrite;
  vif.drv_cb.Paddr <= th.Paddr;
  vif.drv_cb.Pwdata <= th.Pwdata;
  @(vif.drv_cb);
  vif.drv_cb.Penable <= 1'b1;
  while(vif.drv_cb.Pready !== 1'b1) @(vif.drv_cb);  //waiting for slave to be ready

  if(th.Paddr == 32'h08 && th.Pwrite == 1'h0) begin
    while(vif.drv_cb.IRQ !== 1'b1) @(vif.drv_cb);  //eaiting for interrupt request
    th.IIR = vif.drv_cb.Prdata;
    seq_item_port.put_response(th); //putting response
  end
  vif.drv_cb.Psel <= 1'b0;
  vif.drv_cb.Pwrite <= 1'b0;
  vif.drv_cb.Penable <= 1'b0;
  @(vif.drv_cb);

endtask : send_to_duv
