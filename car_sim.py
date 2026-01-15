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
        self.root.geometry("300x300")

        self.speed = 0
        self.left_signal = False
        self.right_signal = False
        self.headlights_on = False
        self.capacity = 100.0
        self.is_charging = False

        # --- UI Components ---
        self.btn_add = tk.Button(root, text="+10 km/h", command=self.increase_speed)
        self.btn_add.pack(pady=5)

        self.btn_sub = tk.Button(root, text="-10 km/h", command=self.decrease_speed)
        self.btn_sub.pack(pady=5)

        # Nút bấm Xi-nhan
        self.btn_left = tk.Button(root, text="Left Signal", command=self.toggle_left)
        self.btn_left.pack(pady=5)
        
        self.btn_right = tk.Button(root, text="Right Signal", command=self.toggle_right)
        self.btn_right.pack(pady=5)

        self.btn_headlights = tk.Button(root, text="Headlights", command=self.toggle_headlights)
        self.btn_headlights.pack(pady=5)

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

        # Start thread (Socket)
        self.server_thread = threading.Thread(target=self.start_server, daemon=True)
        self.server_thread.start()

        # Start capacity drain timer
        self.drain_capacity()

        # --- Charge Button ---
        self.btn_charge = tk.Button(root, text="Charge Battery", command=self.start_charge)
        self.btn_charge.pack(pady=5)

    def drain_capacity(self):
        if self.capacity > 0 and self.current_gear == "D" and self.speed > 0:
            self.capacity = max(0, self.capacity - 1)
        self.root.after(500, self.drain_capacity)

    def increase_speed(self):
        if self.current_gear in ["D", "R"]:
            self.speed = min(self.speed + 10, 200)

    def decrease_speed(self):
        if self.current_gear in ["D", "R"]:
            self.speed = max(self.speed - 10, 0)

    def toggle_left(self):
        self.left_signal = not self.left_signal
        if self.left_signal:
            self.right_signal = False
            self.btn_right.config(bg="systemButtonFace")
        self.btn_left.config(bg="green" if self.left_signal else "systemButtonFace")

    def toggle_right(self):
        self.right_signal = not self.right_signal
        if self.right_signal:
            self.left_signal = False
            self.btn_left.config(bg="systemButtonFace")
        self.btn_right.config(bg="green" if self.right_signal else "systemButtonFace")

    def toggle_headlights(self):
        self.headlights_on = not self.headlights_on
        self.btn_headlights.config(bg="yellow" if self.headlights_on else "systemButtonFace")

    def select_gear(self, gear):
        self.current_gear = gear
        # Reset speed to 0 for N, R and P gears
        if gear in ["N", "P", "R"]:
            self.speed = 0
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
                        "gear": self.current_gear,
                        "headlightsOn": self.headlights_on,
                        "capacity": self.capacity,
                        "isCharging": self.is_charging
                    }
                    conn.send((json.dumps(data) + "\n").encode())
                    time.sleep(0.1)
            except:
                conn.close()

    def charge_battery(self):
        self.is_charging = True
        while self.capacity < 100:
            if self.current_gear == "P":
                self.capacity = min(100, self.capacity + 10)
            time.sleep(1)
        self.is_charging = False

    def start_charge(self):
        threading.Thread(target=self.charge_battery, daemon=True).start()

if __name__ == "__main__":
    root = tk.Tk()
    app = CarSimulatorGUI(root)
    root.mainloop()
