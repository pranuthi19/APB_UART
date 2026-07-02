class base_sequence extends uvm_sequence #(apb_xtn);

  `uvm_object_utils(base_sequence)

 // bit [7:0] LCR;

  extern function new(string name = "base_sequence");
  //extern task body();
endclass : base_sequence

function base_sequence::new(string name = "base_sequence");
  super.new(name);
endfunction : new

/*task base_sequence::body();
    super.body();
   // if (!uvm_config_db #(bit [7:0])::get(null, get_full_name(), "lcr", LCR))
      //`uvm_fatal(get_full_name(), "Cannot get LCR in sequence")
endtask : body*/


//----------------------------------------------------
//APB HALF DUPLEX SEQUENCE
//----------------------------------------------------
class half_duplex_seq extends base_sequence;

  `uvm_object_utils(half_duplex_seq)

  extern function new(string name = "half_duplex_seq");
  extern task body();

endclass : half_duplex_seq

function half_duplex_seq::new(string name = "half_duplex_seq");
  super.new(name);
endfunction : new

task half_duplex_seq::body();

  //super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  // LCR configuration
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == LCR;});
  finish_item(req);

  // FCR(FIFO enable)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h6;});
  finish_item(req);

  // IER(interuupt enable)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h01;});
  finish_item(req);

  /* THR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;Pwdata inside {[1 : 255]};});
  finish_item(req);*/

endtask : body

//---------------------------------------------------
//FULL DUPLEX SEQUENCE
//---------------------------------------------------
class full_duplex_seq extends base_sequence;

  `uvm_object_utils(full_duplex_seq)

  extern function new(string name = "full_duplex_seq");
  extern task body();

endclass : full_duplex_seq

function full_duplex_seq::new(string name = "full_duplex_seq");
  super.new(name);
endfunction : new

task full_duplex_seq::body();
   //super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  // LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == LCR;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h6;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h05;});
  finish_item(req);

  // THR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;Pwdata inside {[1 : 255]};});
  finish_item(req);

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

endtask : body

//-------------------------------------------------
//LOOP BACK SEQUENCE
//-------------------------------------------------
class loop_back_seq extends base_sequence;

  `uvm_object_utils(loop_back_seq)

  extern function new(string name = "loop_back_seq");
  extern task body;

endclass : loop_back_seq

function loop_back_seq::new(string name = "loop_back_seq");
  super.new(name);
endfunction : new

task loop_back_seq::body;

  super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;
  });
  finish_item(req);

  // LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == 32'h03;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h6;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h05;});
  finish_item(req);

  // MCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h10;Pwrite == 1'h1;Pwdata == 32'h10;});
  finish_item(req);

  // THR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;Pwdata inside {[1 : 255]};});
  finish_item(req);

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

  get_response(req);

  if (req.IIR[3:0] == 4'h4) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

  if (req.IIR[3:0] == 4'h6) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h14;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

endtask : body

//--------------------------------------------
//PARITY ERROR SEQUENCE
//--------------------------------------------
class parity_seq extends base_sequence;

  `uvm_object_utils(parity_seq)

  extern function new(string name = "parity_seq");
  extern task body;

endclass : parity_seq

function parity_seq::new(string name = "parity_seq");
  super.new(name);
endfunction : new

task parity_seq::body;

  super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  //LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == 32'h0b;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h6;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h05;});
  finish_item(req);

  // THR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;Pwdata inside {[1 : 255]};});
  finish_item(req);

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

  get_response(req);

  if (req.IIR[3:0] == 4'h4) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

  if (req.IIR[3:0] == 4'h6) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h14;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

endtask : body

//------------------------------------------
//BREAK ERROR SEQUENCE
//------------------------------------------
class break_error_seq extends base_sequence;

  `uvm_object_utils(break_error_seq)

  extern function new(string name = "break_error_seq");
  extern task body;

endclass : break_error_seq

function break_error_seq::new(string name = "break_error_seq");
  super.new(name);
endfunction : new

task break_error_seq::body;
   super.body();
  req = apb_xtn::type_id::create("req");
  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  //LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == 32'h43;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h6;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h05;});
  finish_item(req);

  // THR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;Pwdata inside {[1 : 255]};});
  finish_item(req);

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

  get_response(req);

  if (req.IIR[3:0] == 4'h4) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

  if (req.IIR[3:0] == 4'h6) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h14;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

endtask : body

//---------------------------------------------
//OVERRUN ERROR SEQUENCE
//---------------------------------------------
class overrun_error_seq extends base_sequence;

  `uvm_object_utils(overrun_error_seq)

  extern function new(string name = "overrun_error_seq");
  extern task body;

endclass : overrun_error_seq

function overrun_error_seq::new(string name = "overrun_error_seq");
  super.new(name);
endfunction : new

task overrun_error_seq::body;

  super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  // LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == 32'h03;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h06;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h04;});
  finish_item(req);

  // THR
  repeat (17) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;});
    finish_item(req);
  end

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

  get_response(req);

  if (req.IIR[3:0] == 4'h4) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

  if (req.IIR[3:0] == 4'h6) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h14;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end
endtask : body

//-----------------------------------------------
//FRAMING ERROR SEQUENCE
//-----------------------------------------------
class framing_error_seq extends base_sequence;

  `uvm_object_utils(framing_error_seq)

  extern function new(string name = "framing_error_seq");
  extern task body;

endclass : framing_error_seq

function framing_error_seq::new(string name = "framing_error_seq");
  super.new(name);
endfunction : new

task framing_error_seq::body;

        super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  //  LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == 32'h03;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h6;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h04;});
  finish_item(req);

  // THR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;Pwdata == 32'h5;});
  finish_item(req);

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

  get_response(req);

  if (req.IIR[3:0] == 4'h4) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

  if (req.IIR[3:0] == 4'h6) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h14;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end
endtask : body

//-----------------------------------------
//THR EMPTY SEQUENCE
//-----------------------------------------
class thr_empty_seq extends base_sequence;

  `uvm_object_utils(thr_empty_seq)

  extern function new(string name = "thr_empty_seq");
  extern task body;

endclass : thr_empty_seq

function thr_empty_seq::new(string name = "thr_empty_seq");
  super.new(name);
endfunction : new

task thr_empty_seq::body;

  super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  //LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == 32'h03;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h06;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h02;});
  finish_item(req);

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

  get_response(req);

  if (req.IIR[3:0] == 4'h4) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

  if (req.IIR[3:0] == 4'h6) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h14;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end
endtask : body

//----------------------------------------------
//TIME OUT ERROR SEQUENCE
//----------------------------------------------
class time_out_error_seq extends base_sequence;

  `uvm_object_utils(time_out_error_seq)

  extern function new(string name = "time_out_error_seq");
  extern task body;

endclass : time_out_error_seq

function time_out_error_seq::new(string name = "time_out_error_seq");
  super.new(name);
endfunction : new

task time_out_error_seq::body;

  super.body();
  req = apb_xtn::type_id::create("req");

  // DIV1(MSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h20;Pwrite == 1'h1;Pwdata == 32'h0;});
  finish_item(req);

  // DIV2(LSB)
  start_item(req);
  assert (req.randomize with {Paddr == 32'h1c;Pwrite == 1'h1;Pwdata == 32'd27;});
  finish_item(req);

  //LCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h0c;Pwrite == 1'h1;Pwdata == 32'h03;});
  finish_item(req);

  // FCR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h1;Pwdata == 32'h86;});
  finish_item(req);

  // IER
  start_item(req);
  assert (req.randomize with {Paddr == 32'h04;Pwrite == 1'h1;Pwdata == 32'h00;});
  finish_item(req);

  // THR
  repeat (17) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h1;});
    finish_item(req);
  end

  // IIR
  start_item(req);
  assert (req.randomize with {Paddr == 32'h08;Pwrite == 1'h0;Pwdata == 32'h00;});
  finish_item(req);

  get_response(req);

  if (req.IIR[3:0] == 4'h4) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h00;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end

  if (req.IIR[3:0] == 4'h6) begin
    start_item(req);
    assert (req.randomize with {Paddr == 32'h14;Pwrite == 1'h0;Pwdata == 0;});
    finish_item(req);
  end
endtask : body

//------------------------------------
//READ SEQUENCE
//------------------------------------
class apb_read_sequence extends base_sequence;

  `uvm_object_utils(apb_read_sequence)

   extern function new(string name = "apb_read_sequence");
   extern task body;

endclass: apb_read_sequence

function apb_read_sequence::new(string name = "apb_read_sequence");
  super.new(name);
endfunction : new

task apb_read_sequence::body;

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 0; });
    finish_item(req);
    get_response(req);

    if (req.IIR[3:0] == 4) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

    if (req.IIR[3:0] == 4'h6) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
      finish_item(req);
    end

    // IER Read (0x04)
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 0; });
    finish_item(req);
    get_response(req);

    // LCR Read (0x0C)
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0C; Pwrite == 0; });
    finish_item(req);
    get_response(req);

    // MCR Read (0x10)
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h10; Pwrite == 0; });
    finish_item(req);
    get_response(req);

    // LSR Read (0x14)
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
    finish_item(req);
    get_response(req);

    // MSR Read (0x18)
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h18; Pwrite == 0; });
    finish_item(req);
    get_response(req);

    // DIV 1 (0x1C)
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1C; Pwrite == 0; });
    finish_item(req);
    get_response(req);

        // DIV 2 (0x20)
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 0; });
    finish_item(req);
    get_response(req);


  endtask
