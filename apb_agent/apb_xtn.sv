class apb_xtn extends uvm_sequence_item;

  `uvm_object_utils(apb_xtn)

  // APB Signals
  logic Presetn;
  rand logic [31:0] Paddr, Pwdata;
  rand logic Pwrite;
  logic [31:0] Prdata;
  logic Penable, Psel, Pready, Pslverr, baud_o, IRQ;

  // UART Registers
  logic [7:0] RBR[$], THR[$], IER, IIR, FCR, LCR, MCR, LSR, MSR;
  logic [15:0] DIV;

  extern function new(string name = "apb_xtn");
  extern function void do_print(uvm_printer printer);

endclass : apb_xtn

function apb_xtn::new(string name = "apb_xtn");
  super.new(name);
endfunction : new

function void apb_xtn::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("PRESETN", this.Presetn, 1 , UVM_BIN);
  printer.print_field("PADDR",   this.Paddr, 32 , UVM_HEX);
  printer.print_field("PWDATA",  this.Pwdata, 32 , UVM_HEX);
  printer.print_field("PRDATA",  this.Prdata, 32 , UVM_HEX);
  printer.print_field("PWRITE",  this.Pwrite, 1 , UVM_HEX);
  printer.print_field("PENABLE", this.Penable, 1 , UVM_BIN);
  printer.print_field("PSEL",    this.Psel, 1  , UVM_HEX);
  printer.print_field("PREADY",  this.Pready, 1  , UVM_HEX);
  printer.print_field("PSLVERR", this.Pslverr, 1  , UVM_HEX);
  printer.print_field("BAUD_O",  this.baud_o, 1 , UVM_HEX);

  printer.print_field("IRQ", this.IRQ, 8 , UVM_HEX);
  printer.print_field("IER", this.IER, 8 , UVM_HEX);
  printer.print_field("IIR", this.IIR, 8 , UVM_HEX);
  printer.print_field("FCR", this.FCR, 8 , UVM_HEX);
  printer.print_field("LCR", this.LCR, 8 , UVM_HEX);
  printer.print_field("MCR", this.MCR, 8 , UVM_HEX);
  printer.print_field("LSR", this.LSR, 8 , UVM_HEX);
  printer.print_field("MSR", this.MSR, 8 , UVM_HEX);

  printer.print_field("DIV1", this.DIV[15:8], 8 , UVM_HEX);
  printer.print_field("DIV2", this.DIV[7:0], 8 , UVM_HEX);

  foreach(THR[i]) begin
    printer.print_field($sformatf("THR[%0d]", i), this.THR[i], 8  , UVM_HEX);
  end
  foreach(RBR[i]) begin
    printer.print_field($sformatf("RBR[%0d]", i), this.RBR[i], 8  , UVM_HEX);
  end

endfunction : do_print
