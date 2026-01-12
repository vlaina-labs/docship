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
      
      // Try to set theme via various methods used by different frameworks
      
      // 1. HTML attribute (VitePress, Docusaurus, Starlight, etc.)
      iframeDoc.documentElement.setAttribute('data-theme', theme);
      iframeDoc.documentElement.setAttribute('data-color-mode', theme);
      iframeDoc.documentElement.classList.remove('light', 'dark');
      iframeDoc.documentElement.classList.add(theme);
      
      // 2. Body class (some frameworks)
      iframeDoc.body.classList.remove('light', 'dark');
      iframeDoc.body.classList.add(theme);
      
      // 3. localStorage (Docusaurus, VitePress, Nextra, Fumadocs, etc.)
      iframeWin.localStorage.setItem('theme', theme);
      iframeWin.localStorage.setItem('color-theme', theme);
      iframeWin.localStorage.setItem('vitepress-theme-appearance', theme);
      iframeWin.localStorage.setItem('docusaurus.theme.mode', theme);
      iframeWin.localStorage.setItem('nextra-theme', theme);
      iframeWin.localStorage.setItem('starlight-theme', theme);
      
      // 4. Nuxt color mode (Docus)
      iframeWin.localStorage.setItem('nuxt-color-mode', theme);
      
      // 5. MkDocs Material
      iframeDoc.body.setAttribute('data-md-color-scheme', theme === 'dark' ? 'slate' : 'default');
      
      // 6. Rspress
      iframeWin.localStorage.setItem('rspress-theme', theme);
      
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
