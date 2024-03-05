DROP DATABASE IF EXISTS cupid_connect;
CREATE DATABASE cupid_connect;
USE cupid_connect;
-- CREATE TABLE SQL 
CREATE TABLE `profiles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `avatar` NVARCHAR(50) NULL,
  `intro` NVARCHAR(255) NULL,
  `hobbies` NVARCHAR(255) NULL,
  `work_at` NVARCHAR(100) NULL, -- Added missing comma here
  `mbti_mark` FLOAT CHECK (`mbti_mark` BETWEEN 0 AND 100) NULL,
  KEY `Key` (`avatar`, `intro`, `hobbies`, `work_at`, `mbti_mark`)
);
CREATE TABLE `genders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` NVARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE `feedbacks` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `description` TEXT,
  `rate` INT NOT NULL CHECK (`rate` BETWEEN 1 AND 5)
);
CREATE TABLE `roles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` NVARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `first_name` NVARCHAR(50) NOT NULL,
  `last_name` NVARCHAR(50) NOT NULL,
  `nickname` NVARCHAR(100),
  `password` VARCHAR(50) NOT NULL,
  `gender` INT,
  `email` VARCHAR(50) NOT NULL UNIQUE,
  `phone` CHAR(10) UNIQUE,
  `address` NVARCHAR(200),
  `date_of_birth` DATE,
  `fb_account_id` INT UNIQUE,
  `google_account_id` INT UNIQUE,
  `confirmation_code` VARCHAR(255),
  `confirmation_time` DATETIME,
  `popularity` DECIMAL(5,2) DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 CHECK (is_active IN (0,1)),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_admin` TINYINT(1) NOT NULL DEFAULT 0 CHECK (is_admin IN (0,1)),
  `role_id` INT,
  `profile_id` INT,
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`),
  FOREIGN KEY (`gender`) REFERENCES `genders`(`id`),
  FOREIGN KEY (`profile_id`) REFERENCES `profiles`(`id`),
  KEY `Key` (`first_name`, `last_name`, `nickname`, `email`, `phone`)
);
CREATE TRIGGER before_insert_users
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  IF NEW.date_of_birth > CURDATE() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The date of birth cannot be in the future.';
  END IF;
END;
CREATE TABLE `social_accounts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `provider` VARCHAR(20) NOT NULL,
  `provider_id` VARCHAR(50) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `name` VARCHAR(100),
  `user_id` INT,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  KEY `Key` (`provider`, `email`, `name`)
);
CREATE TABLE `conversations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT,
  `time_started` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_closed` TIMESTAMP NULL DEFAULT NULL,
  `feedback_id` INT,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  KEY `Key` (`time_started`, `time_closed`)
);
CREATE TABLE `questions_categories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` NVARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE `questions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` NVARCHAR(50) NOT NULL, -- Giả sử cột này không được để trống
  `question_text` TEXT NOT NULL, -- Giả sử cột này không được để trống
  `category_id` INT,
  `image` NVARCHAR(255), -- Chỉ định rõ độ dài
  `mark` INT NOT NULL, -- Giả sử cột này không được để trống
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Giả sử cột này không được để trống và có giá trị mặc định là thời gian hiện tại
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Giả sử cột này không được để trống và tự động cập nhật khi có thay đổi
  FOREIGN KEY (`category_id`) REFERENCES `questions_categories`(`id`), -- Thêm ràng buộc khóa ngoại
  KEY `Key` (`name`, `question_text`(255), `category_id`, `image`, `mark`, `created_at`, `updated_at`)
);
CREATE TABLE `relationship_type` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` NVARCHAR(50)
);
ALTER TABLE `relationship_type`
ADD CONSTRAINT `unique_name` UNIQUE (`name`);
CREATE TABLE `payments` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `description` TEXT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT NOT NULL,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  KEY `Key` (`created_at`), -- Remove 'description' from here if not strictly necessary for indexing
  KEY `DescriptionKey` (`description`(255)) -- Add a separate key for 'description' with a specified length
);
CREATE TABLE `notification` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `source_id` INT,
  `source_type` VARCHAR(50),
  `type` SMALLINT,
  `read` TINYINT(1),
  `trash` TINYINT(1),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  KEY `Key` (`source_id`, `source_type`, `type`, `read`, `trash`, `created_at`, `updated_at`)
);
ALTER TABLE `notification`
ADD CONSTRAINT `chk_read` CHECK (`read` IN (0, 1)),
ADD CONSTRAINT `chk_trash` CHECK (`trash` IN (0, 1));
CREATE TABLE `grades` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `user_id_received` INT NOT NULL,
  `grade` INT NOT NULL CHECK (`grade` BETWEEN 1 AND 10),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`user_id_received`) REFERENCES `users`(`id`),
  KEY `Key` (`grade`)
);
ALTER TABLE `grades`
ADD CONSTRAINT `uc_user_user_received` UNIQUE (`user_id`, `user_id_received`);
CREATE TABLE `interested_in_relation` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT,
  `relationship_type_id` INT,
  FOREIGN KEY (`relationship_type_id`) REFERENCES `relationship_type`(`id`)
);
ALTER TABLE `interested_in_relation`
MODIFY `user_id` INT NOT NULL,
MODIFY `relationship_type_id` INT NOT NULL,
ADD CONSTRAINT `uc_user_relationship_type` UNIQUE (`user_id`, `relationship_type_id`);
CREATE TABLE `user_photos` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT,
  `link` TEXT NOT NULL, -- Đã thêm ràng buộc NOT NULL ở đây
  `details` TEXT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` TINYINT(1) NOT NULL, -- Đã thêm ràng buộc NOT NULL ở đây
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
);
-- Loại bỏ `link` và `details` khỏi chỉ mục do là TEXT
ALTER TABLE `user_photos` ADD KEY `UserPhotoIndex` (`created_at`, `is_active`);
CREATE TABLE `answers` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `answer_text` NVARCHAR(100) NOT NULL, -- Đảm bảo không chấp nhận giá trị NULL
  `question_id` INT NOT NULL, -- Đảm bảo không chấp nhận giá trị NULL
  KEY `Key` (`answer_text`, `question_id`),
  FOREIGN KEY (`question_id`) REFERENCES `questions`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE `question_answers` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `question_id` INT NOT NULL, -- Đảm bảo không chấp nhận giá trị NULL
  `answer_id` INT NOT NULL, -- Đảm bảo không chấp nhận giá trị NULL
  FOREIGN KEY (`answer_id`) REFERENCES `answers`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`question_id`) REFERENCES `questions`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE `messages` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `from_user_id` INT NOT NULL,
  `to_user_id` INT NOT NULL,
  `message_text` TEXT,
  `send_datetime` DATETIME NOT NULL,
  FOREIGN KEY (`from_user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`to_user_id`) REFERENCES `users`(`id`),
  KEY `Key` (`send_datetime`)
);
CREATE TABLE `blocks` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `user_id_blocked` INT NOT NULL,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`user_id_blocked`) REFERENCES `users`(`id`)
);
CREATE TABLE `participants` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `conversation_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `time_joined` DATETIME NOT NULL,
  `time_left` DATETIME,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`conversation_id`) REFERENCES `conversations`(`id`),
  KEY `Key` (`time_joined`, `time_left`)
);
CREATE TABLE `interest_genders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL, -- Đảm bảo rằng user_id không được để trống
  `gender_id` INT NOT NULL, -- Đảm bảo rằng gender_id không được để trống
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`gender_id`) REFERENCES `genders`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE `tokens` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `token` VARCHAR(255) NOT NULL, -- Đảm bảo rằng token không được để trống
  `token_type` VARCHAR(50) NOT NULL, -- Đảm bảo rằng token_type không được để trống
  `revoked` TINYINT(1) NOT NULL, -- Đảm bảo rằng revoked không được để trống
  `expired` TINYINT(1) NOT NULL, -- Đảm bảo rằng expired không được để trống
  `user_id` INT NOT NULL, -- Đảm bảo rằng user_id không được để trống
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  KEY `Key` (`token`, `token_type`, `revoked`, `expired`)
);
CREATE TABLE `friend_requests` (
  `to_id` INT NOT NULL,
  `from_id` INT NOT NULL,
  `accepted` TINYINT(1),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message` NVARCHAR(255), -- gui thong diep ket ban 
  PRIMARY KEY (`to_id`, `from_id`),
  FOREIGN KEY (`to_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`from_id`) REFERENCES `users`(`id`)
);

CREATE TABLE `friends` (
  `user_id` INT NOT NULL,
  `friend_id` INT NOT NULL,
  `friend_since` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `favorite` TINYINT(1) NOT NULL DEFAULT 0 CHECK (favorite IN (0,1)), -- yêu thích or quan trọng 
  `status` NVARCHAR(50), -- "bình thường", "tạm thời xa cách", "..."
  PRIMARY KEY (`user_id`, `friend_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`friend_id`) REFERENCES `users`(`id`)
);
-- INSERT SAMPLE DATA 
-- insert roles 
INSERT INTO `roles` (`name`) VALUES ('Admin'), ('User'), ('Guest');
-- insert profile
INSERT INTO `profiles` (`avatar`, `intro`, `hobbies`, `work_at`, `mbti_mark`) VALUES
('avatar1.jpg', 'Tôi là một người thích đọc sách và đi du lịch.', 'Đọc sách, Du lịch, Nấu ăn', 'Công ty XYZ', 95.5),
('avatar2.jpg', 'Lập trình viên với đam mê công nghệ và phát triển phần mềm.', 'Lập trình, Đọc sách kỹ thuật', 'Công ty ABC', 88.0),
('avatar3.png', 'Nhiếp ảnh gia tự do, yêu thích thiên nhiên và du lịch.', 'Chụp ảnh, Du lịch', 'Freelancer', 78.0);
-- insert gender 
INSERT INTO `genders` (`name`) VALUES ('Male'), ('Female'), ('Other');
INSERT INTO `users` (`first_name`, `last_name`, `nickname`, `password`, `gender`, `email`, `phone`, `address`, `date_of_birth`, `fb_account_id`, `google_account_id`, `confirmation_code`, `confirmation_time`, `popularity`, `is_active`, `created_at`, `updated_at`, `is_admin`, `role_id`, `profile_id`) VALUES
('John', 'Doe', 'johnny', 'password123', 1, 'john.doe@example.com', '1234567890', '123 Main St, Anytown, USA', '1980-01-01', NULL, NULL, 'ABCD1234', '2023-01-01 00:00:00', 50.00, 1, '2023-01-01 00:00:00', '2023-01-01 00:00:00', 0, 1, 1),
('Jane', 'Doe', 'jane', 'password456', 2, 'jane.doe@example.com', '0987654321', '456 Elm St, Anycity, USA', '1985-02-02', NULL, NULL, 'XYZ9876', '2023-02-02 00:00:00', 75.00, 1, '2023-02-02 00:00:00', '2023-02-02 00:00:00', 0, 2, 2),
('Bob', 'Smith', 'bobby', 'password789', 1, 'bob.smith@example.com', '1122334455', '789 Pine St, Somewhere, USA', '1990-03-03', NULL, NULL, 'QWER5678', '2023-03-03 00:00:00', 80.00, 1, '2023-03-03 00:00:00', '2023-03-03 00:00:00', 0, 3, 3);
-- query 
select * from users 





