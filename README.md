# w3-dao-vote

Internal Web3 voting portal for allocating corporate innovation budgets across regional office initiatives.

![Dashboard Preview](docs/assets/dashboard-preview.png)

## Overview

`w3-dao-vote` provides an on-chain governance interface allowing department representatives to cast votes for quarterly internal projects. Smart contracts handle proposal creation, department whitelisting, and timelocked vote tallying.

## Features

- **Smart Contract Governance**: Timelocked voting contract written in Solidity with Foundry tests.
- **Wallet Connection**: Connect via wagmi 2.0 with automatic network switching.
- **Quorum & Tallying**: Real-time progress updates and quorum validation.
- **Whitelist Verification**: Restrict voting rights based on department address lists.

## Prerequisites

- Node.js v20+
- Foundry (`forge`)
- MetaMask or any WalletConnect-compatible wallet

## Local Development

### 1. Smart Contracts

```bash
# Install contract dependencies
forge install

# Run tests
forge test

# Deploy locally
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

### 2. Frontend Application

```bash
# Install dependencies
npm install

# Set up environment variables
cp .env.example .env.local

# Start dev server
npm run dev
```

## Deployment

Contract deployment uses Foundry scripts:

```bash
forge script script/Deploy.s.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY
```

Build static assets for production deployment on internal Nginx web servers:

```bash
npm run build
```
