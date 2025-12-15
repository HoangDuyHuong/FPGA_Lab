const express = require("express");
const { exec, execSync } = require("child_process");
const app = express();

app.use(express.json());
app.use(express.static("public"));

// API xử lý phép tính
app.post("/calc", (req, res) => {
    let { opcode, a, b } = req.body;
    const cmd = `./main -o ${opcode} -a "${a}" -b "${b || 0}"`;

    exec(cmd, (err, stdout, stderr) => {
        if (err) return res.json({ error: stderr });
        res.json({ result: stdout.trim() });
    });
});

// Lấy IP WSL (internal)
function getWSLIP() {
    try {
        const raw = execSync("ip -4 addr show eth0").toString();
        const match = raw.match(/inet (\d+\.\d+\.\d+\.\d+)/);
        return match ? match[1] : "UNKNOWN";
    } catch {
        return "UNKNOWN";
    }
}

// Lấy IP Windows từ ipconfig.exe (LAN truy cập được)
function getWindowsIP() {
    try {
        const raw = execSync("ipconfig.exe").toString();
        const matches = raw.match(/IPv4 Address[^\d]+(\d+\.\d+\.\d+\.\d+)/g);

        if (!matches) return "UNKNOWN";

        for (let m of matches) {
            const ip = m.match(/(\d+\.\d+\.\d+\.\d+)/)[1];

            // Loại IP WSL + loopback + VPN
            if (
                !ip.startsWith("172.") &&
                !ip.startsWith("127.") &&
                !ip.startsWith("10.")     // loại VPN/campus 10.x.x.x
            ) {
                return ip; // Đây là LAN IP thật
            }
        }

        return "UNKNOWN";
    } catch {
        return "UNKNOWN";
    }
}

const PORT = 8080;

app.listen(PORT, "0.0.0.0", () => {
    const wsl = getWSLIP();
    const win = getWindowsIP();

    console.log("=====================================");
    console.log(" Webserver Started Successfully ");
    console.log("=====================================");
    console.log(` Local:       http://localhost:${PORT}`);
    console.log(` WSL IP:      http://${wsl}:${PORT}   (internal only)`);
    console.log(` Windows IP:  http://${win}:${PORT}   (LAN access)`);
    console.log("=====================================");
});
