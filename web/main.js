import { WagmiCore, Chains, Web3modal, Connectors } from "https://cdn.jsdelivr.net/npm/cdn-wagmi@3.0.0/dist/cdn-wagmi.js"

const { createWeb3Modal, defaultWagmiConfig } = Web3modal
const { mainnet, sepolia } = Chains
const { reconnect } = WagmiCore

const projectId = 'cad4956f31a5e40a00b62865b030c6f8'

const metadata = {
  name: 'Web3Modal',
  description: 'Web3Modal Example',
  url: 'https://web3modal.com', // url must match your domain & subdomain
  icons: ['https://avatars.githubusercontent.com/u/37784886']
}

const config = defaultWagmiConfig({
  chains: [mainnet, sepolia],
  projectId,
  metadata,
})
reconnect(config)

const modal = createWeb3Modal({
  wagmiConfig: config,
  projectId,
  enableAnalytics: true, // Optional - defaults to your Cloud configuration
  enableOnramp: true // Optional - false as default
})

// Expose functions to the global `window` object
window.openModal = function() {
  return modal.open()
}

window.closeModal = function() {
  return modal.close()
}