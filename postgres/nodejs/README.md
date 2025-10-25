
# nodejs postgres example 

## Quick Start

### 1. Install and update env

```bash
# Install dependencies
npm install

# Copy environment variables
cp .env.example .env

# Edit .env with your configuration
nano .env
```


### 2. Database Setup
**Option A: Quick setup (with sample data)**
```bash
npm run db:setup -- --seed
```

**Option B: Production setup (no sample data)**
```bash
npm run db:setup
```

