import urllib.request
import os

def download_font(url, filename):
    print(f"Downloading {filename}...")
    urllib.request.urlretrieve(url, f"assets/fonts/{filename}")
    print(f"Downloaded {filename}")

# Font URLs from Google Fonts
fonts = {
    "Poppins-Regular.ttf": "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf",
    "Poppins-Medium.ttf": "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Medium.ttf",
    "Poppins-Bold.ttf": "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf"
}

# Create assets/fonts directory if it doesn't exist
os.makedirs("assets/fonts", exist_ok=True)

# Download each font
for filename, url in fonts.items():
    download_font(url, filename)
