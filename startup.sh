#!/bin/bash
source /opt/mycroft-core/.venv/bin/activate
/opt/mycroft-core/start-mycroft.sh all
python -m test.integrationtests.voigt_kampff.test_setup -c ~/.mycroft/test.yml
cd /opt/mycroft-core/test/integrationtests/voigt_kampff
echo "Mycroft-core:  $(git log --pretty=format:%h -n 1)"
behave
rm -rf ~/.mycroft/skills
