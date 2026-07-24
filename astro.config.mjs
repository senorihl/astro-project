// @ts-check
import { defineConfig } from 'astro/config';

import node from '@astrojs/node';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
    
  // Uncomment if dynamic site
  // adapter: node({
  //   mode: 'standalone',
  // }),
    
  server: {
      port: parseInt(process.env.PORT || '4321') ,
      host: true,
      allowedHosts: true
  },

  vite: {
    plugins: [tailwindcss()],
  },
});