PRAGMA foreign_keys = ON;
CREATE TABLE stores (id INTEGER PRIMARY KEY CHECK(id=1),name TEXT NOT NULL DEFAULT '麺処 朱',tagline TEXT NOT NULL DEFAULT '毎日食べたい、まっすぐな一杯。',description TEXT NOT NULL DEFAULT '国産鶏と香味野菜をじっくり炊いた澄んだスープ。余計なものを足さず、素材の声を一杯に。',address TEXT NOT NULL DEFAULT '東京都〇〇区〇〇 1-2-3',postal_code TEXT NOT NULL DEFAULT '000-0000',phone TEXT NOT NULL DEFAULT '',business_hours TEXT NOT NULL DEFAULT '11:00–15:00 / 17:30–21:00',regular_holiday TEXT NOT NULL DEFAULT '毎週 水曜日',seats TEXT NOT NULL DEFAULT 'カウンター 10席',map_url TEXT NOT NULL DEFAULT 'https://maps.google.com',status TEXT NOT NULL DEFAULT 'available' CHECK(status IN('available','busy','full','closed')),status_note TEXT NOT NULL DEFAULT 'すぐにご案内できます',status_updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE menus (id TEXT PRIMARY KEY,store_id INTEGER NOT NULL DEFAULT 1 REFERENCES stores(id) ON DELETE CASCADE,name TEXT NOT NULL,price INTEGER NOT NULL CHECK(price>=0),category TEXT NOT NULL CHECK(category IN('ramen','side','drink')),description TEXT NOT NULL DEFAULT '',image_key TEXT,image_url TEXT,badge TEXT NOT NULL DEFAULT '',sold_out INTEGER NOT NULL DEFAULT 0 CHECK(sold_out IN(0,1)),display_order INTEGER NOT NULL DEFAULT 0,created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE admin_users (id TEXT PRIMARY KEY,username TEXT NOT NULL UNIQUE COLLATE NOCASE,password_hash TEXT NOT NULL,password_salt TEXT NOT NULL,iterations INTEGER NOT NULL DEFAULT 210000,created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,last_login_at TEXT);
CREATE TABLE sessions (token_hash TEXT PRIMARY KEY,user_id TEXT NOT NULL REFERENCES admin_users(id) ON DELETE CASCADE,expires_at TEXT NOT NULL,created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE login_attempts (key TEXT PRIMARY KEY,failures INTEGER NOT NULL DEFAULT 0,window_started_at TEXT NOT NULL,blocked_until TEXT);
CREATE INDEX idx_menus_store_order ON menus(store_id,display_order,created_at);
CREATE INDEX idx_sessions_expiry ON sessions(expires_at);
CREATE INDEX idx_login_attempts_blocked ON login_attempts(blocked_until);
INSERT INTO stores(id) VALUES(1);
INSERT INTO menus(id,name,price,category,description,image_url,badge,display_order) VALUES
('m1','特製 醤油らぁ麺',1250,'ramen','二種の焼豚と味玉をのせた、当店いちばん人気の一杯。','/assets/ramen-hero.png','一番人気',10),
('m2','醤油らぁ麺',950,'ramen','鶏の旨みと芳醇な醤油の香り。毎日食べたくなる味。','/assets/ramen-hero.png','',20),
('m3','塩らぁ麺',980,'ramen','貝の余韻を重ねた、透き通るやさしい塩スープ。','/assets/ramen-hero.png','店主おすすめ',30),
('m4','炙り焼豚ご飯',420,'side','香ばしく炙った焼豚に、特製だれと卵黄を添えて。','/assets/ramen-hero.png','',40),
('m5','自家製 焼き餃子',480,'side','野菜の甘みたっぷり。店内仕込みの羽根つき餃子。','/assets/ramen-hero.png','',50),
('m6','瓶ビール',600,'drink','よく冷えた中瓶。らぁ麺のおともにどうぞ。','/assets/ramen-hero.png','',60);
PRAGMA optimize;
