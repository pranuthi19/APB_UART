class uart_base_seqs extends uvm_sequence #(uart_xtn);
  `uvm_object_utils(uart_base_seqs)

  bit [7:0] LCR;

  extern function new(string name = "uart_base_seqs");
  //extern task body();

endclass : uart_base_seqs

function uart_base_seqs::new(string name = "uart_base_seqs");
    super.new(name);
endfunction : new

/*task uart_base_seqs::body();
    super.body();
    if (!uvm_config_db #(bit [7:0])::get(null, get_full_name(), "lcr", LCR))
      `uvm_fatal(get_full_name(), "Cannot get LCR in sequence")
endtask : body*/


//==============================================================
// UART HALF DUPLEX SEQUENCE
//==============================================================

class uart_half_duplex_sequence extends uart_base_seqs;
  `uvm_object_utils(uart_half_duplex_sequence)

  extern function new(string name = "uart_half_duplex_sequence");
  extern task body();

endclass : uart_half_duplex_sequence

function uart_half_duplex_sequence::new(string name = "uart_half_duplex_sequence");
    super.new(name);
endfunction : new

/*task uart_half_duplex_sequence::body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;

    start_item(req);
    req.randomize  with { stop_bit == 1; };
    finish_item(req);
endtask : body*/

task uart_half_duplex_sequence::body();
    //super.body();

    req = uart_xtn::type_id::create("req");

    start_item(req);

    req.LCR = LCR;

    if (!req.randomize() with { stop_bit == 1; }) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in half duplex sequence")
    end

    finish_item(req);
endtask : body
//==============================================================
// UART FULL DUPLEX SEQUENCE
//==============================================================

class uart_full_duplex_sequence extends uart_base_seqs;
  `uvm_object_utils(uart_full_duplex_sequence)

  extern function new(string name = "uart_full_duplex_sequence");
  extern task body();

endclass : uart_full_duplex_sequence

function uart_full_duplex_sequence::new(string name = "uart_full_duplex_sequence");
    super.new(name);
endfunction : new

task uart_full_duplex_sequence::body();
    //super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;

    start_item(req);
    //req.randomize with { stop_bit == 1; });
         if (!req.randomize() with { stop_bit == 1; }) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in full duplex sequence")
    end

    finish_item(req);
endtask : body


//==============================================================
// UART LOOPBACK SEQUENCE
//==============================================================

class uart_loopback_sequence extends uart_base_seqs;

  `uvm_object_utils(uart_loopback_sequence)

  extern function new(string name = "uart_loopback_sequence");
  extern task body();

endclass : uart_loopback_sequence

function uart_loopback_sequence::new(string name = "uart_loopback_sequence");
    super.new(name);
endfunction : new

task uart_loopback_sequence::body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;

    start_item(req);
   // req.randomize() with { stop_bit == 1; };
         if (!req.randomize() with { stop_bit == 1; }) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in loop back sequence")
    end

    finish_item(req);

endtask : body


//==============================================================
// UART PARITY SEQUENCE
//==============================================================

class uart_sequence_parity extends uart_base_seqs;

  `uvm_object_utils(uart_sequence_parity)

  extern function new(string name = "uart_sequence_parity");
  extern task body();

endclass : uart_sequence_parity

function uart_sequence_parity::new(string name = "uart_sequence_parity");
    super.new(name);
endfunction : new

task uart_sequence_parity::body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    req.bad_parity = 1;

    start_item(req);
    //req.randomize() with { stop_bit == 1; };
         if (!req.randomize() with { stop_bit == 1; }) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in parity sequence")
    end

    finish_item(req);

endtask : body


//==============================================================
// UART FRAMING ERROR SEQUENCE
//==============================================================

class uart_framing_error_sequence extends uart_base_seqs;

  `uvm_object_utils(uart_framing_error_sequence)

  extern function new(string name = "uart_framing_error_sequence");
  extern task body();

endclass : uart_framing_error_sequence

function uart_framing_error_sequence::new(string name = "uart_framing_error_sequence");
    super.new(name);
endfunction : new

task uart_framing_error_sequence::body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    req.framing_error = 1;

    start_item(req);
   // req.randomize() with { stop_bit == 0; };
         if (!req.randomize() with { stop_bit == 0; }) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in framing error  sequence")
    end

    finish_item(req);

endtask : body


//==============================================================
// UART BREAK ERROR SEQUENCE
//==============================================================

class uart_break_error_sequence extends uart_base_seqs;

  `uvm_object_utils(uart_break_error_sequence)

  extern function new(string name = "uart_break_error_sequence");
  extern task body();

endclass : uart_break_error_sequence

function uart_break_error_sequence::new(string name = "uart_break_error_sequence");
    super.new(name);
endfunction : new

task uart_break_error_sequence::body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    req.break_error = 1;

    start_item(req);
    //req.randomize();
         if (!req.randomize()) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in break error sequence")
    end

    finish_item(req);

endtask : body


//==============================================================
// UART OVERRUN ERROR SEQUENCE
//==============================================================

class uart_overrun_error_sequence extends uart_base_seqs;

  `uvm_object_utils(uart_overrun_error_sequence)

  extern function new(string name = "uart_overrun_error_sequence");
  extern task body();

endclass : uart_overrun_error_sequence

function uart_overrun_error_sequence::new(string name = "uart_overrun_error_sequence");
    super.new(name);
endfunction : new

task uart_overrun_error_sequence::body();
    super.body();

    repeat(5) begin

        req = uart_xtn::type_id::create("req");
        req.LCR = LCR;
        req.overrun_error = 1;

        start_item(req);
        //req.randomize();
         if (!req.randomize()) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in overrun error sequence")
    end

        finish_item(req);

    end

endtask : body


//==============================================================
// UART THR EMPTY SEQUENCE
//==============================================================

class uart_thr_empty_sequence extends uart_base_seqs;

  `uvm_object_utils(uart_thr_empty_sequence)

  extern function new(string name = "uart_thr_empty_sequence");
  extern task body();

endclass : uart_thr_empty_sequence

function uart_thr_empty_sequence::new(string name = "uart_thr_empty_sequence");
    super.new(name);
endfunction : new

task uart_thr_empty_sequence::body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    req.thr_empty = 1;

    start_item(req);
    //req.randomize();
         if (!req.randomize()) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in THR empty sequence")
    end

    finish_item(req);

endtask : body


//==============================================================
// UART TIMEOUT ERROR SEQUENCE
//==============================================================

class uart_timeout_error_sequence extends uart_base_seqs;

  `uvm_object_utils(uart_timeout_error_sequence)

  extern function new(string name = "uart_timeout_error_sequence");
  extern task body();

endclass : uart_timeout_error_sequence

function uart_timeout_error_sequence::new(string name = "uart_timeout_error_sequence");
    super.new(name);
endfunction : new

task uart_timeout_error_sequence::body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    req.timeout_error = 1;

    start_item(req);
    //req.randomize();
         if (!req.randomize()) begin
      `uvm_fatal("UART_SEQ", "Randomization failed in Timeout error sequence")
    end

    finish_item(req);

endtask : body
