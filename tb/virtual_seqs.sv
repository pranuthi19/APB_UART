class v_sequence extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(v_sequence)

  virtual_sequencer vseqrh;

  extern function new(string name = "v_sequence");
  extern task body;

endclass : v_sequence

function v_sequence::new(string name = "v_sequence");
  super.new(name);
endfunction : new

task v_sequence::body;
  if (!$cast(vseqrh, m_sequencer)) `uvm_fatal("V_SEQUENCE", "CAST failed")
endtask : body

//--------------------------------------------
//FULL DUPLEX
//--------------------------------------------
class full_duplex_v_seq extends v_sequence;

  `uvm_object_utils(full_duplex_v_seq)

  full_duplex_seq seq1h;
  uart_full_duplex_sequence seq2h;

  extern function new(string name = "full_duplex_v_seq");
  extern task body;

endclass : full_duplex_v_seq

function full_duplex_v_seq::new(string name = "full_duplex_v_seq");
  super.new(name);
endfunction : new

task full_duplex_v_seq::body;
  super.body;
  seq1h = full_duplex_seq::type_id::create("seq1h");
  seq2h = uart_full_duplex_sequence::type_id::create("seq2h");
  fork

       seq1h.start(vseqrh.apb_seqrh[0]);

       seq2h.start(vseqrh.uart_seqrh[1]);

 join

endtask : body

//--------------------------------------------
//HALF DUPLEX
//--------------------------------------------

class half_duplex_v_seq extends v_sequence;

  `uvm_object_utils(half_duplex_v_seq)

  half_duplex_seq seq1h;
  uart_half_duplex_sequence seq2h;

  extern function new(string name = "half_duplex_v_seq");
  extern task body;

endclass : half_duplex_v_seq

function half_duplex_v_seq::new(string name = "half_duplex_v_seq");
  super.new(name);
endfunction : new

task half_duplex_v_seq::body;
  super.body;
  seq1h = half_duplex_seq::type_id::create("seq1h");
  seq2h = uart_half_duplex_sequence::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body

//---------------------------------------
//LOOP BACK
//---------------------------------------
class loop_back_v_seq extends v_sequence;

  `uvm_object_utils(loop_back_v_seq)

  loop_back_seq seq1h;
  uart_loopback_sequence seq2h;

  extern function new(string name = "loop_back_v_seq");
  extern task body;

endclass : loop_back_v_seq

function loop_back_v_seq::new(string name = "loop_back_v_seq");
  super.new(name);
endfunction : new

task loop_back_v_seq::body;
  super.body;
  seq1h = loop_back_seq::type_id::create("seq1h");
  seq2h = uart_loopback_sequence::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body

//---------------------------------------------
//PARITY
//---------------------------------------------
class parity_v_seq extends v_sequence;

  `uvm_object_utils(parity_v_seq)

  parity_seq seq1h;
  uart_sequence_parity seq2h;

  extern function new(string name = "parity_v_seq");
  extern task body;

endclass : parity_v_seq

function parity_v_seq::new(string name = "parity_v_seq");
  super.new(name);
endfunction : new

task parity_v_seq::body;
  super.body;
  seq1h = parity_seq::type_id::create("seq1h");
  seq2h = uart_sequence_parity::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body

//-----------------------------------------
//BREAK ERROR
//-----------------------------------------
class break_error_v_seq extends v_sequence;

  `uvm_object_utils(break_error_v_seq)

  break_error_seq seq1h;
  uart_break_error_sequence seq2h;

  extern function new(string name = "break_error_v_seq");
  extern task body;

endclass : break_error_v_seq

function break_error_v_seq::new(string name = "break_error_v_seq");
  super.new(name);
endfunction : new

task break_error_v_seq::body;
  super.body;
  seq1h = break_error_seq::type_id::create("seq1h");
  seq2h = uart_break_error_sequence::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body

//--------------------------------------------
//OVERRUN ERROR
//--------------------------------------------
class overrun_error_v_seq extends v_sequence;

  `uvm_object_utils(overrun_error_v_seq)

  overrun_error_seq seq1h;
  uart_overrun_error_sequence seq2h;

  extern function new(string name = "overrun_error_v_seq");
  extern task body;

endclass : overrun_error_v_seq

function overrun_error_v_seq::new(string name = "overrun_error_v_seq");
  super.new(name);
endfunction : new

task overrun_error_v_seq::body;
  super.body;
  seq1h = overrun_error_seq::type_id::create("seq1h");
  seq2h = uart_overrun_error_sequence::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body

//---------------------------------------------
//FRAMING ERROR
//---------------------------------------------
class framing_error_v_seq extends v_sequence;

  `uvm_object_utils(framing_error_v_seq)

  framing_error_seq seq1h;
  uart_framing_error_sequence seq2h;

  extern function new(string name = "framing_error_v_seq");
  extern task body;

endclass : framing_error_v_seq

function framing_error_v_seq::new(string name = "framing_error_v_seq");
  super.new(name);
endfunction : new

task framing_error_v_seq::body;
  super.body;
  seq1h = framing_error_seq::type_id::create("seq1h");
  seq2h = uart_framing_error_sequence::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body

//----------------------------------------
//THR EMPTY
//----------------------------------------
class thr_empty_v_seq extends v_sequence;

  `uvm_object_utils(thr_empty_v_seq)

  thr_empty_seq seq1h;
  uart_thr_empty_sequence seq2h;

  extern function new(string name = "thr_empty_v_seq");
  extern task body;

endclass : thr_empty_v_seq

function thr_empty_v_seq::new(string name = "thr_empty_v_seq");
  super.new(name);
endfunction : new

task thr_empty_v_seq::body;
  super.body;
  seq1h = thr_empty_seq::type_id::create("seq1h");
  seq2h = uart_thr_empty_sequence::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body

//-------------------------------------------
//TIME OUT
//-------------------------------------------
class time_out_error_v_seq extends v_sequence;

  `uvm_object_utils(time_out_error_v_seq)

  time_out_error_seq seq1h;
  uart_timeout_error_sequence seq2h;

  extern function new(string name = "time_out_error_v_seq");
  extern task body;

endclass : time_out_error_v_seq

function time_out_error_v_seq::new(string name = "time_out_error_v_seq");
  super.new(name);
endfunction : new

task time_out_error_v_seq::body;
  super.body;
  seq1h = time_out_error_seq::type_id::create("seq1h");
  seq2h = uart_timeout_error_sequence::type_id::create("seq2h");
  fork
    seq1h.start(vseqrh.apb_seqrh[0]);
    seq2h.start(vseqrh.uart_seqrh[1]);
  join
endtask : body
