interface uart_if (input bit clk);

  logic tx;
  logic rx;
  logic IRQ;
  logic baud_o;

  // Clocking block
  clocking drv_cb @(posedge clk);
    default input #1 output #1;

    output tx;
    input  rx;
    input  IRQ;
    input  baud_o;
  endclocking

   clocking mon_cb @(posedge clk);
    default input #1 output #1;

    input tx;
    input rx;
    input IRQ;
    input baud_o;

  endclocking

  //modport DUT (input RXD, output TXD, IRQ, baud_o);
  modport DRV (clocking drv_cb);
  modport MON (clocking mon_cb);
endinterface
