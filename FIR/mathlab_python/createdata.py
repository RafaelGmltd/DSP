# import numpy as np
# import matplotlib.pyplot as plt
# import time
# import os

# current_dir = os.path.dirname(os.path.abspath(__file__))  # путь к директории скрипта
# file_path = os.path.join(current_dir, 'clean_sines.data')

# # Параметры генерации сигнала
# fs = 1000         # Частота дискретизации (Гц)
# duration = 1      # Длительность сигнала в секундах
# t = np.arange(0, duration, 1/fs)

# # Частоты синусоид
# f1 = 5
# f2 = 20

# # Генерация двух синусоид
# sine1 = np.sin(2 * np.pi * f1 * t)
# sine2 = np.sin(2 * np.pi * f2 * t)

# # Сложение сигналов
# combined_signal = sine1 + sine2

# # Нормализация (масштабирование) для целочисленного квантования
# combined_signal /= np.max(np.abs(combined_signal))

# # Квантование и масштабирование
# total_wordlength = 16
# scaling = 7  # масштабирование для увеличения точности
# quantized_signal = np.round(combined_signal * (2**scaling)).astype(int)

# # Функция для перевода в двоичный вид с учётом знака (2-комплементарный код)
# def int_to_bin_str(x, bits=16):
#     if x < 0:
#         x = (1 << bits) + x
#     return format(x, '0{}b'.format(bits))

# # Запись в файл
# with open(file_path, 'w') as f:
#     for val in quantized_signal:
#         bin_str = int_to_bin_str(val, total_wordlength)
#         f.write(bin_str + '\n')

# print(f'Файл {file_path} с чистыми синусоидами успешно создан.')

# # Визуализация
# plt.figure(figsize=(12, 6))
# plt.plot(t, sine1, label='Синусоида 1 (5 Гц)')
# plt.plot(t, sine2, label='Синусоида 2 (20 Гц)')
# plt.plot(t, combined_signal, label='Сложенный сигнал')
# plt.xlabel('Время, с')
# plt.ylabel('Амплитуда')
# plt.title('Две синусоиды и их сумма')
# plt.legend()
# plt.grid(True)
# plt.show()



# import numpy as np
# import matplotlib.pyplot as plt
# import time
# import os

# current_dir = os.path.dirname(os.path.abspath(__file__))  # путь к директории скрипта
# file_path = os.path.join(current_dir, 'clean_sines.data')

# # Параметры генерации сигнала
# fs = 256         # Частота дискретизации (Гц)
# duration = 1     # Длительность сигнала в секундах
# t = np.arange(0, duration, 1/fs)  # получаем 256 точек

# # Частоты синусоид
# f1 = 5
# f2 = 20

# # Генерация двух синусоид
# sine1 = np.sin(2 * np.pi * f1 * t)
# sine2 = np.sin(2 * np.pi * f2 * t)

# # Сложение сигналов
# combined_signal = sine1 + sine2

# # Нормализация (масштабирование) для целочисленного квантования
# combined_signal /= np.max(np.abs(combined_signal))

# # Квантование и масштабирование
# total_wordlength = 16
# scaling = 7  # масштабирование для увеличения точности
# quantized_signal = np.round(combined_signal * (2**scaling)).astype(int)

# # Функция для перевода в двоичный вид с учётом знака (2-комплементарный код)
# def int_to_bin_str(x, bits=16):
#     if x < 0:
#         x = (1 << bits) + x
#     return format(x, '0{}b'.format(bits))

# # Запись в файл
# with open(file_path, 'w') as f:
#     for val in quantized_signal:
#         bin_str = int_to_bin_str(val, total_wordlength)
#         f.write(bin_str + '\n')

# print(f'Файл {file_path} с чистыми синусоидами успешно создан.')

# # Визуализация
# plt.figure(figsize=(12, 6))
# plt.plot(t, sine1, label='Синусоида 1 (5 Гц)')
# plt.plot(t, sine2, label='Синусоида 2 (20 Гц)')
# plt.plot(t, combined_signal, label='Сложенный сигнал')
# plt.xlabel('Время, с')
# plt.ylabel('Амплитуда')
# plt.title('Две синусоиды и их сумма')
# plt.legend()
# plt.grid(True)
# plt.show()


import numpy as np
import matplotlib.pyplot as plt
import os

# Параметры генерации сигнала
fs = 100_000_000  # 100 MHz
duration = 2e-6   # 2 микросекунды — дадим 200 отсчётов (удобно)

t = np.arange(0, duration, 1/fs)

# Частоты синусоид (в Гц)
f1 = 500_000      # 0.5 MHz
f2 = 10_000_000   # 10 MHz

# Генерация двух синусоид
sine1 = np.sin(2 * np.pi * f1 * t)
sine2 = np.sin(2 * np.pi * f2 * t)

# Сложение сигналов
combined_signal = sine1 + sine2

# Нормализация
combined_signal /= np.max(np.abs(combined_signal))

# Квантование
total_wordlength = 16
scaling = 7
quantized_signal = np.round(combined_signal * (2**scaling)).astype(int)

# Файл
current_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(current_dir, 'dds_combined.data')

# Преобразование в 2-комплементарный вид
def int_to_bin_str(x, bits=16):
    if x < 0:
        x = (1 << bits) + x
    return format(x, '0{}b'.format(bits))

# Запись в файл
with open(file_path, 'w') as f:
    for val in quantized_signal:
        f.write(int_to_bin_str(val, total_wordlength) + '\n')

print(f'Файл {file_path} успешно создан.')

# Визуализация
plt.figure(figsize=(10, 4))
plt.plot(t * 1e6, sine1, label='0.5 MHz')
plt.plot(t * 1e6, sine2, label='10 MHz')
plt.plot(t * 1e6, combined_signal, label='Сложенный сигнал', linewidth=1.5)
plt.xlabel('Время (мкс)')
plt.ylabel('Амплитуда')
plt.title('Сложение 0.5 МГц и 10 МГц синусоид (fs = 100 МГц)')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
