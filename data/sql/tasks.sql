DROP TABLE IF EXISTS `tasks`;

CREATE TABLE `tasks` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `status` TEXT NOT NULL DEFAULT 'stop',
    `name` TEXT DEFAULT NULL,
    `date_start` DATETIME DEFAULT NULL,
    `date_end` DATETIME DEFAULT NULL,
    `external_value` TEXT DEFAULT NULL
);
