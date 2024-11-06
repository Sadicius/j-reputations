CREATE TABLE IF NOT EXISTS `reputations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `repType` varchar(50) NOT NULL,
  `reputationValue` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_rep` (`citizenid`,`repType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
