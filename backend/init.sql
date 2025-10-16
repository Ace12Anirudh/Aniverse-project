-- AniVerse Database Initialization Script
-- This script sets up the database with initial data

USE aniverse;

-- Create admin user (password: admin123)
INSERT IGNORE INTO users (id, username, email, hashed_password, is_admin, created_at) VALUES 
(UUID(), 'admin', 'admin@aniverse.com', '$2b$12$LQv3c1yqBw.TaJLmG.aB7uBh8P5bG1JzI6vG7Fg9WlKW2X3HzV.Yi', true, NOW()),
(UUID(), 'demo_user', 'demo@aniverse.com', '$2b$12$LQv3c1yqBw.TaJLmG.aB7uBh8P5bG1JzI6vG7Fg9WlKW2X3HzV.Yi', false, NOW());

-- Insert genres
INSERT IGNORE INTO genres (name) VALUES 
('Action'), ('Adventure'), ('Comedy'), ('Drama'), ('Fantasy'), 
('Horror'), ('Mystery'), ('Romance'), ('Sci-Fi'), ('Slice of Life'),
('Sports'), ('Supernatural'), ('Thriller'), ('Historical'), ('Mecha'),
('School'), ('Military'), ('Music'), ('Psychological'), ('Shounen'),
('Shoujo'), ('Seinen'), ('Josei'), ('Ecchi'), ('Harem');

-- Insert sample anime
INSERT IGNORE INTO animes (id, title, synopsis, cover_image_url, release_year, status, created_at) VALUES
(
  UUID(),
  'Attack on Titan',
  'Humanity fights for survival against giant humanoid Titans that have brought civilization to the brink of extinction. When the outer wall is breached, Eren Yeager and his friends join the Survey Corps to fight back.',
  'https://via.placeholder.com/300x400/FF6B35/FFFFFF?text=Attack+on+Titan',
  2013,
  'Finished',
  NOW()
),
(
  UUID(),
  'Demon Slayer',
  'After his family is slaughtered by demons, Tanjiro Kamado becomes a demon slayer to save his sister Nezuko, who has been turned into a demon but still retains her humanity.',
  'https://via.placeholder.com/300x400/4ECDC4/FFFFFF?text=Demon+Slayer',
  2019,
  'Finished',
  NOW()
),
(
  UUID(),
  'My Hero Academia',
  'In a world where most people have superpowers called "Quirks," Izuku Midoriya dreams of becoming a hero despite being born without powers. His life changes when he meets the greatest hero, All Might.',
  'https://via.placeholder.com/300x400/45B7D1/FFFFFF?text=My+Hero+Academia',
  2016,
  'Airing',
  NOW()
),
(
  UUID(),
  'One Piece',
  'Monkey D. Luffy sets out on an adventure to find the legendary treasure known as "One Piece" and become the next Pirate King. Along the way, he assembles a crew of unique pirates.',
  'https://via.placeholder.com/300x400/F39C12/FFFFFF?text=One+Piece',
  1999,
  'Airing',
  NOW()
),
(
  UUID(),
  'Spirited Away',
  'A 10-year-old girl named Chihiro enters a world of spirits and witches, where she must work to free her parents who have been turned into pigs by an evil witch.',
  'https://via.placeholder.com/300x400/9B59B6/FFFFFF?text=Spirited+Away',
  2001,
  'Finished',
  NOW()
),
(
  UUID(),
  'Death Note',
  'A high school student discovers a supernatural notebook that allows him to kill anyone by writing their name in it. He decides to use it to rid the world of criminals.',
  'https://via.placeholder.com/300x400/2C3E50/FFFFFF?text=Death+Note',
  2006,
  'Finished',
  NOW()
);

-- Get anime IDs for linking genres and episodes
SET @aot_id = (SELECT id FROM animes WHERE title = 'Attack on Titan' LIMIT 1);
SET @ds_id = (SELECT id FROM animes WHERE title = 'Demon Slayer' LIMIT 1);
SET @mha_id = (SELECT id FROM animes WHERE title = 'My Hero Academia' LIMIT 1);
SET @op_id = (SELECT id FROM animes WHERE title = 'One Piece' LIMIT 1);
SET @sa_id = (SELECT id FROM animes WHERE title = 'Spirited Away' LIMIT 1);
SET @dn_id = (SELECT id FROM animes WHERE title = 'Death Note' LIMIT 1);

-- Link animes with genres
INSERT IGNORE INTO anime_genres (anime_id, genre_id) VALUES
-- Attack on Titan: Action, Drama, Fantasy
(@aot_id, (SELECT id FROM genres WHERE name = 'Action')),
(@aot_id, (SELECT id FROM genres WHERE name = 'Drama')),
(@aot_id, (SELECT id FROM genres WHERE name = 'Fantasy')),

-- Demon Slayer: Action, Supernatural, Shounen
(@ds_id, (SELECT id FROM genres WHERE name = 'Action')),
(@ds_id, (SELECT id FROM genres WHERE name = 'Supernatural')),
(@ds_id, (SELECT id FROM genres WHERE name = 'Shounen')),

-- My Hero Academia: Action, School, Shounen
(@mha_id, (SELECT id FROM genres WHERE name = 'Action')),
(@mha_id, (SELECT id FROM genres WHERE name = 'School')),
(@mha_id, (SELECT id FROM genres WHERE name = 'Shounen')),

-- One Piece: Action, Adventure, Comedy, Shounen
(@op_id, (SELECT id FROM genres WHERE name = 'Action')),
(@op_id, (SELECT id FROM genres WHERE name = 'Adventure')),
(@op_id, (SELECT id FROM genres WHERE name = 'Comedy')),
(@op_id, (SELECT id FROM genres WHERE name = 'Shounen')),

-- Spirited Away: Adventure, Family, Fantasy
(@sa_id, (SELECT id FROM genres WHERE name = 'Adventure')),
(@sa_id, (SELECT id FROM genres WHERE name = 'Fantasy')),

-- Death Note: Psychological, Thriller, Supernatural
(@dn_id, (SELECT id FROM genres WHERE name = 'Psychological')),
(@dn_id, (SELECT id FROM genres WHERE name = 'Thriller')),
(@dn_id, (SELECT id FROM genres WHERE name = 'Supernatural'));

-- Insert sample episodes
INSERT IGNORE INTO episodes (id, anime_id, episode_number, title, duration_seconds, created_at) VALUES
-- Attack on Titan Episodes
(UUID(), @aot_id, 1, 'To You, in 2000 Years: The Fall of Shiganshina, Part 1', 1440, NOW()),
(UUID(), @aot_id, 2, 'That Day: The Fall of Shiganshina, Part 2', 1440, NOW()),
(UUID(), @aot_id, 3, 'A Dim Light Amid Despair: Humanity\'s Comeback, Part 1', 1440, NOW()),

-- Demon Slayer Episodes  
(UUID(), @ds_id, 1, 'Cruelty', 1380, NOW()),
(UUID(), @ds_id, 2, 'Trainer Sakonji Urokodaki', 1380, NOW()),
(UUID(), @ds_id, 3, 'Sabito and Makomo', 1380, NOW()),

-- My Hero Academia Episodes
(UUID(), @mha_id, 1, 'Izuku Midoriya: Origin', 1440, NOW()),
(UUID(), @mha_id, 2, 'What It Takes to Be a Hero', 1440, NOW()),
(UUID(), @mha_id, 3, 'Roaring Muscles', 1440, NOW()),

-- One Piece Episodes (just a few examples)
(UUID(), @op_id, 1, 'I\'m Luffy! The Man Who\'s Gonna Be King of the Pirates!', 1440, NOW()),
(UUID(), @op_id, 2, 'Enter the Great Swordsman! Pirate Hunter Roronoa Zoro!', 1440, NOW()),
(UUID(), @op_id, 3, 'Morgan versus Luffy! Who\'s the Mysterious Pretty Girl?', 1440, NOW()),

-- Death Note Episodes
(UUID(), @dn_id, 1, 'Rebirth', 1380, NOW()),
(UUID(), @dn_id, 2, 'Confrontation', 1380, NOW()),
(UUID(), @dn_id, 3, 'Dealings', 1380, NOW());

-- Success message
SELECT 'Database initialized successfully with sample data!' as message;
