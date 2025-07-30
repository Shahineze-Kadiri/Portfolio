
// ================================================
// script.js — Interactions du portfolio
// - Apparition progressive des éléments (IntersectionObserver)
// - Ombre du header au scroll
// - Menu mobile (burger)
// - Mise en évidence du lien actif (section en vue)
// ================================================

// 1) Révélations au scroll
const revealEls = document.querySelectorAll('.reveal');

const onIntersect = (entries, observer) => {
  entries.forEach((entry, i) => {
    if (entry.isIntersecting) {
      // Décalage progressif pour un effet "staggered"
      setTimeout(() => {
        entry.target.classList.add('visible');
      }, i * 120);
      observer.unobserve(entry.target);
    }
  });
};

const observer = new IntersectionObserver(onIntersect, {
  root: null,
  rootMargin: '0px 0px -10% 0px',
  threshold: 0.15
});

revealEls.forEach(el => observer.observe(el));

// 2) Ombre du header quand on scrolle
const header = document.querySelector('header');
const setHeaderShadow = () => {
  if (window.scrollY > 10) header.classList.add('scrolled');
  else header.classList.remove('scrolled');
};
setHeaderShadow();
window.addEventListener('scroll', setHeaderShadow, { passive: true });

// 3) Menu mobile (burger)
const toggle = document.querySelector('.menu-toggle');
const nav = document.querySelector('nav');
if (toggle) {
  toggle.addEventListener('click', () => {
    const open = nav.classList.toggle('open');
    toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
  });
}

// 4) Lien actif selon la section visible
const sections = document.querySelectorAll('main section[id]');
const navLinks = document.querySelectorAll('nav a');

const setActiveLink = (id) => {
  navLinks.forEach(a => {
    const href = a.getAttribute('href');
    if (href === `#${id}`) a.classList.add('active');
    else a.classList.remove('active');
  });
};

const sectionObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      setActiveLink(entry.target.id);
    }
  });
}, { threshold: 0.6 });

sections.forEach(sec => sectionObserver.observe(sec));
