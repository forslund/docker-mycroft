#!/bin/bash
source /opt/mycroft-core/.venv/bin/activate
/opt/mycroft-core/start-mycroft.sh all
python -m test.integrationtests.voigt_kampff.test_setup -c ~/.mycroft/test.yml
cd /opt/mycroft-core/test/integrationtests/voigt_kampff
behave
