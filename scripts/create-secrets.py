#!/usr/bin/env python3
"""
Script pentru a crea secretele GitHub Actions în repository-ul xcited
Folosește GitHub API pentru a crea secretele
"""

import os
import sys
import subprocess
import json
from base64 import b64encode
from nacl import encoding, public

def get_github_token():
    """Obține token-ul GitHub din environment sau gh CLI"""
    # Încearcă din environment
    token = os.environ.get('GITHUB_TOKEN')
    if token:
        return token
    
    # Încearcă din gh CLI
    try:
        result = subprocess.run(
            ['gh', 'auth', 'token'],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None

def get_repo_public_key(owner, repo, token):
    """Obține cheia publică pentru criptarea secretelor"""
    import requests
    
    url = f"https://api.github.com/repos/{owner}/{repo}/actions/secrets/public-key"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()

def encrypt_secret(public_key: str, secret_value: str) -> str:
    """Criptează un secret folosind cheia publică"""
    public_key_bytes = bytes.fromhex(public_key)
    public_key_obj = public.PublicKey(public_key_bytes)
    sealed_box = public.SealedBox(public_key_obj)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
    return b64encode(encrypted).decode("utf-8")

def create_secret(owner, repo, secret_name, secret_value, token):
    """Creează un secret în repository"""
    import requests
    
    # Obține cheia publică
    public_key_data = get_repo_public_key(owner, repo, token)
    key_id = public_key_data["key_id"]
    public_key = public_key_data["key"]
    
    # Criptează secretul
    encrypted_value = encrypt_secret(public_key, secret_value)
    
    # Creează secretul
    url = f"https://api.github.com/repos/{owner}/{repo}/actions/secrets/{secret_name}"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    data = {
        "encrypted_value": encrypted_value,
        "key_id": key_id
    }
    
    response = requests.put(url, headers=headers, json=data)
    response.raise_for_status()
    return True

def main():
    owner = "Iulianc123"
    repo_xcited = "xcited"
    repo_1dream = "1DREAM"
    
    # Obține token-ul
    token = get_github_token()
    if not token:
        print("❌ Nu am găsit token GitHub!")
        print("   Setează GITHUB_TOKEN sau autentifică-te cu: gh auth login")
        sys.exit(1)
    
    # Lista de secrete de copiat
    secrets = ["CWP_HOST", "CWP_USER", "CWP_SSH_KEY", "CWP_PORT"]
    
    print(f"🔐 Creare secrete în {owner}/{repo_xcited}")
    print("")
    print("⚠️  ATENȚIE: Nu pot citi valorile secretelor din 1dream (sunt criptate)")
    print("   Trebuie să introduci manual valorile pentru fiecare secret")
    print("")
    
    # Pentru fiecare secret, cere valoarea și o creează
    for secret_name in secrets:
        print(f"📝 Secret: {secret_name}")
        print(f"   Valoarea trebuie să fie aceeași ca în {repo_1dream}")
        secret_value = input(f"   Introdu valoarea pentru {secret_name}: ").strip()
        
        if not secret_value:
            print(f"   ⚠️  Sărit {secret_name} (valoare goală)")
            continue
        
        try:
            create_secret(owner, repo_xcited, secret_name, secret_value, token)
            print(f"   ✅ Secret {secret_name} creat cu succes!")
        except Exception as e:
            print(f"   ❌ Eroare la crearea secretului {secret_name}: {e}")
        
        print("")
    
    print("✅ Finalizat!")

if __name__ == "__main__":
    try:
        import requests
        from nacl import encoding, public
    except ImportError:
        print("❌ Lipsește dependența!")
        print("   Instalează: pip install requests pynacl")
        sys.exit(1)
    
    main()

