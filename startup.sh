#!/bin/bash
source /opt/mycroft-core/.venv/bin/activate
/opt/mycroft-core/./start-mycroft.sh all

tail -f /var/log/mycroft/*.log
