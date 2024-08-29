# Multiplayer Number Guessing Game Using a PIC18 Microcontroller

Lab report: https://github.com/arantruslove/Assembly-Mastermind-Game/blob/mastermind/Aran_Truslove_Microprocessors_Report.pdf

## Overview
This project is an alpha prototype of a multiplayer number guessing game developed using a PIC18F87K22 microcontroller. The game is inspired by the classic "Mastermind" board game but introduces a competitive twist, allowing 1 to 6 players to guess a set of four unique random numbers between 1 and 12. The game was programmed in PIC18 Assembly language and uses a 4x4 matrix keypad for input and a 2x16 character LCD for output.

## Game Mechanics
- **Initialization:** Players input the number of participants (1-6), after which the microcontroller generates four unique random numbers using an oscilloscope for random noise.
- **Gameplay:** Players take turns guessing the numbers. After each guess, the number of correct numbers is displayed, without considering their positions.
- **Winning Condition:** The game continues until a player correctly guesses all four numbers, and they are declared the winner.

## Hardware
- **Microcontroller:** PIC18F87K22 with 128 KB of flash program memory and 4 KB of data memory.
- **Development Board:** EasyPIC PRO v7.
- **Display:** 2x16 character LCD.
- **Input:** 4x4 matrix keypad.
- **Random Number Generation:** Utilizes a combination of an ADC and an oscilloscope.

## Software
- **Programming Language:** PIC18 Assembly.
- **Memory Usage:** 2046 bytes of program memory and 48 bytes of data memory, making it potentially deployable on a cheaper PIC18F1230 microcontroller.
- **Random Number Testing:** Chi-square tests confirmed that randomness was significantly better when using an oscilloscope compared to unconnected port A noise.

## Proposed Improvements
- **Random Number Generation:** Explore alternatives to the oscilloscope for randomness, such as using ambient noise.
- **Memory Optimization:** Consolidate redundant code to save memory.
- **User Interface:** Consider upgrading to a 128x64 graphic LCD for a more enhanced display.
- **Gameplay Enhancement:** Introduce a countdown timer to add a level of urgency to each player's turn.

## Conclusion
The alpha prototype successfully demonstrates the core gameplay mechanics and efficient memory usage on the PIC18F87K22 microcontroller. Further refinements could lead to a more commercially viable product.
