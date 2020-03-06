
import subprocess
result = subprocess.run(['swipl', 'causality', '/Users/fl/git/causality/examples/ex_butfor.pl', 'a', 'p', 'but_for'], stdout=subprocess.PIPE)
print(result.args)
print(result.stdout)

import json
p = json.loads(result.stdout)

print(p)