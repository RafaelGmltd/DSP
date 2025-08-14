import numpy as np
import matplotlib.pyplot as plt
import time
import os

current_dir = os.path.dirname(os.path.abspath(__file__))  # путь к директории скрипта
file_path = os.path.join(current_dir, 'noisy.data')

# 1. Генерация синусоиды
fs = 5  # частота дискретизации
Amp = 1  # амплитуда
t = np.arange(0, 2*np.pi, 1/fs)  # вектор времени
sine_wave = Amp * np.sin(t)

plt.figure()
plt.plot(t, sine_wave)
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.title('Sine wave')
plt.grid(True)

# 2. Инициализация генератора случайных чисел с seed по времени
current_time = time.time()  # время в секундах с эпохи
time_seed = int((current_time * 1e6) % (2**32))
np.random.seed(time_seed)

# 3. Добавление шума
a = 0.8  # верхняя граница шума
b = 0    # нижняя граница шума
noise = np.random.uniform(low=b, high=a, size=sine_wave.shape)
sine_noise = sine_wave + noise
sine_norm = sine_noise / np.max(np.abs(sine_noise))

plt.figure()
plt.plot(range(len(sine_norm)), sine_norm)
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.title('Sine wave + Noise')
plt.grid(True)

# 4. Квантование и масштабирование
total_wordlength = 16
scaling = 7
sine_noise_integers = np.round(sine_norm * (2**scaling)).astype(int)

plt.figure()
plt.plot(range(len(sine_noise_integers)), sine_noise_integers)
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.title('Sine wave + Noise : Scaled Signal')
plt.grid(True)

# 5. Конвертация в бинарный формат и запись в файл
def int_to_bin_str(x, bits=16):
    # преобразуем число в двоичную строку с учётом знака (дополнительный код)
    if x < 0:
        x = (1 << bits) + x
    return format(x, '0{}b'.format(bits))

with open(file_path, 'w') as f:
    for val in sine_noise_integers:
        bin_str = int_to_bin_str(val, total_wordlength)
        f.write(bin_str + '\n')

print('Data file for noisy is finished.')

plt.show()


# import numpy as np
# import matplotlib.pyplot as plt
# import os
# import time

# # 1. Параметры сигнала и времени
# fs = 100  # частота дискретизации, Гц
# t = np.arange(0, 0.64, 1/fs)  # 2 секунды

# # 2. Создаем сложный сигнал
# sig1 = 0.7 * np.sin(2 * np.pi * 5 * t)    # 5 Гц
# sig2 = 0.3 * np.sin(2 * np.pi * 15 * t)   # 15 Гц
# sig3 = 0.2 * np.sin(2 * np.pi * 30 * t)   # 30 Гц

# impulse = np.zeros_like(t)
# impulse[(t > 0.5) & (t < 0.6)] = 1.0

# complex_signal = sig1 + sig2 + sig3 + impulse

# # 3. Добавляем шум с seed, основанным на времени
# current_time = time.time()
# time_seed = int((current_time * 1e6) % (2**32))
# np.random.seed(time_seed)
# noise = 0.1 * np.random.randn(len(t))

# complex_signal_noisy = complex_signal + noise

# # 4. Нормируем сигнал
# complex_signal_noisy /= np.max(np.abs(complex_signal_noisy))

# # Визуализация
# plt.figure(figsize=(10,4))
# plt.plot(t, complex_signal_noisy)
# plt.title("Сложный сигнал с шумом")
# plt.xlabel("Время, с")
# plt.ylabel("Амплитуда")
# plt.grid(True)
# plt.show()

# # 5. Квантование и масштабирование
# total_wordlength = 16
# scaling = 7
# scaled_signal = np.round(complex_signal_noisy * (2**scaling)).astype(int)

# # 6. Функция преобразования в 16-битный двоичный код с дополнительным кодом
# def int_to_bin_str(x, bits=16):
#     if x < 0:
#         x = (1 << bits) + x
#     return format(x, f'0{bits}b')

# # 7. Сохраняем в файл в директории скрипта
# current_dir = os.path.dirname(os.path.abspath(__file__))
# file_path = os.path.join(current_dir, 'noisy.data')

# with open(file_path, 'w') as f:
#     for val in scaled_signal:
#         f.write(int_to_bin_str(val, total_wordlength) + '\n')

# print(f'Data file for noisy is finished and saved to {file_path}')
