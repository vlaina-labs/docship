function setMode(mode) {
  document.querySelectorAll('.iframe-wrap').forEach(w => {
    w.className = 'iframe-wrap ' + mode;
  });
  document.querySelectorAll('.toggle-btn').forEach(b => {
    b.classList.toggle('active', b.dataset.mode === mode);
  });
}
