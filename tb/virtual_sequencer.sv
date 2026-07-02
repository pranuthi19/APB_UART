class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

  `uvm_component_utils(virtual_sequencer)

  uart_sequencer uart_seqrh[2];
  apb_sequencer apb_seqrh[1];

  extern function new(string name = "virtual_sequencer", uvm_component parent);

endclass : virtual_sequencer

function virtual_sequencer::new(string name = "virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new
