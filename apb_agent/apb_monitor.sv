class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)

  //Analysis port to send collected transactions
  uvm_analysis_port #(apb_xtn) mon_analysis_port;

  //virtual interface (monitor modport)
  virtual apb_if.MON_MP vif;

  //Transaction object
  apb_xtn th;

  //Agent configuration handle
  apb_agent_config agt_cfg;

  extern function new(string name = "apb_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_reset_from_duv;
  extern task collect_data_from_duv;

endclass : apb_monitor

function apb_monitor::new(string name = "apb_monitor", uvm_component parent);
  super.new(name, parent);
  mon_analysis_port = new("mon_analysis_port", this);
endfunction : new

function void apb_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  //Get agent configuration
  if (!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", agt_cfg))
    `uvm_fatal("APB_MONITOR", "GET failed")

  //create transaction object
  th = apb_xtn::type_id::create("th");
endfunction : build_phase

function void apb_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = agt_cfg.vif;
endfunction : connect_phase

task apb_monitor::run_phase(uvm_phase phase);
  collect_reset_from_duv;
  forever begin
    collect_data_from_duv;
  end
endtask : run_phase

task apb_monitor::collect_reset_from_duv;
  repeat (2) @(vif.mon_cb);
  th.Presetn = vif.mon_cb.Presetn;
  mon_analysis_port.write(th);
   `uvm_info("UART_MONITOR", $sformatf("\n%s", th.sprint), UVM_MEDIUM)
  @(vif.mon_cb);
endtask : collect_reset_from_duv

task apb_monitor::collect_data_from_duv;

  @(vif.mon_cb)

  //wait for enable pulse
  while(vif.mon_cb.Penable != 1)
         @(vif.mon_cb)

  begin : transfer_capture

          //wait for ready
          while (vif.mon_cb.Pready !== 1'b1)
                @(vif.mon_cb);

          //sample common signals
          th.Presetn = vif.mon_cb.Presetn;
          th.Paddr   = vif.mon_cb.Paddr;
          th.Psel    = vif.mon_cb.Psel;
          th.Pwrite  = vif.mon_cb.Pwrite;
          th.Penable = vif.mon_cb.Penable;
          th.Pwdata  = vif.mon_cb.Pwdata;
          th.Prdata  = vif.mon_cb.Prdata;
          th.Pready  = vif.mon_cb.Pready;
          th.Pslverr  = vif.mon_cb.Pslverr;
          th.IRQ     = vif.mon_cb.IRQ;
          th.baud_o = vif.mon_cb.baud_o;


          //sample data phase
          if(th.Pwrite)
                th.Pwdata = vif.mon_cb.Pwdata;
          else
                 th.Prdata = vif.mon_cb.Prdata;

          //Register updates based on address decoding
          //IIR read
          if (th.Paddr == 32'h8 && th.Pwrite == 1'b0) begin
                while (vif.mon_cb.IRQ !== 1'b1) @(vif.mon_cb);
                th.IRQ = vif.mon_cb.IRQ;
                th.Prdata = vif.mon_cb.Prdata;
                th.IIR = th.Prdata;
          end

          @(vif.mon_cb);
          if (th.Pwrite == 1'b1) begin

                //THR write
                if (th.Paddr == 32'h00)
                        th.THR.push_back(th.Pwdata);

                //IER update
                if (th.Paddr == 32'h04)
                        th.IER = th.Pwdata;

                //FCP update
                if (th.Paddr == 32'h08)
                        th.FCR = th.Pwdata;

                //LCR update
                if (th.Paddr == 32'h0c)
                        th.LCR = th.Pwdata;

                //MCR update
                if (th.Paddr == 32'h10)
                        th.MCR = th.Pwdata;

                //Divisior regiister 1 update
                if (th.Paddr == 32'h1c)
                        th.DIV[15:8] = th.Pwdata;

                //Divisor register 2 update
                if (th.Paddr == 32'h20)
                        th.DIV[7:0] = th.Pwdata;

                //LSR read
                if (th.Paddr == 32'h14)
                        th.LSR = th.Prdata;
          end

          if (th.IRQ == 1'b1) begin

                //RBR read
                if (th.Paddr == 32'h00)
                        th.RBR.push_back(th.Prdata);

                if (th.Paddr == 32'h18)
                        th.MSR = th.Prdata;
          end

  end : transfer_capture

  mon_analysis_port.write(th);
  `uvm_info("UART_MONITOR", $sformatf("\n%s", th.sprint), UVM_MEDIUM)

endtask : collect_data_from_duv
