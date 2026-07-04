USE exam_results;

INSERT INTO settings (`key`, value) VALUES
('school_name', 'Taysir Schools'),
('school_address', 'Mogadishu, Somalia'),
('school_phone', '+252'),
('school_email', 'info@example.com'),
('school_website', 'https://example.com'),
('school_motto', 'Excellence through knowledge'),
('principal_name', 'Principal'),
('school_footer', 'Prepared by the Examination Office'),
('logo_path', ''),
('admin_logo_path', ''),
('dashboard_title', 'School Result Management'),
('dashboard_subtitle', 'Academic results, publishing, and student records in one secure workspace.'),
('dashboard_theme', 'light'),
('primary_color', '#002060'),
('secondary_color', '#007bff'),
('sidebar_color', '#001a4d'),
('dashboard_background', ''),
('visible_cards', 'students,classes,exams,published,subjects,locked'),
('homepage_widgets', 'search,quick_links,social'),
('default_language', 'en'),
('whatsapp_url', ''),
('facebook_url', ''),
('instagram_url', ''),
('telegram_url', ''),
('twitter_url', ''),
('email_url', 'mailto:info@example.com'),
('call_url', 'tel:+252'),
('maps_url', ''),
('principal_signature_path', ''),
('vice_principal_signature_path', ''),
('exam_officer_signature_path', ''),
('passing_mark', '50')
ON DUPLICATE KEY UPDATE value = VALUES(value);

INSERT INTO grade_scales (grade, min_score, max_score, comment) VALUES
('A+', 95, 100, 'Heer Sare'),
('A', 90, 94.99, 'Heer Sare'),
('A-', 85, 89.99, 'Heer Sare'),
('B+', 80, 84.99, 'Aad u Wanaagsan'),
('B', 75, 79.99, 'Aad u Wanaagsan'),
('B-', 70, 74.99, 'Wanaagsan'),
('C+', 65, 69.99, 'Wanaagsan'),
('C', 60, 64.99, 'Wanaagsan'),
('C-', 50, 59.99, 'Dhexdhexaad'),
('D', 40, 49.99, 'Liita'),
('E', 20, 39.99, 'Liita'),
('F', 0, 19.99, 'Liita');

INSERT INTO users (username, full_name, password_hash, role, is_active) VALUES
('admin', 'System Administrator', 'pbkdf2:sha256:100000$examseed$493daf0da9a665fab8e76e9c2dc83f20f213a8c5da440a3d8fddb447d56b9a97', 'super_admin', TRUE)
ON DUPLICATE KEY UPDATE username = username;
