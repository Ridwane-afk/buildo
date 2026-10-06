-- =====================================================================
-- BUILDO — Démo jury : impact de l'API REST dans la base de données
-- À ouvrir dans DBeaver (connexion « dev »). Placer le curseur dans une
-- requête et faire Cmd + Entrée pour l'exécuter.
-- =====================================================================


-- ① Après « 2. POST — Créer un chantier » : le chantier apparaît
--    (même id que dans la réponse Postman, budget 25 000)
-- ③ Après « 3. PUT » : relancer → budget 30 000 et description remplie
-- ⑧ Après « 8. DELETE chantier » : relancer → le chantier a disparu
SELECT id, ref, name, budget_initial, description, create_date
FROM chantier_chantier
ORDER BY id DESC
LIMIT 3;


-- ② Après « 4. POST — Créer une tâche » : la tâche est liée au chantier
-- ⑥ Après « 6. PUT » : relancer → avancement 50
-- ⑦ Après « 7. DELETE tâche » : relancer → la tâche a disparu
SELECT t.id, t.name, t.state, t.avancement, c.name AS chantier
FROM chantier_tache t
JOIN chantier_chantier c ON c.id = t.chantier_id
ORDER BY t.id DESC
LIMIT 3;


-- Bonus : l'ouvrier assigné à la tâche (table de liaison many2many)
SELECT r.tache_id, u.login AS ouvrier_assigne
FROM chantier_tache_ouvrier_rel r
JOIN res_users u ON u.id = r.user_id
ORDER BY r.tache_id DESC
LIMIT 3;
