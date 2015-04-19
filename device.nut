// CC1101 Code Example
 
///////////////////////////////////////////////////////////////////////////////////////
// GENERAL SETTINGS
local debug = false;
local INFO = 0;
local ERROR = 1;
 
///////////////////////////////////////////////////////////////////////////////////////
// CC1101 WRITE MASKS
const WRITE_BURST                 = 0x40;
const READ_SINGLE                 = 0x80;
const READ_BURST                  = 0xC0;
 
const CONFIG_REG                  = 0x80;
const STATUS_REG                  = 0xC0;
///////////////////////////////////////////////////////////////////////////////////////
// CC1101 CONFIG REGISTER
const _IOCFG2                     = 0x00; // GDO2 output pin configuration
const _IOCFG1                     = 0x01; // GDO1 output pin configuration
const _IOCFG0                     = 0x02; // GDO0 output pin configuration
const _FIFOTHR                    = 0x03; // RX FIFO and TX FIFO thresholds
const _SYNC1                      = 0x04; // Sync word, high INT8U
const _SYNC0                      = 0x05; // Sync word, low INT8U
const _PKTLEN                     = 0x06; // Packet length
const _PKTCTRL1                   = 0x07; // Packet automation control
const _PKTCTRL0                   = 0x08; // Packet automation control
const _ADDR                       = 0x09; // Device address
const _CHANNR                     = 0x0A; // Channel number
const _FSCTRL1                    = 0x0B; // Frequency synthesizer control
const _FSCTRL0                    = 0x0C; // Frequency synthesizer control
const _FREQ2                      = 0x0D; // Frequency control word, high INT8U
const _FREQ1                      = 0x0E; // Frequency control word, middle INT8U
const _FREQ0                      = 0x0F; // Frequency control word, low INT8U
const _MDMCFG4                    = 0x10; // Modem configuration
const _MDMCFG3                    = 0x11; // Modem configuration
const _MDMCFG2                    = 0x12; // Modem configuration
const _MDMCFG1                    = 0x13; // Modem configuration
const _MDMCFG0                    = 0x14; // Modem configuration
const _DEVIATN                    = 0x15; // Modem deviation setting
const _MCSM2                      = 0x16; // Main Radio Control State Machine configuration
const _MCSM1                      = 0x17; // Main Radio Control State Machine configuration
const _MCSM0                      = 0x18; // Main Radio Control State Machine configuration
const _FOCCFG                     = 0x19; // Frequency Offset Compensation configuration
const _BSCFG                      = 0x1A; // Bit Synchronization configuration
const _AGCCTRL2                   = 0x1B; // AGC control
const _AGCCTRL1                   = 0x1C; // AGC control
const _AGCCTRL0                   = 0x1D; // AGC control
const _WOREVT1                    = 0x1E; // High INT8U Event 0 timeout
const _WOREVT0                    = 0x1F; // Low INT8U Event 0 timeout
const _WORCTRL                    = 0x20; // Wake On Radio control
const _FREND1                     = 0x21; // Front end RX configuration
const _FREND0                     = 0x22; // Front end TX configuration
const _FSCAL3                     = 0x23; // Frequency synthesizer calibration
const _FSCAL2                     = 0x24; // Frequency synthesizer calibration
const _FSCAL1                     = 0x25; // Frequency synthesizer calibration
const _FSCAL0                     = 0x26; // Frequency synthesizer calibration
const _RCCTRL1                    = 0x27; // RC oscillator configuration
const _RCCTRL0                    = 0x28; // RC oscillator configuration
const _FSTEST                     = 0x29; // Frequency synthesizer calibration control
const _PTEST                      = 0x2A; // Production test
const _AGCTEST                    = 0x2B; // AGC test
const _TEST2                      = 0x2C; // Various test settings
const _TEST1                      = 0x2D; // Various test settings
const _TEST0                      = 0x2E; // Various test settings
 
//CC1101 Strobe commands
const _SRES                       = 0x30; // Reset chip.
const _SFSTXON                    = 0x31; // Enable and calibrate frequency synthesizer (if MCSM0.FS_AUTOCAL=1).
                                          // If in RX/TX: Go to a wait state where only the synthesizer is
                                          // running (for quick RX / TX turnaround).
const _SXOFF                      = 0x32; // Turn off crystal oscillator.
const _SCAL                       = 0x33; // Calibrate frequency synthesizer and turn it off
                                          // (enables quick start).
const _SRX                        = 0x34; // Enable RX. Perform calibration first if coming from IDLE and
                                          // MCSM0.FS_AUTOCAL=1.
const _STX                        = 0x35; // In IDLE state: Enable TX. Perform calibration first if
                                          // MCSM0.FS_AUTOCAL=1. If in RX state and CCA is enabled:
                                          // Only go to TX if channel is clear.
const _SIDLE                      = 0x36; // Exit RX / TX, turn off frequency synthesizer and exit
                                                // Wake-On-Radio mode if applicable.
const _SAFC                       = 0x37; // Perform AFC adjustment of the frequency synthesizer
const _SWOR                       = 0x38; // Start automatic RX polling sequence (Wakeon-Radio)
const _SPWD                       = 0x39; // Enter power down mode when CSn goes high.
const _SFRX                       = 0x3A; // Flush the RX FIFO buffer.
const _SFTX                       = 0x3B; // Flush the TX FIFO buffer.
const _SWORRST                    = 0x3C; // Reset real time clock.
const _SNOP                       = 0x3D; // No operation. May be used to pad strobe commands to two
                                          // INT8Us for simpler software.
 
///////////////////////////////////////////////////////////////////////////////////////
//CC1101 Status Registers
const _PARTNUM                    = 0x30;
const _VERSION                    = 0x31;
const _FREQEST                    = 0x32;
const _LQI                        = 0x33;
const _RSSI                       = 0x34;
const _MARCSTATE                  = 0x35;
const _WORTIME1                   = 0x36;
const _WORTIME0                   = 0x37;
const _PKTSTATUS                  = 0x38;
const _VCO_VC_DAC                 = 0x39;
const _TXBYTES                    = 0x3A;
const _RXBYTES                    = 0x3B;
const _RCCTRL1_STATUS             = 0x3C;
const _RCCTRL0_STATUS             = 0x3D;
 
///////////////////////////////////////////////////////////////////////////////////////
// Definitions to support burst/single access:
const CRC_OK                      = 0x80;
const RSSI                        = 0;
const LQI                         = 1;
const BYTES_IN_RXFIFO             = 0x7F;
///////////////////////////////////////////////////////////////////////////////////////
// Definitions for chip status
const CHIP_RDY                    = 0x80;
const CHIP_STATE_MASK             = 0x70;
const CHIP_STATE_IDLE             = 0x00;
const CHIP_STATE_RX               = 0x10;
const CHIP_STATE_TX               = 0x20;
const CHIP_STATE_FSTON            = 0x30;
const CHIP_STATE_CALIBRATE        = 0x40;
const CHIP_STATE_SETTLING         = 0x50;
const CHIP_STATE_RXFIFO_OVERFLOW  = 0x60;
const CHIP_STATE_TXFIFO_UNDERFLOW = 0x70;
const FIFO_BYTES_MASK             = 0x0F;
 
//CC1101 PATABLE,TXFIFO,RXFIFO
const _PATABLE                    = 0x3E;
const _TXFIFO                     = 0x3F;
const _RXFIFO                     = 0x3F;
const _SPI_WRITE_MASK             = 0x80;
 
/*
    SPI-189
 * CC1101          imp (April)
 * 1   <-      3.3     ->   3v3
 * 2   <-      SI      ->   8
 * 3   <-      SCLK    ->   1
 * 4   <-      SO      ->   9
 * 5   <-      GDO2    ->   2
 * 6   <-      GND     ->   GND
 * 7   <-      GDO0    ->   5
 * 8   <-      CSN     ->   7
 */
 
class CC1101
{
    spiMode = false;
    cs_pin = null;
    so_pin = null;
    rc_pin = null;
   
    spiSetup_flags = null;
    spiSetup_clock = null;
    spi = hardware.spi189;          // <- gives an error
   
    constructor(spi, clock, chipselect)
    {
        spiSetup_flags = 0;
        spiSetup_clock = clock;
        so_pin = hardware.pin9;     //why pin2 selected as SO
        cs_pin = chipselect;
       
        // Configure CS pin
        if(cs_pin != null)
        {
            cs_pin.configure(DIGITAL_OUT);
            DeselectChip();
        }
       
        Reset();
    }
   
    // Configure the imp to use SPI, pins 1,8 and 9
    function SelectSPI()
    {
        //hardware.configure(SPI_189);
        spiMode = true;
        return spi.configure(0,spiSetup_clock);
    }
   
    // Configure the imp to use
    function SelectDigitalRead()
    {
        so_pin.configure(DIGITAL_IN);
        spiMode = false;
    }
    // Reset preparation
    function SelectResetConfig()
    {
        hardware.pin1.configure(DIGITAL_OUT);
        hardware.pin8.configure(DIGITAL_OUT);
        spiMode = false;
    }
   
    function WaitMiso()
    {
        local i = 0;
        while(so_pin.read() == 1);
    }
   
    function SelectChip()   { cs_pin.write(0); }
    function DeselectChip() { cs_pin.write(1); }
   
    // Reset the chip
    function Reset()
    {
        // Manual POR sequence
        DeselectChip();             // Deselect CC1101
        SelectResetConfig();        // Use digital IO configuration
        hardware.pin1.write(1);     // Set SCLK 1
        hardware.pin8.write(0);     // Set SI 0
        imp.sleep(0.000005);        
        SelectChip();               // Select C1101
        imp.sleep(0.000010);    
        DeselectChip();             // Deselect CC1101
        imp.sleep(0.000041);
        SelectChip();               // Select CC1101
        SelectDigitalRead();        
        WaitMiso();                 // Wait until MISO goes low
        // XOSC Active Now
        // Send SRES strobe 
        SelectSPI();                // CS low
        local msg = blob(1);
        msg.writen(_SRES,'b');      // 8 bit unsigned blob
        spi.write(msg);             // Send reset strobe
        DeselectChip();             // Deselect
        SelectDigitalRead();                
        WaitMiso();                 // Wait until MISO goes low
    }
   
    /// Read a CC1101 register
    /// Summary: Reads a register's value
    /// Parameters:
    ///     regAddr - the register's address to read
    ///     regType - the register's type, can be STATUS_REG or CONFIG_REG
    function ReadReg(regAddr, regType)
    {
        local addr = regAddr | regType;
        SelectDigitalRead();                        // Make SO to digital pin
        SelectChip();                               // Select CC1101
        WaitMiso();                                 // Wait until MISO goes low
        SelectSPI();                                // Go back to SPI mode
        spi.write(format("%c",addr));   // Write the address
        spi.read(1);                    // Get the value
        spi.write(format("%c",0xFF));   // Write a dummy byte
        local result = hardware.spi189.read(1);     // Get the actual value
        DeselectChip()                              // Deselect CC1101
        return result[0];
    }
   
    function Write(regAddr, data)
    {
        SelectDigitalRead();                        // Make SO to digital pin
        SelectChip()                                // Select CC1101
        WaitMiso();                                 // Wait until MISO goes low
        SelectSPI();                                // Go back to SPI mode
        hardware.spi189.write(format("%c",regAddr));// Write the address
        hardware.spi189.write(format("%c",data));   // Write the data
        DeselectChip()                              // Deselect CC1101
    }
   
    function WriteBurst(regAddr, data, count)
    {
        local addr = regAddr | WRITE_BURST;
        SelectDigitalRead();                        // Make SO to digital pin
        SelectChip()                                // Select CC1101
        WaitMiso();                                 // Wait until MISO goes low
        SelectSPI();                                // Go back to SPI mode
        hardware.spi189.write(format("%c",addr));   // Write the address
       
        foreach(b in data)                          // Write the data
        {
            hardware.spi189.write(format("%c",b));
        }
       
        DeselectChip()                              // Deselect CC1101
    }
   
    // Strobe Command
    function Strobe(cmd)
    {
        SelectDigitalRead();                        // Make SO to digital pin
        SelectChip()                                // Select CC1101
        WaitMiso();                                 // Wait until MISO goes low
        SelectSPI();                                // Go back to SPI mode
        hardware.spi189.write(format("%c",cmd));    // Write the command
        local result = hardware.spi189.read(1);     // Get the chip status
        DeselectChip();                             // Deselect the chip
        server.log(result[0]);
    }
   
    // Send packet
    function SendPacket(packet, size)
    {
        local i = 0;
        local txBuffer = array(size + 1);
       
        for(i = size; i > 0; i--)
        {
            txBuffer[i] = packet[i - 1];
            Debug("txBuffer[" + i + "] = " + txBuffer[i],INFO);
        }
        txBuffer[0] = size;
        WriteBurst(_TXFIFO,txBuffer, size + 1);
       
        Strobe(_SIDLE);
        Strobe(_STX);
    }
}
 
// Send a debugging or error message to the server
function Debug(msg, level)
{
    switch(level)
    {
        case ERROR:
        {
            server.error(msg);
        }
        break;
       
        case INFO:
        {
            if(debug)
            {
                server.log(msg);
            }
        }
        break;
    }
}
 
// Create RF interface
imp.configure("CC1101 Example Code",[],[]);
 
// Get the version and the part number - verifies communication
function VerifyComm(){return (rf1.ReadReg(_VERSION, STATUS_REG) == 0x04 && rf1.ReadReg(_PARTNUM, STATUS_REG) == 0x00);}
 
// Create the class
rf1 <- CC1101(SPI_189, 120, hardware.pin7);
 
// Clear the planner view
server.show("");
 
// Start communications
if(VerifyComm())
{
    Debug("Comm is good", INFO);
    server.log("Completed");
}
 
else
{
    Debug("Comm link is bad",ERROR);
}
 
// End of code
