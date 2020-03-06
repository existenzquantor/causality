
import subprocess
result = subprocess.run(['swipl', 'causality', '/Users/fl/git/causality/examples/suzybilly1.pl', 'throwsuzy:throwbilly', 'shattered', 'but_for'], stdout=subprocess.PIPE)
print(result.args)
print(result.stdout)