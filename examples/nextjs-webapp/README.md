# Next.js Web App Example

A full-stack Next.js application demonstrating OpenRun deployment with modern React features.

## Features

- ⚡ Next.js 14 with App Router
- ⚛️ React 18 with Client Components
- 🎨 Tailwind CSS for styling
- 📱 Fully responsive design
- 🔢 Interactive counter demo
- ✅ Task list with state management
- 🚀 Production-ready build

## Local Development

```bash
# Install dependencies
npm install

# Run development server
npm run dev
```

Open http://localhost:3000 in your browser.

## Deploy with OpenRun

### Method 1: Using Claude Code Plugin

```
cd nextjs-webapp
claude code
> Deploy this Next.js app at /webapp
```

Claude will:
1. Detect it's a Next.js application
2. Generate OpenRun configuration
3. Build and deploy to your server

### Method 2: Manual Deployment

```bash
# Apply configuration
openrun apply --approve deploy.star
```

### Method 3: Quick Deploy

```bash
openrun app create --approve --spec node-nextjs . /webapp
```

## Build Configuration

The `next.config.js` uses:
- `output: 'standalone'` - Creates optimized Docker-friendly build
- `reactStrictMode: true` - Enables React strict mode

This configuration ensures efficient OpenRun deployments with minimal container size.

## Configuration

### Container Resources

Default settings in `deploy.star`:
- **Memory**: 1GB (Next.js needs more than typical Node apps)
- **CPU**: 1 core
- **Port**: 3000

Adjust for your needs:
```bash
openrun apply --approve --param memory=2g deploy.star
```

### Environment Variables

- `NODE_ENV=production` - Production optimizations
- Add custom vars in `deploy.star`:
  ```python
  env={
      "NODE_ENV": "production",
      "API_URL": "https://api.example.com",
      "ANALYTICS_ID": "your-id"
  }
  ```

## Project Structure

```
nextjs-webapp/
├── app/
│   ├── page.tsx          # Main page component
│   ├── layout.tsx        # Root layout
│   └── globals.css       # Global styles
├── public/               # Static assets
├── package.json          # Dependencies
├── next.config.js        # Next.js configuration
├── tailwind.config.ts    # Tailwind configuration
├── tsconfig.json         # TypeScript configuration
└── deploy.star           # OpenRun deployment config
```

## Production Considerations

### Performance
- Enable caching for static assets
- Use Next.js Image optimization
- Implement code splitting

### Monitoring
Add error tracking:
```bash
npm install @sentry/nextjs
```

### Database
Add PostgreSQL or other database:
```python
# deploy.star
app(
    # ... other config
    env={
        "DATABASE_URL": "postgresql://..."
    }
)
```

## Tailwind CSS

Styles are utility-first with Tailwind. Key features:
- Responsive breakpoints
- Custom color schemes
- Hover and focus states
- Flexbox and Grid layouts

Customize in `tailwind.config.ts`.

## TypeScript

Full TypeScript support with:
- Type safety for components
- IntelliSense in IDEs
- Compile-time error checking

## Access After Deployment

- Local: `http://localhost/webapp`
- Production: `https://yourdomain.com/webapp`

## Tech Stack

- **Next.js 14** - React framework with App Router
- **React 18** - UI library
- **TypeScript** - Type safety
- **Tailwind CSS** - Utility-first CSS
- **OpenRun** - Deployment platform
