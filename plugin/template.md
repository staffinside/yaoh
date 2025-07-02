#

>

&#x20;&#x20;

## 🧹 Overview

School module is an Odoo plugin templaate that contains the basic files needed for an Odoo module (model, view, manifest, security).

## 📦 Features

- ✅ Fully compatible with Odoo 16
- ✅ Fully functional Students CRUD (Create, Read, Edit, Delete)


## 🚀 Installation

### 1. Prerequisites

- Python 3.8+
- Odoo 16.0+ installed and running

### 2. Clone this repository

```bash
git clone https://github.com/<your-org>/<odoo-module>.git
```

### 3. Add to your Odoo addons path

```bash
# Edit your Odoo configuration or launch command:
--addons-path=/path/to/your/custom/addons,/path/to/this/module
```

Or simply add the module folder to the modules folder in the files of Odoo

### 4. Restart Odoo and update the apps list

Restart your Odoo installation, if its by command line simply stop and re-run the start command like this
```
python odoo-bin -r odoo -w odoopassword --addons-path=addons,modules -d odoo -i base
```

### 5. Install the module

Search for  in the Apps menu and click **Install**.

## 🧪 Usage

To use this module:

- Go to topbar and go to `School Management` option


## 🧰 Development

### Code structure

```
school/
├── __manifest__.py         # Module metadata
├── __init__.py             # Python package init
├── models/                 # Business logic
├── views/                  # XML views, menus, actions
├── security/               # Access rights and record rules
├── controllers/            # HTTP controllers (optional)
└── data/                   # Preloaded data (optional)
```

## 📄 License

This module is licensed under the **LGPL-3.0 License**. See [LICENSE](LICENSE) for full details.

## 👥 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/awesome`)
3. Commit your changes (`git commit -am 'Add awesome feature'`)
4. Push to the branch (`git push origin feature/awesome`)
5. Open a Pull Request

## 😋 FAQ

**Q:** Is this module compatible with Odoo 17?

**A:** Currently tested on Odoo 16. Compatibility with 17 is under review.

**Q:** Can I install it via Odoo.sh?

**A:** Yes, include it in your Odoo.sh custom addons.

## 📬 Contact

For questions, support, or feedback:

- GitHub Issues: [Open an issue](https://github.com/<your-org>/<repo>/issues)
- Email: [support@example.com](mailto\:support@example.com)
- Website: [yourwebsite.com](https://yourwebsite.com)

---

**Made with ❤️ for the Odoo community**

