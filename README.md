# SSH Monitor & Auto-Block Tool - HodaCloud

📜 امکانات اصلی
نمایش لحظه‌ای حملات SSH

سیستم بلاک خودکار IP با iptables

آنالیز لاگ‌های ورود ناموفق

لیست 10 IP مهاجم برتر

تنظیم زمان‌بندی خودکار (روزانه/هفتگی/ماهانه)

🛠️ نصب و راه‌اندازی

```
wget https://raw.githubusercontent.com/hodacloud/SSH-Defender/refs/heads/main/SSH-Defender.sh -O /root/ssh_monitor.sh && chmod +x /root/ssh_monitor.sh && sudo /root/ssh_monitor.sh
```

⚙️ راهنمای استفاده
منوی اصلی:

نمایش تاریخچه حملات

ذخیره IPهای ناموفق

بلاک IPها

نمایش ترافیک مسدود شده

تنظیمات خودکار

خروج

🔧 عیب‌یابی
خطای دسترسی:
```
sudo chmod +x /root/ssh_monitor.sh
```

مشکلات iptables:

```
apt install iptables-persistent
```

## 🌐 English Version

### 📜 Core Features
- Real-time SSH attack monitoring
- Automatic IP blocking with iptables
- Failed login analysis
- Top 10 attacking IPs list
- Automated scheduling (daily/weekly/monthly)

### 🛠️ Installation

```
wget https://raw.githubusercontent.com/hodacloud/SSH-Defender/refs/heads/main/SSH-Defender.sh -O /root/ssh_monitor.sh && chmod +x /root/ssh_monitor.sh && sudo /root/ssh_monitor.sh
```


⚙️ Usage Guide
Main Menu:

Show attack history

Save failed IPs

Block IPs

View blocked traffic

Automation setup

Exit

🔧 Troubleshooting
Permission issues:

```
sudo chmod +x /root/ssh_monitor.sh
```

IPTables problems:

```
apt install iptables-persistent
```

<div align="center"> <p>Developed by <a href="https://hodacloud.com" target="_blank">HodaCloud</a></p> <p>📧 Support: <a href="mailto:info@hodacloud.com">info@hodacloud.com</a></p> </div>
