# Ultrasonic Rangefinder FPGA Project

## Overview

This project implements an ultrasonic rangefinder system on an FPGA, specifically designed for the DE10-Lite board (Intel MAX10). The system measures distance using an ultrasonic sensor (like HC-SR04) and displays the results on both a 7-segment display and a VGA monitor, providing a visual representation of the measured distance.

![Ultrasonic Rangefinder System](docs/system_diagram.png)

## Features

- **Accurate Distance Measurement**: Measures distances using ultrasonic sensor with centimeter precision
- **Dual Display Output**:
  - 7-segment display for numeric distance readings
  - VGA graphical display with:
    - Bar graph visualization
    - Numeric display
    - Color-coded distance indicators (green for close, yellow for medium, red for far)
- **Configurable Parameters**: Easily adjust measurement cycle, timeout, and display options
- **FPGA Implementation**: Fully hardware-implemented solution for real-time performance

## Hardware Requirements

- DE10-Lite Development Board (Intel MAX10 FPGA)
- Ultrasonic Sensor Module (HC-SR04 or compatible)
- VGA Monitor
- VGA Cable
- Jumper Wires
- 5V Power Supply (if not powered via USB)

## Pin Connections

### Ultrasonic Sensor Connections

| Signal | FPGA Pin | HC-SR04 Pin |
|--------|----------|-------------|
| Trigger | PIN_V15 | TRIG |
| Echo    | PIN_W15 | ECHO |
| 5V      | 5V      | VCC  |
| GND     | GND     | GND  |

### 7-Segment Display Connections

| Signal | FPGA Pin |
|--------|----------|
| seg_out[0] | PIN_W7 |
| seg_out[1] | PIN_W6 |
| seg_out[2] | PIN_U8 |
| seg_out[3] | PIN_V8 |
| seg_out[4] | PIN_U5 |
| seg_out[5] | PIN_V5 |
| seg_out[6] | PIN_U7 |
| digit_sel[0] | PIN_U2 |
| digit_sel[1] | PIN_U4 |
| digit_sel[2] | PIN_V4 |
| digit_sel[3] | PIN_W4 |

### VGA Connections

| Signal | FPGA Pin |
|--------|----------|
| vga_r[0] | PIN_AA1 |
| vga_r[1] | PIN_V1 |
| vga_r[2] | PIN_Y2 |
| vga_r[3] | PIN_Y1 |
| vga_g[0] | PIN_W1 |
| vga_g[1] | PIN_T2 |
| vga_g[2] | PIN_R2 |
| vga_g[3] | PIN_R1 |
| vga_b[0] | PIN_P1 |
| vga_b[1] | PIN_T1 |
| vga_b[2] | PIN_P4 |
| vga_b[3] | PIN_N2 |
| vga_hs | PIN_N3 |
| vga_vs | PIN_N1 |

## Project Structure

ultrasonic_rangefinder/
├── src/
│   ├── ultrasonic_top.vhd         (Top-level module)
│   ├── trigger_generator.vhd      (Generates 10μs trigger pulses)
│   ├── echo_handler.vhd           (Measures echo pulse duration)
│   ├── distance_calculator.vhd    (Converts time to distance)
│   ├── display_controller.vhd     (Controls 7-segment displays)
│   ├── clock_divider.vhd          (Divides the system clock)
│   ├── binary_to_bcd.vhd          (Converts binary to BCD for display)
│   └── vga_display_module.vhd     (Handles VGA display)
├── ip/
│   └── vga_ip/                    (VGA IP core files)
│       ├── hdl/
│       │   ├── DPRAM.vhd
│       │   ├── VGA_IP.vhd
│       │   └── VGA_Sync.vhd
│       ├── VGA_IP_hw.tcl
│       └── VGA_IP_sw.tcl
├── qsys/
│   └── ultrasonic_vga_system.qsys (Platform Designer system)
├── constraints/
│   └── constraints.sdc            (Timing constraints)
├── testbench/
│   ├── ultrasonic_top_tb.vhd      (Testbench for top module)
│   └── echo_handler_tb.vhd        (Testbench for echo handler)
└── docs/
    ├── system_diagram.png
    └── waveforms.png

![image](https://github.com/user-attachments/assets/de944bc5-c3fd-4fc8-9aea-71f22a1ca3ac)

## Setup and Installation

### Prerequisites

- Quartus Prime Lite Edition (18.1 or later recommended)
- DE10-Lite Development Board
- USB Cable (for programming)

### Building the Project

1. **Clone or download this repository**

2. **Open the project in Quartus Prime**
   - Launch Quartus Prime
   - Open the project file (`ultrasonic_rangefinder.qpf`)

3. **Generate the Platform Designer system**
   - Open Platform Designer (Tools > Platform Designer)
   - Load the `ultrasonic_vga_system.qsys` file
   - Click "Generate HDL" and select the output directory
   - Click "Generate"

4. **Compile the project**
   - In Quartus Prime, click "Processing" > "Start Compilation"
   - Wait for compilation to complete

5. **Program the FPGA**
   - Connect the DE10-Lite board to your computer via USB
   - Turn on the board
   - In Quartus Prime, open the programmer (Tools > Programmer)
   - Click "Hardware Setup" and select your USB-Blaster
   - Click "Auto Detect" to detect the FPGA device
   - Select the `.sof` file in the output directory
   - Click "Start" to program the FPGA

### Hardware Setup

1. **Connect the ultrasonic sensor**
   - Connect the TRIG pin to PIN_V15 on the FPGA
   - Connect the ECHO pin to PIN_W15 on the FPGA
   - Connect VCC to 5V and GND to ground

2. **Connect the VGA monitor**
   - Connect a VGA cable between the DE10-Lite board and a VGA monitor
   - Turn on the monitor and set it to the appropriate input

## Usage

1. **Power on the system**
   - The 7-segment display will show "----" during initialization

2. **Position the ultrasonic sensor**
   - Point the sensor toward the object you want to measure
   - Ensure there are no obstacles between the sensor and the target

3. **Read the distance**
   - The distance will be displayed on the 7-segment display in centimeters
   - The VGA display will show:
     - A bar graph representing the distance
     - The numeric distance value
     - Color coding (green for close, yellow for medium, red for far)

4. **Reset the system (if needed)**
   - Toggle SW[9] to reset the system

## Implementation Details

### Distance Measurement

The system measures distance using the following principle:

1. Send a 10μs trigger pulse to the ultrasonic sensor
2. Measure the duration of the echo pulse
3. Calculate distance using the formula: distance = (pulse duration × speed of sound) / 2

The speed of sound is approximately 343 m/s at room temperature, which is 34,300 cm/s or 0.0343 cm/μs.

### Clock Management

The system uses multiple clock domains:

- System clock (50 MHz) for general operation
- 1 MHz clock for precise timing of ultrasonic measurements
- 25 MHz clock for VGA display

### VGA Display

The VGA display shows:

1. A bar graph that grows/shrinks with the measured distance
2. The numeric distance value
3. Color coding based on distance:
   - Green: < 50 cm
   - Yellow: 50-150 cm
   - Red: > 150 cm

## Troubleshooting

### No Distance Reading

- Check the connections between the FPGA and the ultrasonic sensor
- Ensure the sensor is powered correctly (5V)
- Verify that there are no obstacles too close to the sensor
- Check that the target object is within range (2cm to 400cm typically)

### Inaccurate Readings

- Ensure the sensor is pointed directly at the target
- Check for interference from other ultrasonic sources
- Verify that the environment temperature is within normal range (temperature affects sound speed)

### No VGA Display

- Check the VGA cable connections
- Verify that the monitor supports the VGA resolution (640x480 @ 60Hz)
- Check that the 25 MHz clock is correctly generated

## Future Improvements

- Add temperature compensation for more accurate measurements
- Implement multiple sensor support
- Add data logging capabilities
- Implement filtering for noisy measurements
- Add Bluetooth/WiFi connectivity for remote monitoring
- Create a more sophisticated VGA display with historical data graphs

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Intel for the DE10-Lite development board
- The open-source FPGA community for various resources and inspiration
