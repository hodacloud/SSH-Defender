<!DOCTYPE html>
<html lang="fa-IR">
<head>
    <meta charset="UTF-8">
    <title>SSH Monitor & Auto-Block Tool - HodaCloud</title>
    <style>
        body {
            font-family: Tahoma, Arial, sans-serif;
            line-height: 1.6;
            margin: 40px;
            background-color: #1e1e1e;
            color: #f8f8f2;
        }

        .lang-section {
            border: 2px solid #44475a;
            padding: 20px;
            margin-bottom: 40px;
            border-radius: 10px;
            background-color: #282a36;
        }

        /* Right-align Persian text within the section */
        .lang-section[dir="rtl"] {
            direction: rtl;
            text-align: right;
        }

        h1, h2 {
            color: #50fa7b;
        }

        code {
            background: #44475a;
            color: #f8f8f2;
            padding: 2px 5px;
            border-radius: 3px;
            border: 1px solid #6272a4;
            direction: ltr; /* Force left-to-right for code */
            text-align: left;
        }

        pre {
            background: #44475a;
            color: #f8f8f2;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            border: 1px solid #6272a4;
            direction: ltr; /* Force left-to-right for pre */
            text-align: left;
        }

        .note {
            background: #6272a4;
            color: #f8f8f2;
            padding: 15px;
            border-right: 4px solid #ffb86c;
        }

        /* Right-align text within the note for Persian section */
        .lang-section[dir="rtl"] .note {
            direction: rtl;
            text-align: right;
            border-right: none; /* Remove right border for RTL */
            border-left: 4px solid #ffb86c; /* Add left border for RTL */
        }

        .note strong {
            direction: rtl; /* Ensure strong elements are also right-aligned */
        }

        a {
            color: #8be9fd;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        /* Center the footer elements */
        div[style*="text-align: center"] {
            direction: ltr; /* Ensure center-aligned content is LTR */
            text-align: center;
        }

        div[style*="text-align: center"] p {
            direction: ltr; /* Ensure paragraphs within the centered div are LTR */
        }

        /* Style the troubleshooting section specifically */
        .lang-section[dir="rtl"] h2:nth-child(7) ~ pre { /* Target pre elements after the "عیب‌یابی" heading */
            direction: ltr;
            text-align: left;
        }
    </style>
</head>
<body>

<div class="lang-section" dir="rtl">
    <h1>ابزار مانیتورینگ و بلاک خودکار SSH</h1>
    <h2>📜 امکانات اصلی</h2>
    <ul>
        <li>نمایش لحظه‌ای حملات SSH</li>
        <li>سیستم بلاک خودکار IP با iptables</li>
        <li>آنالیز لاگ‌های ورود ناموفق</li>
        <li>لیست 10 IP مهاجم برتر</li>
        <li>تنظیم زمان‌بندی خودکار (روزانه/هفتگی/ماهانه)</li>
    </ul>

    <h2>🛠️ نصب و راه‌اندازی</h2>
    <pre><code>```wget https://raw.githubusercontent.com/hodacloud/SSH-Defender/refs/heads/main/SSH-Defender.sh -O /root/ssh_monitor.sh && chmod +x /root/ssh_monitor.sh && sudo /root/ssh_monitor.sh```</code></pre>

    <h2>⚙️ راهنمای استفاده</h2>
    <div class="note">
        <strong>منوی اصلی:</strong><br>
        1. نمایش تاریخچه حملات<br>
        2. ذخیره IPهای ناموفق<br>
        3. بلاک IPها<br>
        4. نمایش ترافیک مسدود شده<br>
        5. تنظیمات خودکار<br>
        6. خروج
    </div>

    <h2>🔧 عیب‌یابی</h2>
    <pre><code># خطای دسترسی
```sudo chmod +x /root/ssh_monitor.sh```</code></pre>
    <pre><code># مشکلات iptables
```apt install iptables-persistent```</code></pre>
</div>

<div class="lang-section">
    <h1>SSH Monitor & Auto-Block Tool</h1>
    <h2>📜 Core Features</h2>
    <ul>
        <li>Real-time SSH attack monitoring</li>
        <li>Automatic IP blocking with iptables</li>
        <li>Failed login analysis</li>
        <li>Top 10 attacking IPs list</li>
        <li>Automated scheduling (daily/weekly/monthly)</li>
    </ul>

    <h2>🛠️ Installation</h2>
    <pre><code>```wget https://raw.githubusercontent.com/hodacloud/SSH-Defender/refs/heads/main/SSH-Defender.sh -O /root/ssh_monitor.sh && chmod +x /root/ssh_monitor.sh && sudo /root/ssh_monitor.sh```</code></pre>

    <h2>⚙️ Usage Guide</h2>
    <div class="note">
        <strong>Main Menu:</strong><br>
        1. Show attack history<br>
        2. Save failed IPs<br>
        3. Block IPs<br>
        4. View blocked traffic<br>
        5. Automation setup<br>
        6. Exit
    </div>

    <h2>🔧 Troubleshooting</h2>
    <pre><code># Permission issues
```sudo chmod +x /root/ssh_monitor.sh```</code></pre>
    <pre><code># IPTables problems
```apt install iptables-persistent```</code></pre>
</div>

<div style="text-align: center; margin-top: 40px;">
    <p>Developed by <a href="https://hodacloud.com" target="_blank">HodaCloud</a></p>
    <p>📧 Support: <a href="mailto:info@hodacloud.com">info@hodacloud.com</a></p>
</div>

</body>
</html>
