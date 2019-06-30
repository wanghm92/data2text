import io, argparse, re, json
from tqdm import tqdm
DELIM = u"￨"

entity_types = dict.fromkeys(['PLAYER_NAME', 'TEAM-CITY', 'TEAM-NAME', 'TEAM-ARENA', 'TEAM-ALIAS'], True)
mwe_file = "mwes.json"

parser = argparse.ArgumentParser(description='clean')
parser.add_argument('--input', type=str, required=True)
args = parser.parse_args()
with io.open(args.input, 'r', encoding='utf-8') as fin, \
        io.open(mwe_file, 'r', encoding='utf-8') as fin_mwe, \
        io.open("{}.mwe".format(args.input), 'w+', encoding='utf-8') as fout:

    mwes = json.load(fin_mwe)
    inputs = fin.read().strip().split('\n')

    for summary in tqdm(inputs):

        for k, _ in mwes.items():
            phrase = ' '.join(k.split('_'))
            try:
                summary = re.sub(phrase, k, summary)
            except:
                pass
        fout.write("{}\n".format(summary))