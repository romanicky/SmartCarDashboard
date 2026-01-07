import socket
import json
import threading
import time
import tkinter as tk
from tkinter import ttk

class CarSimulatorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Vehicle Simulator Control")
        self.root.geometry("300x250")

        self.speed = 0
        self.left_signal = False
        self.right_signal = False

        # --- UI Components ---
        self.btn_add = tk.Button(root, text="+10 km/h", command=lambda: self.speed_slider.set(min(self.speed + 10, 220)))
        self.btn_add.pack(pady=5)

        self.btn_sub = tk.Button(root, text="-10 km/h", command=lambda: self.speed_slider.set(max(self.speed - 10, 0)))
        self.btn_sub.pack(pady=5)

        # Nút bấm Xi-nhan
        self.btn_left = tk.Button(root, text="Left Signal", command=self.toggle_left)
        self.btn_left.pack(pady=5)
        
        self.btn_right = tk.Button(root, text="Right Signal", command=self.toggle_right)
        self.btn_right.pack(pady=5)

        # Gear selector buttons (N D R P)
        gear_frame = tk.Frame(root)
        gear_frame.pack(pady=10)
        
        gear_buttons = ["N", "D", "R", "P"]
        self.gear_buttons = {}
        for gear in gear_buttons:
            btn = tk.Button(gear_frame, text=gear, width=4, command=lambda g=gear: self.select_gear(g))
            btn.pack(side='left', padx=5)
            self.gear_buttons[gear] = btn
        
        self.current_gear = "N"

        # Khởi động luồng mạng (Socket)
        self.server_thread = threading.Thread(target=self.start_server, daemon=True)
        self.server_thread.start()

    def update_speed(self, val):
        self.speed = int(float(val))
        self.speed_label.config(text=str(self.speed))

    def toggle_left(self):
        self.left_signal = not self.left_signal
        self.btn_left.config(bg="green" if self.left_signal else "systemButtonFace")

    def toggle_right(self):
        self.right_signal = not self.right_signal
        self.btn_right.config(bg="green" if self.right_signal else "systemButtonFace")

    def select_gear(self, gear):
        self.current_gear = gear
        # Update button colors - highlight selected gear
        for g, btn in self.gear_buttons.items():
            btn.config(bg="blue" if g == gear else "systemButtonFace")

    def start_server(self):
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server_socket.bind(('127.0.0.1', 12345))
        server_socket.listen(1)
        
        while True:
            conn, addr = server_socket.accept()
            try:
                while True:
                    data = {
                        "speed": self.speed,
                        "leftSignal": self.left_signal,
                        "rightSignal": self.right_signal,
                        "gear": self.current_gear
                    }
                    conn.send((json.dumps(data) + "\n").encode())
                    time.sleep(0.1) # Gửi dữ liệu mỗi 100ms
            except:
                conn.close()

if __name__ == "__main__":
    root = tk.Tk()
    app = CarSimulatorGUI(root)
    root.mainloop()
