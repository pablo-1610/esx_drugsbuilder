CREATE TABLE `drugs` (
  `id` int(11) NOT NULL,
  `createdBy` text NOT NULL,
  `createdAt` text NOT NULL,
  `label` varchar(50) NOT NULL,
  `drugsInfos` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `drugs`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `drugs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
