# Password Breach Checker

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-4.0+-1f425f.svg?style=flat&logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-012456.svg?style=flat&logo=powershell)](https://docs.microsoft.com/en-us/powershell/)

A collection of secure scripts to check if your passwords have been compromised in data breaches using the [Have I Been Pwned](https://haveibeenpwned.com/) password database.

## Features

- ✅ **Privacy-First**: Uses k-anonymity - only sends the first 5 characters of your password's hash
- 🔒 **Secure Input**: No password echoing to the terminal when prompted
- 🌐 **Cross-Platform**: Bash script for Unix/Linux/macOS, PowerShell for Windows/Cross-platform
- 📊 **Detailed Results**: Shows how many times a compromised password has been seen
- 🎨 **Color-Coded Output**: Visual feedback for safe/compromised passwords

## How It Works

1. **Hashing**: Your password is hashed using SHA-1 locally on your machine
2. **K-Anonymity**: Only the first 5 characters of the hash are sent to the API
3. **Remote Lookup**: The API returns all known compromised hashes with that prefix
4. **Local Comparison**: Your script checks if your full hash appears in the returned list

This ensures your actual password never leaves your machine!

## Installation

1. Clone this repository:
```bash
git clone https://github.com/YoannCalamai/PasswordBreachChecker.git
cd passwordbreachchecker
```

2. Make the scripts executable:
```bash
# For Bash script
chmod +x pwned-password-checker.sh

# For PowerShell on Unix-like systems
chmod +x pwned-password-checker.ps1
```

## Usage

### Bash Script (Linux/macOS/WSL)

```bash
# Interactive mode (secure prompt)
./pwned-password-checker.sh

# With password as argument (not recommended for sensitive passwords)
./pwned-password-checker.sh "mypassword"
```

### PowerShell Script (Windows/Cross-platform)

```powershell
# Interactive mode (secure prompt)
.\pwned-password-checker.ps1

# With password as argument (not recommended for sensitive passwords)
.\pwned-password-checker.ps1 "mypassword"

# Cross-platform PowerShell Core
pwsh .\pwned-password-checker.ps1
```

## Exit Codes

Both scripts use consistent exit codes for automation:

- `0`: Password not found in breaches (safe)
- `1`: Error (invalid usage, empty password, network error)
- `2`: Password found in breaches (compromised)

## Examples

### Safe Password
```
$ ./pwned-password-checker.sh
Enter password to check: 
Checking password against Have I Been Pwned database...
✅ Good news! This password has not been found in any known data breaches.
   However, you should still use a strong, unique password.
```

### Compromised Password
```
$ ./pwned-password-checker.sh
Enter password to check: 
Checking password against Have I Been Pwned database...
⚠️  WARNING: This password has been found in data breaches!
   It has appeared 3456 times in compromised password lists.
   You should change this password immediately.
```

## Automation

You can use these scripts in automated workflows:

```bash
#!/bin/bash
./pwned-password-checker.sh "$USER_PASSWORD"
if [ $? -eq 2 ]; then
    echo "Password is compromised! Forcing password change..."
    # Add your password change logic here
fi
```

## Requirements

### Bash Script
- Bash 4.0 or higher
- `curl` command
- `sha1sum` utility
- Standard Unix tools (`cut`, `tr`, `grep`)

### PowerShell Script
- PowerShell 5.1 or PowerShell Core 6.0+
- .NET Framework or .NET Core
- Internet access for API calls

## Security Considerations

1. **Never hardcode passwords** in scripts or command line arguments
2. **Use interactive mode** when possible to avoid password exposure in process lists
3. **Clear terminal history** after use if you used command line arguments
4. **Run on trusted systems** only - avoid public or shared computers
5. **Verify HTTPS connection** to ensure secure communication with the API

## API Information

This tool uses the [Have I Been Pwned Pwned Passwords API](https://haveibeenpwned.com/API/v3#PwnedPasswords):
- **Endpoint**: `https://api.pwnedpasswords.com/range/{first5HashChars}`
- **Method**: GET
- **Response**: Text list of hash suffixes and occurrence counts
- **Rate Limiting**: No authentication required, but please be respectful with usage

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is provided for educational and security purposes. Always use strong, unique passwords and enable two-factor authentication where possible. The authors are not responsible for any misuse of this tool.

## Credits

- [Have I Been Pwned](https://haveibeenpwned.com/) for providing the awesome service
- Troy Hunt for creating and maintaining the HIBP database
- The security community for promoting better password practices

## Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/your-username/password-breach-checker/issues) page
2. Create a new issue if your problem isn't already documented
3. Provide detailed information about your system and the error you're experiencing

---

**Stay safe and keep your passwords secure! 🔐**
