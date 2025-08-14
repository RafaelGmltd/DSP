# Коэффиценты для КИХ фильтра

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import firwin, freqz

# === Параметры ===
Sample_Rate = 100e6
cutoff_frequency = 5e6
number_of_filter_taps = 32  # 32 для lowpass; 31 для highpass
filter_taps_bitwidth = 11
lowpass_highpass = 'low'  # 'low' или 'high'

# === Вычисление коэффициентов фильтра ===
Nyquist_frequency = Sample_Rate / 2
Wn = cutoff_frequency / Nyquist_frequency

filter_taps = firwin(
    numtaps=number_of_filter_taps,
    cutoff=Wn,
    pass_zero=lowpass_highpass == 'low'
)

# === Квантование (quantization) ===
# нормализация и округление
filter_taps_quantized = np.floor(
    filter_taps / np.max(np.abs(filter_taps)) * ((2 ** (filter_taps_bitwidth - 1)) - 1)
).astype(int)
print("Filter:",filter_taps_quantized)
# zero-padding (для highpass фильтра)
filter_taps_zero_padded = np.insert(filter_taps_quantized, 0, 0)

# # === Частотная характеристика ===
# N = 1024
# w, h = freqz(filter_taps_quantized, worN=N, fs=Sample_Rate)

# magnitude = np.abs(h)

# # === Графики ===
# plt.figure()
# plt.plot(w, 20 * np.log10(magnitude), linewidth=1.3)
# plt.title('Magnitude Response (dB)', fontsize=22)
# plt.xlabel('Frequency (Hz)', fontsize=22)
# plt.ylabel('Magnitude (dB)', fontsize=22)
# plt.grid(True)

# # === Отображение отсчетов фильтра ===
# plt.figure()
# plt.stem(filter_taps_quantized, basefmt=" ", use_line_collection=True)
# plt.title('Quantized Filter Coefficients')
# plt.xlabel('Tap Index')
# plt.ylabel('Value')
# plt.grid(True)

# plt.show()
