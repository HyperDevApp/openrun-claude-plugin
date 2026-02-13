# Static Site Example

A modern static website demonstrating OpenRun deployment with pure HTML, CSS, and JavaScript.

## Features

- 🎨 Modern, responsive design
- ⚡ Lightning-fast performance
- 📱 Mobile-friendly
- 🎯 Interactive demo
- 🚀 Zero runtime dependencies
- 💡 Easy to customize

## Local Development

Just open `index.html` in your browser!

Or use a local server:
```bash
# Python
python -m http.server 8000

# Node.js
npx http-server

# PHP
php -S localhost:8000
```

## Deploy with OpenRun

### Method 1: Using Claude Code Plugin

```
cd static-site
claude code
> Deploy this static site at /static
```

### Method 2: Manual Deployment

```bash
openrun apply --approve deploy.star
```

### Method 3: Quick Deploy

```bash
openrun app create --approve --spec static . /static
```

## Configuration

Minimal resource requirements:
- **CPU**: 0.25 cores (very light!)
- **Memory**: 128MB (minimal!)
- **Port**: 80 (standard HTTP)

## File Structure

```
static-site/
├── index.html      # Main HTML file
├── styles.css      # Stylesheet
├── script.js       # JavaScript
└── deploy.star     # OpenRun config
```

## Customization

### Change Colors

Edit the gradient in `styles.css`:
```css
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

### Add Pages

Create new HTML files and link them:
```html
<a href="about.html">About</a>
```

### Add Images

Place images in an `images/` directory:
```html
<img src="images/logo.png" alt="Logo">
```

## Use Cases

Perfect for:
- 📚 **Documentation** - API docs, user guides
- 🎨 **Portfolios** - Showcase projects
- 🏠 **Landing Pages** - Product launches
- 📊 **Dashboards** - Status pages, metrics
- 📄 **Forms** - Contact pages, surveys

## Advantages of Static Sites

1. **Speed**: No server-side processing
2. **Security**: No backend to attack
3. **Cost**: Minimal resources needed
4. **Reliability**: Simple = fewer failures
5. **SEO**: Easy to optimize
6. **CDN-Friendly**: Can be cached everywhere

## Adding Dynamic Features

While static, you can add:

**APIs**: Fetch data from external services
```javascript
fetch('https://api.example.com/data')
    .then(response => response.json())
    .then(data => console.log(data));
```

**Forms**: Use services like Formspree
```html
<form action="https://formspree.io/your-email">
```

**Analytics**: Add Google Analytics
```html
<script async src="https://www.googletagmanager.com/gtag/js"></script>
```

**Comments**: Use Disqus or similar

## Production Ready

This example is production-ready for:
- Internal documentation
- Team landing pages
- Project showcases
- Simple web apps

## Tech Stack

- **HTML5** - Semantic markup
- **CSS3** - Modern styling with Grid/Flexbox
- **JavaScript (ES6+)** - Interactive features
- **OpenRun** - Deployment platform

## Access After Deployment

- Local: `http://localhost/static`
- Production: `https://yourdomain.com/static`
