from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    # Thay thế alert() bằng modal/message box tùy chỉnh để tuân thủ quy tắc môi trường.
    # Trong môi trường này, ta sẽ dùng thẻ <p id="result"> để hiển thị thông báo.

    return """
    <!doctype html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>LED Control</title>
      <script src="https://cdn.tailwindcss.com"></script>
      <style>
        /* Cấu hình Tailwind CSS */
        @layer base {
          body {
            font-family: 'Inter', sans-serif;
          }
        }
        
        /* CSS tuỳ chỉnh */
        body { background: #f0f0f0; }
        h1, h2 { color: #1f2937; } /* Xám đậm */

        /* Logo Styling */
        .logo-wrapper {
            display: flex;
            justify-content: center; /* Căn giữa ngang nội dung (bao gồm cả logo) */
            padding: 20px 0;
        }

        /* Hình ảnh logo - đảm bảo z-index chỉ có tác dụng khi position khác static */
        .logo-wrapper img {
            height: 180px;
            margin-bottom: 20px;
            display: block; /* Quan trọng để margin auto hoạt động */
            z-index: 1000;
        }
        
        /* Loại bỏ border/underline mặc định khi bọc ảnh trong thẻ <a> */
        .logo-wrapper a {
            text-decoration: none; 
            border: none;
        }

        /* Style cho các nút LED */
        .led-buttons button {
            width: 60px;
            height: 60px;
            margin: 5px;
            font-weight: bold;
            font-size: 16px;
            border-radius: 9999px; /* Tròn hoàn toàn */
            background-color: #e5e7eb; /* Xám nhạt */
            color: #1f2937;
            border: 2px solid #9ca3af;
            transition: all 0.2s ease-in-out;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .led-buttons button:hover {
            background-color: #d1d5db;
        }

        /* Khi LED “bật” */
        .led-on {
            background-color: #10b981; /* Xanh lá Tailwind */
            color: white;
            border-color: #059669;
            box-shadow: 0 0 10px #10b981, 0 0 20px #10b981; /* Hiệu ứng phát sáng */
        }
      </style>
    </head>
    <body class="p-4 sm:p-8">
        
        <!-- LOGO SECTION - Đã bọc thẻ <img> trong thẻ <a> để tạo liên kết -->
        <div class="logo-wrapper">
            <a href="https://hcmute.edu.vn/" target="_blank">
                <img src="/static/logo.png"
                     alt="Không thể tải logo">
            </a>
        </div>
        
        <h1 class="text-4xl font-extrabold text-center mb-6">FPGA LED Control</h1>

        <div class="max-w-4xl mx-auto">
            <div class="section bg-white p-6 mb-6 rounded-xl shadow-lg">
                <h2 class="text-2xl font-semibold mb-4">Mode 1: Enter number</h2>
                <div class="flex flex-col sm:flex-row items-start sm:items-center space-y-3 sm:space-y-0 sm:space-x-4">
                    <label for="num" class="font-medium">Number (0-255):</label>
                    <input type="number" id="num" placeholder="0-255" class="p-2 border border-gray-300 rounded-lg w-full sm:w-24">
                    
                    <label for="mode" class="font-medium">Display Mode:</label>
                    <select id="mode" class="p-2 border border-gray-300 rounded-lg">
                        <option value="dec">DEC</option>
                        <option value="hex">HEX</option>
                        <option value="bin">BIN</option>
                    </select>
                    <button onclick="sendNumber()" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition duration-150">Send Value</button>
                </div>
            </div>

            <div class="section bg-white p-6 mb-6 rounded-xl shadow-lg">
                <h2 class="text-2xl font-semibold mb-4">Mode 2: Control 8 LEDs</h2>
                <div class="led-buttons flex flex-wrap justify-center space-x-2">
                    <button id="led-btn-7" onclick="toggleLED(7)">LED7</button>
                    <button id="led-btn-6" onclick="toggleLED(6)">LED6</button>
                    <button id="led-btn-5" onclick="toggleLED(5)">LED5</button>
                    <button id="led-btn-4" onclick="toggleLED(4)">LED4</button>
                    <button id="led-btn-3" onclick="toggleLED(3)">LED3</button>
                    <button id="led-btn-2" onclick="toggleLED(2)">LED2</button>
                    <button id="led-btn-1" onclick="toggleLED(1)">LED1</button>
                    <button id="led-btn-0" onclick="toggleLED(0)">LED0</button>
                </div>
            </div>

            <!-- Kết quả và Thông báo lỗi -->
            <p id="result" class="text-center text-lg mt-4 p-3 rounded-lg"></p>
        </div>

      <script>
        let ledState = 0; // trạng thái 8 LED, bit 0 = LED0

        // Cập nhật trạng thái nút bấm trên giao diện
        function updateLEDButtons() {
            for (let i = 0; i < 8; i++) {
                const btn = document.getElementById(`led-btn-${i}`);
                if (btn) {
                    // Kiểm tra bit thứ i
                    if ((ledState >> i) & 1) {
                        btn.classList.add('led-on');
                    } else {
                        btn.classList.remove('led-on');
                    }
                }
            }
        }

        // Cập nhật kết quả với màu sắc phù hợp (success/error)
        function setResult(message, isError = false) {
            const resultElement = document.getElementById('result');
            resultElement.innerText = message;
            if (isError) {
                resultElement.className = 'text-center text-lg mt-4 p-3 rounded-lg bg-red-100 text-red-700 font-bold';
            } else {
                resultElement.className = 'text-center text-lg mt-4 p-3 rounded-lg bg-green-100 text-green-700 font-bold';
            }
        }

        function sendNumber() {
          let numInput = document.getElementById('num');
          let number = parseInt(numInput.value);
          let mode = document.getElementById('mode').value;

          if (isNaN(number) || number < 0 || number > 255) {
            setResult("Lỗi: Vui lòng nhập số từ 0 đến 255.", true);
            numInput.focus();
            return;
          }

          // Cập nhật trạng thái LED
          ledState = number;
          updateLEDButtons();

          // Chuyển đổi hiển thị
          let display;
          if (mode === 'dec') display = number;
          else if (mode === 'hex') display = '0x' + number.toString(16).toUpperCase().padStart(2, '0');
          else display = '0b' + number.toString(2).padStart(8,'0');

          fetch('/led', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({number: number})
          })
          .then(res => res.json())
          .then(data => {
            if (data.error) {
                setResult("Lỗi gửi dữ liệu: " + data.error, true);
            } else {
                setResult("Đã gửi: " + display + " | Phản hồi: " + (data.output || 'No output'));
            }
          })
          .catch(err => setResult("Lỗi kết nối: " + err, true));
        }

        function toggleLED(bit) {
          // đảo trạng thái bit
          ledState ^= (1 << bit);
          
          // Cập nhật trạng thái nút bấm ngay lập tức
          updateLEDButtons();

          fetch('/led', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({number: ledState})
          })
          .then(res => res.json())
          .then(data => {
            const binState = ledState.toString(2).padStart(8,'0');
            if (data.error) {
                setResult("Lỗi gửi dữ liệu: " + data.error, true);
            } else {
                setResult("Trạng thái LED (BIN): " + binState + " | Phản hồi: " + (data.output || 'No output'));
            }
          })
          .catch(err => setResult("Lỗi kết nối: " + err, true));
        }

        // Khởi tạo trạng thái nút bấm khi tải trang
        document.addEventListener('DOMContentLoaded', updateLEDButtons);
      </script>
    </body>
    </html>
    """

# Route xử lý POST
@app.route('/led', methods=['POST'])
def control_led():
    # Giả định đây là ứng dụng chạy trên môi trường có khả năng gọi lệnh shell
    number = request.json.get('number')
    if number is None:
        return jsonify({'error': 'No number provided'}), 400
    try:
        # Gọi chương trình user-space, ví dụ: `./main -n <number>`
        # Đây chỉ là mô phỏng, trên thực tế cần có file `./main`
        result = subprocess.run(['./main', '-n', str(number)],
                                capture_output=True, text=True, timeout=5)
        
        # Nếu chương trình chạy thành công (return code 0)
        if result.returncode == 0:
            return jsonify({'output': result.stdout.strip() or 'Success'}), 200
        else:
             # Nếu chương trình trả về lỗi
             error_msg = result.stderr.strip() or f"Program failed with exit code {result.returncode}"
             return jsonify({'output': f"Program Error: {error_msg}"}), 200 # Trả về 200 để hiển thị lỗi mà không làm fetch thất bại
             
    except FileNotFoundError:
        return jsonify({'output': "Simulator: Error - Executable './main' not found. Data processed: " + str(number)}), 200
    except subprocess.TimeoutExpired:
        return jsonify({'error': 'Execution timed out'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Lưu ý: host và port này chỉ dùng khi chạy ứng dụng Flask độc lập
    # Trong môi trường Canvas, cổng sẽ được tự động xử lý
    app.run(host='0.0.0.0', port=5001)