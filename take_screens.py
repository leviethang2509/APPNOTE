import time
import subprocess
from PIL import ImageGrab

# Khởi động app
proc = subprocess.Popen(
    ['D:\\flutter\\bin\\flutter.bat', 'run', '-d', 'chrome'],
    cwd=r'c:\Users\Admin\Desktop\FLUTER_THUCHANH\Lab5---Simple-Note-App-main',
    shell=True
)

time.sleep(15)  # Đợi app load xong

screens_dir = r'C:\Users\Admin\Desktop\screens_lab5'

# Ảnh 1: Home Page
img = ImageGrab.grab()
img.save(f'{screens_dir}/01_home_page.png')
print('1. Home Page captured')

time.sleep(3)

# Ảnh 2: Note Editor (giả sử ta click vào nút +)
# Click vào vị trí nút FAB (góc phải dưới) - tọa độ tương đối
# FAB thường ở bottom-right, màn hình 1920x1080 -> khoảng (1800, 1000)
import ctypes
ctypes.windll.user32.SetCursorPos(1800, 1000)
ctypes.windll.user32.mouse_event(2, 0, 0, 0, 0)  # left down
ctypes.windll.user32.mouse_event(4, 0, 0, 0, 0)  # left up
time.sleep(3)
img = ImageGrab.grab()
img.save(f'{screens_dir}/02_note_editor.png')
print('2. Note Editor captured')

time.sleep(2)

# Ảnh 3: Dark Mode - click vào toggle theme
# Vị trí nút theme toggle thường ở AppBar bên phải
ctypes.windll.user32.SetCursorPos(1880, 50)
ctypes.windll.user32.mouse_event(2, 0, 0, 0, 0)
ctypes.windll.user32.mouse_event(4, 0, 0, 0, 0)
time.sleep(2)
img = ImageGrab.grab()
img.save(f'{screens_dir}/03_dark_mode.png')
print('3. Dark Mode captured')

print('All screenshots done!')