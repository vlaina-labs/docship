// Device mode: desktop or mobile
function setMode(mode) {
  document.querySelectorAll('.iframe-wrap').forEach(w => {
    w.className = 'iframe-wrap ' + mode;
  });
  document.querySelectorAll('.device-btn').forEach(b => {
    b.classList.toggle('active', b.dataset.mode === mode);
  });
  localStorage.setItem('deviceMode', mode);
}

// Theme mode: light or dark
function toggleTheme() {
  const isDark = document.body.classList.toggle('dark');
  updateThemeIcon(isDark);
  localStorage.setItem('theme', isDark ? 'dark' : 'light');
  
  // Update all iframes theme
  updateIframesTheme(isDark);
}

// Update theme button icon
function updateThemeIcon(isDark) {
  const btn = document.querySelector('.theme-btn');
  if (isDark) {
    // Moon icon
    btn.innerHTML = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
    </svg>`;
  } else {
    // Sun icon
    btn.innerHTML = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="5"></circle>
      <line x1="12" y1="1" x2="12" y2="3"></line>
      <line x1="12" y1="21" x2="12" y2="23"></line>
      <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
      <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
      <line x1="1" y1="12" x2="3" y2="12"></line>
      <line x1="21" y1="12" x2="23" y2="12"></line>
      <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
      <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
    </svg>`;
  }
}

// Update iframes theme by manipulating their content
function updateIframesTheme(isDark) {
  const theme = isDark ? 'dark' : 'light';
  
  document.querySelectorAll('.iframe-wrap iframe').forEach(iframe => {
    try {
      const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
      const iframeWin = iframe.contentWindow;
      
      // === Common attributes ===
      // HTML element attributes
      iframeDoc.documentElement.setAttribute('data-theme', theme);
      iframeDoc.documentElement.setAttribute('data-color-mode', theme);
      iframeDoc.documentElement.setAttribute('class', 
        iframeDoc.documentElement.className.replace(/\b(light|dark)\b/g, '') + ' ' + theme);
      
      // Body attributes
      iframeDoc.body.setAttribute('data-theme', theme);
      iframeDoc.body.className = iframeDoc.body.className.replace(/\b(light|dark)\b/g, '').trim() + ' ' + theme;
      
      // === Framework-specific localStorage keys ===
      iframeWin.localStorage.setItem('theme', theme);
      iframeWin.localStorage.setItem('color-theme', theme);
      
      // VitePress
      iframeWin.localStorage.setItem('vitepress-theme-appearance', theme);
      
      // Docusaurus
      iframeWin.localStorage.setItem('docusaurus.theme.mode', theme);
      
      // Nextra
      iframeWin.localStorage.setItem('nextra-theme', theme);
      
      // Starlight
      iframeWin.localStorage.setItem('starlight-theme', theme);
      
      // Docus (Nuxt)
      iframeWin.localStorage.setItem('nuxt-color-mode', theme);
      
      // Rspress
      iframeWin.localStorage.setItem('rspress-theme', theme);
      
      // Fumadocs
      iframeWin.localStorage.setItem('fd-theme', theme);
      
      // === Docute ===
      // Docute uses Vue store and specific localStorage
      iframeWin.localStorage.setItem('docute:dark', isDark ? 'true' : 'false');
      // Try to access Docute's Vue instance
      if (iframeWin.__DOCUTE_INSTANCE__) {
        iframeWin.__DOCUTE_INSTANCE__.$store.commit('SET_DARK', isDark);
      }
      // Also try the global docute object
      if (iframeWin.docute && iframeWin.docute.store) {
        iframeWin.docute.store.commit('SET_DARK', isDark);
      }
      
      // === Sphinx Furo ===
      // Furo uses data-theme on html element and localStorage
      iframeDoc.documentElement.setAttribute('data-theme', isDark ? 'dark' : 'light');
      iframeWin.localStorage.setItem('theme', isDark ? 'dark' : 'light');
      // Furo also checks body attribute
      iframeDoc.body.dataset.theme = isDark ? 'dark' : 'light';
      
      // === MkDocs Material ===
      iframeDoc.body.setAttribute('data-md-color-scheme', isDark ? 'slate' : 'default');
      iframeWin.localStorage.setItem('data-md-color-scheme', isDark ? 'slate' : 'default');
      // Material also uses __palette
      try {
        const palette = { scheme: isDark ? 'slate' : 'default' };
        iframeWin.localStorage.setItem('__palette', JSON.stringify(palette));
      } catch (e) {}
      
      // === Hugo Book ===
      iframeWin.localStorage.setItem('book-theme', theme);
      
      // === mdBook ===
      iframeWin.localStorage.setItem('mdbook-theme', isDark ? 'navy' : 'light');
      // mdBook uses class on html
      iframeDoc.documentElement.className = isDark ? 'navy' : 'light';
      
      // === Docsify ===
      iframeWin.localStorage.setItem('docsify-dark-mode', isDark ? 'dark' : 'light');
      
      // === HonKit / GitBook ===
      iframeWin.localStorage.setItem('gitbook-theme', theme);
      
      // === Eleventy (11ty) ===
      iframeWin.localStorage.setItem('color-scheme', theme);
      
      // === DocFX ===
      iframeWin.localStorage.setItem('docfx-theme', theme);
      
      // === Jekyll Just the Docs ===
      iframeWin.localStorage.setItem('jtd-theme', theme);
      
    } catch (e) {
      // Cross-origin iframe, can't access - this is expected for some iframes
    }
  });
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
  // Restore device mode
  const savedMode = localStorage.getItem('deviceMode') || 'desktop';
  setMode(savedMode);
  
  // Restore theme
  const savedTheme = localStorage.getItem('theme');
  const isDark = savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches);
  if (isDark) {
    document.body.classList.add('dark');
  }
  updateThemeIcon(isDark);
  
  // Wait for iframes to load, then apply theme
  setTimeout(() => {
    updateIframesTheme(isDark);
  }, 2000);
});

// Also update iframes when they finish loading
document.addEventListener('load', (e) => {
  if (e.target.tagName === 'IFRAME') {
    const isDark = document.body.classList.contains('dark');
    setTimeout(() => updateIframesTheme(isDark), 500);
  }
}, true);
