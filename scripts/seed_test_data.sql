BEGIN;

TRUNCATE TABLE
    price_votes,
    fuel_price_reports,
    comments,
    user_devices,
    fuel_prices,
    stations,
    global_config,
    users
RESTART IDENTITY CASCADE;

INSERT INTO users (id, email, user_name, password_hash, role, trust_score, created_at, email_verified_at, is_email_verified)
VALUES
    (1, 'admin@tirx.local', 'admin', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'admin'::user_role, 0.95, NOW()::timestamp - INTERVAL '30 days', NOW()::timestamp - INTERVAL '29 days', true),
    (2, 'alice@tirx.local', 'alice', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user'::user_role, 0.76, NOW()::timestamp - INTERVAL '20 days', NOW()::timestamp - INTERVAL '19 days', true),
    (3, 'bob@tirx.local', 'bobby', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user'::user_role, 0.51, NOW()::timestamp - INTERVAL '12 days', NULL, false),
    (4, 'carol@tirx.local', 'carol', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user'::user_role, 0.84, NOW()::timestamp - INTERVAL '7 days', NOW()::timestamp - INTERVAL '6 days', true);

INSERT INTO global_config (id, trust_threshold_ratio, price_deviation_limit, updated_at)
VALUES
    (1, 0.60, 0.20, NOW()::timestamp)
ON CONFLICT (id) DO UPDATE
SET trust_threshold_ratio = EXCLUDED.trust_threshold_ratio,
    price_deviation_limit = EXCLUDED.price_deviation_limit,
    updated_at = EXCLUDED.updated_at;

INSERT INTO stations (id, name, location, adress, city, created_at)
VALUES
    (1, 'Orlen Młynarska', ST_SetSRID(ST_MakePoint(20.9655, 52.2420), 4326)::geography, 'ul. Młynarska 10', 'Warszawa', NOW()::timestamp - INTERVAL '14 days'),
    (2, 'BP Aleje Jerozolimskie', ST_SetSRID(ST_MakePoint(21.0037, 52.2302), 4326)::geography, 'Aleje Jerozolimskie 101', 'Warszawa', NOW()::timestamp - INTERVAL '10 days'),
    (3, 'Shell Legnicka', ST_SetSRID(ST_MakePoint(17.0173, 51.1124), 4326)::geography, 'ul. Legnicka 45', 'Wrocław', NOW()::timestamp - INTERVAL '8 days');

INSERT INTO fuel_prices (id, station_id, user_id, fuel_type_id, price, upvotes_count, downvotes_count, created_at)
VALUES
    (1, 1, 2, 1, 6.39, 4, 0, NOW()::timestamp - INTERVAL '2 days'),
    (2, 1, 4, 2, 6.79, 3, 1, NOW()::timestamp - INTERVAL '1 day 12 hours'),
    (3, 2, 2, 1, 6.45, 2, 0, NOW()::timestamp - INTERVAL '1 day'),
    (4, 3, 4, 3, 7.05, 1, 0, NOW()::timestamp - INTERVAL '10 hours');

INSERT INTO price_votes (id, price_id, user_id, vote_value, created_at)
VALUES
    (1, 1, 4, 1, NOW()::timestamp - INTERVAL '40 hours'),
    (2, 1, 3, 1, NOW()::timestamp - INTERVAL '38 hours'),
    (3, 2, 2, -1, NOW()::timestamp - INTERVAL '30 hours'),
    (4, 3, 1, 1, NOW()::timestamp - INTERVAL '20 hours');

INSERT INTO fuel_price_reports (id, fuel_price_id, user_id, reason, status, created_at, moderated_at, moderated_by_user_id)
VALUES
    (1, 2, 3, 'Cena wygląda na zawyżoną względem stacji obok.', 'pending'::fuel_price_report_status, NOW()::timestamp - INTERVAL '8 hours', NULL, NULL),
    (2, 4, 2, 'Możliwa pomyłka typu paliwa.', 'approved'::fuel_price_report_status, NOW()::timestamp - INTERVAL '6 hours', NOW()::timestamp - INTERVAL '3 hours', 1),
    (3, 3, 4, 'Nieaktualna cena po zmianie rano.', 'rejected'::fuel_price_report_status, NOW()::timestamp - INTERVAL '5 hours', NOW()::timestamp - INTERVAL '2 hours', 1);

INSERT INTO comments (id, station_id, user_id, content, created_at)
VALUES
    (1, 1, 2, 'Dużo wolnych stanowisk, bez kolejek.', NOW() - INTERVAL '36 hours'),
    (2, 1, 4, 'Myjnia działa, ale karta płatnicza tylko na kasie.', NOW() - INTERVAL '28 hours'),
    (3, 2, 3, 'W godzinach szczytu tworzy się kolejka od strony centrum.', NOW() - INTERVAL '16 hours');

INSERT INTO user_devices (id, user_id, fingerprint_hash, user_agent, last_seen_at, created_at)
VALUES
    (1, 2, 'fp_alice_iphone_001', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X)', NOW()::timestamp - INTERVAL '1 hour', NOW()::timestamp - INTERVAL '20 days'),
    (2, 2, 'fp_alice_chrome_002', 'Mozilla/5.0 (X11; Linux x86_64) Chrome/135.0', NOW()::timestamp - INTERVAL '4 hours', NOW()::timestamp - INTERVAL '4 days'),
    (3, 4, 'fp_carol_android_001', 'Mozilla/5.0 (Linux; Android 15) Mobile Safari/537.36', NOW()::timestamp - INTERVAL '3 hours', NOW()::timestamp - INTERVAL '7 days');

SELECT setval(pg_get_serial_sequence('users', 'id'), COALESCE((SELECT MAX(id) FROM users), 1), true);
SELECT setval(pg_get_serial_sequence('global_config', 'id'), COALESCE((SELECT MAX(id) FROM global_config), 1), true);
SELECT setval(pg_get_serial_sequence('stations', 'id'), COALESCE((SELECT MAX(id) FROM stations), 1), true);
SELECT setval(pg_get_serial_sequence('fuel_prices', 'id'), COALESCE((SELECT MAX(id) FROM fuel_prices), 1), true);
SELECT setval(pg_get_serial_sequence('price_votes', 'id'), COALESCE((SELECT MAX(id) FROM price_votes), 1), true);
SELECT setval(pg_get_serial_sequence('fuel_price_reports', 'id'), COALESCE((SELECT MAX(id) FROM fuel_price_reports), 1), true);
SELECT setval(pg_get_serial_sequence('comments', 'id'), COALESCE((SELECT MAX(id) FROM comments), 1), true);
SELECT setval(pg_get_serial_sequence('user_devices', 'id'), COALESCE((SELECT MAX(id) FROM user_devices), 1), true);

COMMIT;