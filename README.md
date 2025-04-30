# SourceCodingVisualizer

**SourceCodingVisualizer** is a MATLAB GUI application for visualizing and comparing three fundamental source coding (compression) techniques: **Fano**, **Huffman**, and **Lempel-Ziv (LZ78)**. This tool is designed for educational use and helps users understand how different coding algorithms work with custom symbol inputs and probabilities.

## 🧠 Features

- Interactive GUI built using MATLAB's `uifigure`
- Support for three coding techniques:
  - Fano Coding
  - Huffman Coding (using MATLAB's `huffmandict`)
  - Lempel-Ziv (LZ78) compression
- Custom input for:
  - Symbols
  - Corresponding probabilities (for Fano and Huffman)
  - Direct input sequence (for LZ78)
- Real-time visual output of encoded results

## 📷 GUI Preview

![image](https://github.com/user-attachments/assets/c15f89fc-c32a-4e89-b15f-df36c84eadbe)


## 🚀 How to Run

1. Open MATLAB.
2. Navigate to the directory containing the code file.
3. Run the main script:
   ```matlab
   coding_techniques_gui
