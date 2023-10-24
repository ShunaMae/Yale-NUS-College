msg = "lbh zhfg unir fbzr jvyq vzntvangvba. gvzr geniry? frevbhfyl !!! ogj, yrgf unir n oernx abj. ohg ubyq ba, bar zber guvat. jr ner univat ubzr jbex. tb naq purpx vg bhg. cf: gur nffvtazrag vf rapelcgrq jvgu ebg13."
alphabet = []
rot13 = []
for i in range(97, 97+26):
    alphabet.append(chr(i))
rot13 = alphabet[13:] + alphabet[:13]
for c in msg:
    if c in alphabet:
        print(alphabet[rot13.index(c)], end="")
    else:
        print(c,end="")