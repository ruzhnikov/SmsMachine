DROP TABLE IF EXISTS `task_numbers`;

CREATE TABLE `task_numbers` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `task_id` INTEGER NOT NULL,
    `message_id` INTEGER NOT NULL,
    `number` TEXT NOT NULL,
    `status` TEXT NOT NULL DEFAULT 'stop',
    `repeat_count` INTEGER NOT NULL DEFAULT 0,
    `external_id` INTEGER DEFAULT NULL,
    `external_value` TEXT DEFAULT NULL
);
