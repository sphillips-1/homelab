mkdir -p /opt/homelab/services/touchscreen-power

cp services/touchscreen-power/* \
   /opt/homelab/services/touchscreen-power/

cp services/touchscreen-power/touchscreen-power.service \
   /etc/systemd/system/

systemctl daemon-reload
systemctl enable touchscreen-power
systemctl restart touchscreen-power