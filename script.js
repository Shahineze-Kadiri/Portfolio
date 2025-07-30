// ============================================================
// script.js — Interactions du portfolio (version commentée)
// ============================================================
// Ce fichier gère :
// 1) L’apparition progressive des éléments (.reveal)
// 2) L’ombre du header au scroll (header mobile seulement)
// 3) Le menu mobile (burger)
// 4) La mise en évidence du lien actif (header + sidebar)
// 5) Le défilement horizontal des galeries de projets (.h-gallery)
// ------------------------------------------------------------


// ============================================================
// 1) Révélations au scroll (IntersectionObserver)
// ------------------------------------------------------------
// Idée : chaque élément .reveal apparaît quand il entre dans la fenêtre.
// .visible (ajouté dynamiquement) déclenche l’animation CSS.
const revealEls = document.querySelectorAll('.reveal');

const onIntersect = (entries, observer) => {
  entries.forEach((entry, i) => {
    if (entry.isIntersecting) {
      // Petit décalage pour un effet "staggered" (cascade)
      setTimeout(() => {
        entry.target.classList.add('visible');
      }, i * 120);

      // On arrête d’observer l’élément une fois affiché (perf)
      observer.unobserve(entry.target);
    }
  });
};

const revealObserver = new IntersectionObserver(onIntersect, {
  root: null,
  rootMargin: '0px 0px -10% 0px',
  threshold: 0.15
});

revealEls.forEach(el => revealObserver.observe(el));


// ============================================================
// 2) Ombre du header au scroll (mobile uniquement)
// ------------------------------------------------------------
// En desktop, on cache le header (on utilise la sidebar).
// On protège donc le code si le header n’existe pas.
const header = document.querySelector('header.mobile-only');
const setHeaderShadow = () => {
  if (!header) return;                 // rien à faire en desktop
  if (window.scrollY > 10) header.classList.add('scrolled');
  else header.classList.remove('scrolled');
};
setHeaderShadow();
window.addEventListener('scroll', setHeaderShadow, { passive: true });


// ============================================================
// 3) Menu mobile (burger)
// ------------------------------------------------------------
// Ouvre/ferme la nav du header mobile. Ferme aussi quand on clique un lien.
const toggle = document.querySelector('.menu-toggle');   // bouton ☰
const topNav = document.getElementById('nav');           // <nav id="nav"> du header

if (toggle && topNav) {
  toggle.addEventListener('click', () => {
    const open = topNav.classList.toggle('open');
    toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
  });

  // Fermer le menu mobile quand on clique sur un lien
  topNav.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => {
      topNav.classList.remove('open');
      toggle.setAttribute('aria-expanded', 'false');
    });
  });
}


// ============================================================
// 4) Lien actif selon la section visible (header + sidebar)
// ------------------------------------------------------------
// Objectif : surligner le lien du menu correspondant à la section visible.
// On cible à la fois :
//   - les liens du header mobile (#nav a)
//   - les liens de la sidebar desktop (.sidenav a)
const sections = document.querySelectorAll('main section[id]');
const allNavLinks = document.querySelectorAll('#nav a, .sidenav a');

// Ajoute/retire la classe .active selon l’id de la section
const setActiveLink = (id) => {
  allNavLinks.forEach(a => {
    const href = a.getAttribute('href');
    a.classList.toggle('active', href === `#${id}`);
  });
};

// Observer qui détecte la section majoritairement visible
const activeObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) setActiveLink(entry.target.id);
  });
}, { threshold: 0.6 });

sections.forEach(sec => activeObserver.observe(sec));


// ============================================================
// 5) Défilement horizontal des galeries (.h-gallery)
// ------------------------------------------------------------
// Idée : convertir le scroll vertical (molette) en scroll horizontal
// sur nos conteneurs horizontaux (UX premium).
document.querySelectorAll('.h-gallery').forEach(gal => {
  gal.addEventListener('wheel', (e) => {
    // si l’utilisateur scrolle surtout verticalement, on le redirige
    if (Math.abs(e.deltaY) > Math.abs(e.deltaX)) {
      e.preventDefault();
      gal.scrollLeft += e.deltaY;   // on déplace la galerie horizontalement
    }
  }, { passive: false });
});


// ============================================================
// (Optionnel) Bonus UX : navigation clavier dans les galeries
// ------------------------------------------------------------
// Gauche/Droite pour se déplacer d’une carte à l’autre quand la galerie a le focus.
// - Laisse en commentaire si tu ne veux pas de ce comportement.

document.querySelectorAll('.h-gallery').forEach(gal => {
   gal.setAttribute('tabindex', '0'); // rend focusable au clavier
   gal.addEventListener('keydown', (e) => {
     if (e.key === 'ArrowRight') gal.scrollLeft += 280;
     if (e.key === 'ArrowLeft')  gal.scrollLeft -= 280;
   });
 });


 // =========================
// MODAL DETAIL PROJET
// =========================
const modal = document.getElementById('project-modal');
if (modal) {
  const dlg = modal.querySelector('.modal__dialog');
  const btnClose = modal.querySelector('.modal__close');
  const btnClose2 = modal.querySelector('.modal__close2');

  const elImg = modal.querySelector('#modal-img');
  const elTitle = modal.querySelector('#modal-title');
  const elTags = modal.querySelector('#modal-tags');
  const elSummary = modal.querySelector('#modal-summary');
  const elRole = modal.querySelector('#modal-role');
  const elResults = modal.querySelector('#modal-results');
  const elTech = modal.querySelector('#modal-tech');
  const elLink = modal.querySelector('#modal-link');

  // Ouvrir depuis une carte
  document.querySelectorAll('.h-card').forEach(card => {
    card.style.cursor = 'pointer';
    card.addEventListener('click', () => {
      const title = card.querySelector('h4')?.textContent?.trim() || 'Projet';
      const tags = card.querySelector('.tags')?.textContent?.trim() || '';
      const img = card.querySelector('img')?.getAttribute('src') || '';

      // Données optionnelles via data-*
      const summary = card.dataset.summary || 'Description à venir…';
      const role = card.dataset.role || '—';
      const tech = card.dataset.tech || '—';
      const link = card.dataset.link || '#';

      // Liste de résultats : autorise un JSON (["...", "..."])
      let results = [];
      try {
        results = card.dataset.results ? JSON.parse(card.dataset.results) : [];
      } catch(e){ results = []; }

      // Injection
      elTitle.textContent = title;
      elTags.textContent = tags;
      elImg.src = img;
      elImg.alt = title;
      elSummary.textContent = summary;
      elRole.textContent = role;
      elTech.textContent = tech;

      // Résultats (ul)
      elResults.innerHTML = '';
      (results.length ? results : ['—']).forEach(r => {
        const li = document.createElement('li');
        li.textContent = r;
        elResults.appendChild(li);
      });

      // Lien
      if (link && link !== '#') {
        elLink.href = link;
        elLink.style.display = 'inline-block';
      } else {
        elLink.style.display = 'none';
      }

      // Ouvre la modal
      openModal();
    });
  });

  function openModal(){
    modal.classList.add('open');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden'; // empêche le scroll arrière-plan
    btnClose?.focus();
  }
  function closeModal(){
    modal.classList.remove('open');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
  }

  // Fermetures : bouton, bouton secondaire, clic fond, ESC
  btnClose?.addEventListener('click', closeModal);
  btnClose2?.addEventListener('click', closeModal);
  modal.addEventListener('click', (e) => {
    if (e.target === modal) closeModal(); // clic sur l’overlay
  });
  window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && modal.classList.contains('open')) closeModal();
  });

  // Empêche le clic dans la boîte de fermer la modal
  dlg.addEventListener('click', (e) => e.stopPropagation());
}



