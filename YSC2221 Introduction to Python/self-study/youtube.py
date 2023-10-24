from __future__ import unicode_literals
import youtube_dl
ydl_opts = {}
with youtube_dl.YoutubeDL(ydl_opts) as ydl:
    ydl.download(['https://youtu.be/1FliVTcX8bQ?list=RDCLAK5uy_kvhjcPWzH7xZL-WnqGbiA_euQGy5_cbHI'])


import youtube_dl

ydl_opts = {
    'format': 'bestaudio/best',
    'outtmpl':  "sample_music" + '.%(ext)s',
    'postprocessors': [
        {'key': 'FFmpegExtractAudio',
        'preferredcodec': 'mp3',
        'preferredquality': '192'},
        {'key': 'FFmpegMetadata'},
    ],
}

ydl = youtube_dl.YoutubeDL(ydl_opts)
info_dict = ydl.extract_info("https://www.youtube.com/watch?v=sr--GVIoluU", download=True)