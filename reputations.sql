CREATE TABLE IF NOT EXISTS `reputations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `repData` JSON NOT NULL, 
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_rep` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
