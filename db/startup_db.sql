CREATE DATABASE  IF NOT EXISTS `muses` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `muses`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win64 (x86_64)
--
-- Host: localhost    Database: muses
-- ------------------------------------------------------
-- Server version	5.6.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_request`
--

DROP TABLE IF EXISTS `access_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `access_request` (
  `access_request_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table SIMPLE_EVENTS(event_id)',
  `action` enum('DOWNLOAD_FILE','OPEN_APP','INSTALL_APP','OPEN_FILE') NOT NULL COMMENT 'Possible value of user actions for this concrete access request',
  `asset_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table ASSETS(asset_id)',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table USERS(user_id)',
  `decision_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Foreign key to the final decision associated to the access request, once the decision is taken. FK to table DECISIONS(decision_id)',
  `modification` datetime DEFAULT NULL COMMENT 'Time of detection of the access request',
  `threat_id` int(11) DEFAULT '0',
  `solved` int(11) DEFAULT '0',
  `user_action` int(11) DEFAULT '0',
  PRIMARY KEY (`access_request_id`),
  UNIQUE KEY `access-request-threat_id` (`threat_id`),
  KEY `access_request-simple_events:event_id_idx` (`decision_id`),
  KEY `access_request-assets:asset_id_idx` (`asset_id`),
  KEY `access_request-users:user_id_idx` (`user_id`),
  KEY `access_request-simple_events:event_id_idx1` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='Table which include any access request detected by the Event Processor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_request`
--

LOCK TABLES `access_request` WRITE;
/*!40000 ALTER TABLE `access_request` DISABLE KEYS */;
INSERT INTO `access_request` VALUES (80,2,'DOWNLOAD_FILE',1515,200,545,'2014-08-10 00:00:00',1,0,0);
/*!40000 ALTER TABLE `access_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `additional_protection`
--

DROP TABLE IF EXISTS `additional_protection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `additional_protection` (
  `additional_protection_id` int(20) unsigned NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Description of the additional protection',
  `access_request_id` int(10) unsigned DEFAULT '0' COMMENT 'FK to table ACCESS_REQUEST(access_request_id)',
  `event_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table EVENTS(event_id)',
  `device_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table DEVICES(device_id)',
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table USERS(user_id)',
  `modification` datetime DEFAULT NULL COMMENT 'Time of detection of the additional protection',
  PRIMARY KEY (`additional_protection_id`),
  KEY `additional_protection-access_request:access_request_id_idx` (`access_request_id`),
  KEY `additional_protection-simple_events:event_id_idx` (`event_id`),
  KEY `additional_protection-devices:device_id_idx` (`device_id`),
  KEY `additional_protection-users:user_id_idx` (`user_id`),
  CONSTRAINT `additional_protection-devices:device_id` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `additional_protection-simple_events:event_id` FOREIGN KEY (`event_id`) REFERENCES `simple_events` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `additional_protection-users:user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table which includes any additional protection detected by the Event Processor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `additional_protection`
--

LOCK TABLES `additional_protection` WRITE;
/*!40000 ALTER TABLE `additional_protection` DISABLE KEYS */;
/*!40000 ALTER TABLE `additional_protection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_type`
--

DROP TABLE IF EXISTS `app_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_type` (
  `app_type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL COMMENT 'Type of apps, such as "MAIL", "PDF_READER", "OFFICE", ...',
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`app_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1176 DEFAULT CHARSET=utf8 COMMENT='Table that simply describes the types of available applications.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_type`
--

LOCK TABLES `app_type` WRITE;
/*!40000 ALTER TABLE `app_type` DISABLE KEYS */;
INSERT INTO `app_type` VALUES (1174,'1174','desc'),(1175,'1175','desc');
/*!40000 ALTER TABLE `app_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications` (
  `app_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` bigint(20) DEFAULT NULL COMMENT 'FK to table APP_TYPE(app_type_id)',
  `name` varchar(30) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL COMMENT 'The current version of the application',
  `last_update` datetime DEFAULT NULL COMMENT 'Last update of application',
  `vendor` varchar(30) DEFAULT NULL COMMENT 'Vendor of the application',
  `is_MUSES_aware` int(11) DEFAULT '0' COMMENT 'If TRUE (1) -> the application can be monitored easily (it interacts with the system through the API)',
  PRIMARY KEY (`app_id`),
  KEY `app_type_id_idx` (`type`),
  CONSTRAINT `applications-app_type:app_type_id` FOREIGN KEY (`type`) REFERENCES `app_type` (`app_type_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8 COMMENT='As MUSES will have both black and white lists, a description of the different applications installed on a device can be found in this table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (117,1174,'musesawaew','desc','89','2014-08-15 00:00:00','android',0),(118,1175,'musesawarew','desc','89','2014-08-15 00:00:00','android',0),INSERT INTO `applications` VALUES (119,1174,'MUSES-Server','MUSES Server application','1','2014-08-15 00:00:00','ubuntu',0);
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `asset_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(30) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `value` double NOT NULL COMMENT 'represents the real value of the asset',
  `confidential_level` enum('PUBLIC','INTERNAL','CONFIDENTIAL','STRICTLYCONFIDENTIAL') NOT NULL,
  `location` varchar(100) NOT NULL COMMENT 'Location of the asset in the hard drive',
  PRIMARY KEY (`asset_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1655 DEFAULT CHARSET=utf8 COMMENT='This one will store all Assets data. All fields are defined in the table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'MusesBeerCompetition.txt','Beer Competition',1000,'INTERNAL','Sweden'),(2,'muses-server','MUSES Server',100000,'INTERNAL','Valencia'),(1515,'ttle','desc',1,'PUBLIC','sweden'),(1516,'title','desc',1,'PUBLIC','sweden'),(1520,'title','desc',200000,'PUBLIC','Sweden'),(1521,'title','desc',200000,'PUBLIC','Sweden'),(1522,'title','desc',200000,'PUBLIC','Sweden'),(1523,'title','desc',200000,'PUBLIC','Sweden'),(1524,'title','desc',200000,'PUBLIC','Sweden'),(1525,'title','desc',200000,'PUBLIC','Sweden'),(1526,'title','desc',200000,'PUBLIC','Sweden'),(1527,'title','desc',200000,'PUBLIC','Sweden'),(1528,'title','desc',200000,'PUBLIC','Sweden'),(1529,'title','desc',200000,'PUBLIC','Sweden'),(1530,'title','desc',200000,'PUBLIC','Sweden'),(1531,'title','desc',200000,'PUBLIC','Sweden'),(1532,'title','desc',200000,'PUBLIC','Sweden'),(1533,'title','desc',200000,'PUBLIC','Sweden'),(1534,'title','desc',200000,'PUBLIC','Sweden'),(1535,'title','desc',200000,'PUBLIC','Sweden'),(1536,'title','desc',200000,'PUBLIC','Sweden'),(1537,'title','desc',200000,'PUBLIC','Sweden'),(1538,'title','desc',200000,'PUBLIC','Sweden'),(1541,'test','test',0,'PUBLIC','test'),(1542,'Patent','Asset_Unige',0,'PUBLIC','C/documents/Unige/Muses'),(1543,'Patent','Asset_Unige',0,'PUBLIC','C/documents/Unige/Muses'),(1544,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1545,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1546,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1547,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1548,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1549,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1550,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1551,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1552,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1553,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1554,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1555,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1556,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1557,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1558,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1559,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1560,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1561,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1562,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1563,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1564,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1565,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1566,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1567,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1568,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1569,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1570,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1571,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1572,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1573,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1574,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1575,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1576,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1577,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1578,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1579,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1580,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1581,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1582,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1583,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1584,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1585,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1586,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1587,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1588,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1589,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1590,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1591,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1592,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1593,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1594,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1595,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1596,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1597,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1598,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1599,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1600,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1601,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1602,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1603,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1604,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1605,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1606,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1607,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1608,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1609,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1610,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1611,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1612,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1613,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1614,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1615,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1616,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1617,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1618,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1619,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1620,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1621,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1622,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1623,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1624,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1625,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1626,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1627,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1628,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1629,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1630,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1631,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1632,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1633,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1634,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1635,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1636,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1637,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1638,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1639,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1640,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1641,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1642,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1643,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1644,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1645,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1646,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1647,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1648,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1649,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1650,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1651,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1652,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1653,'Patent','Asset_Unige',0,'PUBLIC','Geneva'),(1654,'Patent','Asset_Unige',0,'PUBLIC','Geneva');
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clue`
--

DROP TABLE IF EXISTS `clue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clue` (
  `clue_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `value` longtext NOT NULL,
  PRIMARY KEY (`clue_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clue`
--

LOCK TABLES `clue` WRITE;
/*!40000 ALTER TABLE `clue` DISABLE KEYS */;
INSERT INTO `clue` VALUES (1,'Wi-FI'),(2,'Wi-FI'),(3,'Wi-FI'),(4,'Wi-FI'),(5,'Wi-FI'),(6,'Wi-FI'),(7,'Wi-FI'),(8,'Wi-FI'),(9,'Wi-FI'),(10,'Wi-FI'),(11,'Wi-FI'),(12,'Wi-FI'),(13,'Wi-FI'),(14,'Wi-FI'),(15,'Wi-FI'),(16,'Wi-FI'),(17,'Wi-FI'),(18,'Wi-FI'),(19,'Wi-FI'),(20,'Wi-FI'),(21,'Wi-FI'),(22,'Wi-FI'),(23,'Wi-FI'),(24,'Wi-FI'),(25,'Wi-FI'),(26,'Wi-FI'),(27,'Wi-FI'),(28,'Wi-FI'),(29,'Wi-FI'),(30,'Wi-FI'),(31,'Wi-FI'),(32,'Wi-FI'),(33,'Wi-FI'),(34,'Wi-FI'),(35,'Wi-FI'),(36,'Wi-FI'),(37,'Wi-FI'),(38,'Wi-FI'),(39,'Wi-FI'),(40,'Wi-FI'),(41,'Wi-FI'),(42,'Wi-FI'),(43,'Wi-FI'),(44,'Wi-FI'),(45,'Wi-FI'),(46,'Wi-FI'),(47,'Wi-FI'),(48,'Wi-FI'),(49,'Wi-FI'),(50,'Wi-FI'),(51,'Wi-FI'),(52,'Wi-FI'),(53,'Wi-FI'),(54,'Wi-FI'),(55,'Wi-FI'),(56,'Wi-FI'),(57,'Wi-FI'),(58,'Wi-FI'),(59,'Wi-FI'),(60,'Wi-FI'),(61,'Wi-FI'),(62,'Wi-FI'),(63,'Wi-FI'),(64,'Wi-FI'),(65,'Wi-FI'),(66,'Wi-FI'),(67,'Wi-FI'),(68,'Wi-FI'),(69,'Wi-FI'),(70,'Wi-FI'),(71,'Wi-FI'),(72,'Wi-FI'),(73,'Wi-FI'),(74,'Wi-FI'),(75,'Wi-FI'),(76,'Wi-FI'),(77,'Wi-FI'),(78,'Wi-FI'),(79,'Wi-FI');
/*!40000 ALTER TABLE `clue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `corporate_policies`
--

DROP TABLE IF EXISTS `corporate_policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `corporate_policies` (
  `corporate_policy_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(2000) NOT NULL COMMENT 'Policy subject',
  `description` varchar(2000) NOT NULL COMMENT 'Policy textual description',
  `file` blob NOT NULL COMMENT 'Policy formalized in standard format (XACML,JSON,...), to make it machine readable',
  `date` date NOT NULL COMMENT 'Date of creation of the policy',
  PRIMARY KEY (`corporate_policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table which contains the current set of corporate security policies, both containing textual descriptions and formalization files.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corporate_policies`
--

LOCK TABLES `corporate_policies` WRITE;
/*!40000 ALTER TABLE `corporate_policies` DISABLE KEYS */;
/*!40000 ALTER TABLE `corporate_policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `decision`
--

DROP TABLE IF EXISTS `decision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decision` (
  `decision_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `access_request_id` bigint(20) unsigned NOT NULL,
  `risk_communication_id` int(10) unsigned NOT NULL,
  `value` enum('GRANTED','STRONGDENY','MAYBE','UPTOYOU') NOT NULL,
  `time` datetime NOT NULL COMMENT 'When the decision was made',
  PRIMARY KEY (`decision_id`),
  KEY `decision-access_request:access_request_id_idx` (`access_request_id`),
  KEY `decision-risk_communication:risk_communication_id_idx` (`risk_communication_id`),
  CONSTRAINT `decision-access_request:access_request_id` FOREIGN KEY (`access_request_id`) REFERENCES `access_request` (`access_request_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `decision-risk_communication:risk_communication_id` FOREIGN KEY (`risk_communication_id`) REFERENCES `risk_communication` (`risk_communication_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=558 DEFAULT CHARSET=utf8 COMMENT='Table which stores all decision computed by the RT2AE. All fields are defined in the table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decision`
--

LOCK TABLES `decision` WRITE;
/*!40000 ALTER TABLE `decision` DISABLE KEYS */;
INSERT INTO `decision` VALUES (545,80,900,'GRANTED','2014-08-10 00:00:00'),(546,80,900,'GRANTED','2014-08-11 00:00:00'),(548,80,900,'GRANTED','2014-08-12 00:00:00'),(549,80,900,'GRANTED','2014-08-12 00:00:00'),(550,80,900,'GRANTED','2014-08-12 00:00:00'),(551,80,900,'GRANTED','2014-08-12 00:00:00'),(552,80,900,'GRANTED','2014-08-12 00:00:00'),(553,80,900,'GRANTED','2014-08-12 00:00:00'),(554,80,900,'GRANTED','2014-08-12 00:00:00'),(555,80,900,'GRANTED','2014-08-12 00:00:00'),(556,80,900,'GRANTED','2014-08-12 00:00:00'),(557,80,900,'GRANTED','2014-08-12 00:00:00');
/*!40000 ALTER TABLE `decision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_config`
--

DROP TABLE IF EXISTS `device_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_config` (
  `device_config_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_config_name` varchar(30) NOT NULL COMMENT 'Name of the configuration',
  `min_event_cache_size` int(10) unsigned NOT NULL DEFAULT '100' COMMENT 'Minimum number of events to be stored in the local cache',
  `max_request_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Maximum amount of milliseconds waiting for an answer from the server side',
  PRIMARY KEY (`device_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Device configuration parameters';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_config`
--

LOCK TABLES `device_config` WRITE;
/*!40000 ALTER TABLE `device_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_security_state`
--

DROP TABLE IF EXISTS `device_security_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_security_state` (
  `device_security_state_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`device_security_state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table will store the list of clue about the security state of the device. This table has been modified about the DeviceSecurityState';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_security_state`
--

LOCK TABLES `device_security_state` WRITE;
/*!40000 ALTER TABLE `device_security_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_security_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_type`
--

DROP TABLE IF EXISTS `device_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_type` (
  `device_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL COMMENT 'Types of devices, such as DESKTOP_PC, LAPTOP, TABLET, SMARTPHONE, PALM, PDA',
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`device_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1224 DEFAULT CHARSET=utf8 COMMENT='This table is directly related to the previous one, as it contains the information about the type of devices that can be registered in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_type`
--

LOCK TABLES `device_type` WRITE;
/*!40000 ALTER TABLE `device_type` DISABLE KEYS */;
INSERT INTO `device_type` VALUES (1222,'1222','device'),(1223,'1223','device');
/*!40000 ALTER TABLE `device_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `device_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `type` int(10) unsigned NOT NULL COMMENT 'FK to table DEVICE_TYPE(device_type_id)',
  `description` varchar(100) DEFAULT NULL,
  `IMEI` varchar(30) DEFAULT NULL COMMENT 'In the format XXXXXX YY ZZZZZZ W',
  `MAC` varchar(30) DEFAULT NULL COMMENT 'In the format FF:FF:FF:FF:FF:FF:FF:FF',
  `OS_name` varchar(30) DEFAULT NULL COMMENT 'The operating system of the device',
  `OS_version` varchar(20) DEFAULT NULL COMMENT 'The operating system of the device',
  `trust_value` double DEFAULT NULL COMMENT 'The trust value of the device will be between 0 and 1',
  `security_level` smallint(6) DEFAULT NULL COMMENT 'The security level of the device is based on the device security state',
  `certificate` blob,
  `owner_type` enum('COMPANY','USER') DEFAULT NULL,
  PRIMARY KEY (`device_id`),
  KEY `device_type_id_idx` (`type`),
  CONSTRAINT `devices-device_type:device_type_id` FOREIGN KEY (`type`) REFERENCES `device_type` (`device_type_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8 COMMENT='Table that has been created due to the importance of having a record of the different devices that are using company assets and the need of pairing a device with an owner. Like the users, the devices have also a defined trust value that may be changed by RT2AE decisions.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'server',1222,'MUSES Server','server','0','a','0',0,0,NULL,NULL),(201,'f',1222,'device','545','0','a','0',0,0,NULL,NULL),(202,'f',1223,'device','0454','0','a','0',0,0,NULL,NULL),(203,'e3da52dbe610b684',1222,NULL,'e3da52dbe610b684',NULL,NULL,NULL,0,0,NULL,NULL),(204,'9aa326e4fd9ccf61',1222,NULL,'9aa326e4fd9ccf61',NULL,NULL,NULL,0,0,NULL,NULL),(205,'36474929437562939',1222,NULL,'36474929437562939',NULL,NULL,NULL,0,0,NULL,NULL),(206,'358648051980583',1222,NULL,'358648051980583',NULL,NULL,NULL,0,0,NULL,NULL),(207,'f1fa4ef09df1d163',1222,NULL,'f1fa4ef09df1d163',NULL,NULL,NULL,0,0,NULL,NULL),(208,'afc398f33cad4e9e',1222,NULL,'afc398f33cad4e9e',NULL,NULL,NULL,0,0,NULL,NULL);
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictionary`
--

DROP TABLE IF EXISTS `dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dictionary` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_name` varchar(50) NOT NULL COMMENT 'Name of the term in the dictionary',
  `description` varchar(100) NOT NULL COMMENT 'Description of the term',
  `position` enum('ANTECEDENT','CONSEQUENT') NOT NULL COMMENT 'Position of the term in a rule',
  `type` varchar(30) NOT NULL COMMENT 'Type of the term',
  PRIMARY KEY (`term_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table which will store all the possible terms (and values) as potential antecedents and consequents for rules. Some of these terms will be automatically extracted from other tables, such as the TYPES_OF_APPS, APPLICATIONS names, USERS names, LOCATIONS, and so on.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictionary`
--

LOCK TABLES `dictionary` WRITE;
/*!40000 ALTER TABLE `dictionary` DISABLE KEYS */;
/*!40000 ALTER TABLE `dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domains`
--

DROP TABLE IF EXISTS `domains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domains` (
  `domain_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'Name of the domain (e.g. Offers)',
  `description` varchar(100) DEFAULT NULL COMMENT 'Domain description (e.g. Company domain used to store commercial offers to be presented to concrete customers. This kind of information is strictly confidential.)',
  `sensitivity_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Associated sensitivity level (strictly confidential, protected, public,...) FK to sensitivity table',
  PRIMARY KEY (`domain_id`),
  KEY `sensitivity_id_idx` (`sensitivity_id`),
  CONSTRAINT `domains-sensitivity:sensitivity_id` FOREIGN KEY (`sensitivity_id`) REFERENCES `sensitivity` (`sensitivity_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='Table which describes the different domains that might apply for different company resources. Depending on this domain, it will have a different sensitivity level.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domains`
--

LOCK TABLES `domains` WRITE;
/*!40000 ALTER TABLE `domains` DISABLE KEYS */;
INSERT INTO `domains` VALUES (7,'domain','desc',25);
/*!40000 ALTER TABLE `domains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_type`
--

DROP TABLE IF EXISTS `event_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_type` (
  `event_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_type_key` varchar(200) NOT NULL COMMENT 'Possible values are: {USER_ACTION,SENSOR_CONTEXT,USER_FEEDBACK} as simple events and {DECISION,THREAT_CLUE,ADDITIONAL_PROTECTION,SECURITY_INCIDENT,DEVICE_POLICY_UPDATE} as complex events',
  `event_level` varchar(200) NOT NULL COMMENT 'Possible values are: SIMPLE_EVENT (corresponding to events that are generated by monitoring, without server processing) and COMPLEX_EVENT (events generated from the correlation or aggregation of other simple events)',
  PRIMARY KEY (`event_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COMMENT='Table which describes the possible types of events';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_type`
--

LOCK TABLES `event_type` WRITE;
/*!40000 ALTER TABLE `event_type` DISABLE KEYS */;
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (1,'LOG_IN','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (2,'LOG_OUT','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (3,'START','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (4,'RESUME','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (5,'STOP','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (6,'RESTART','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (7,'ACTION_REMOTE_FILE_ACCESS','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (8,'CONTEXT_SENSOR_CONNECTIVITY','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (9,'CONTEXT_SENSOR_DEVICE_PROTECTION','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (10,'ACTION_APP_OPEN','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (11,'ACTION_SEND_MAIL','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (12,'VIRUS_FOUND','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (13,'VIRUS_CLEANED','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (14,'SECURITY_PROPERTY_CHANGED','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (15,'SAVE_ASSET','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (16,'CONTEXT_SENSOR_PACKAGE','SIMPLE_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (17,'SECURITY_VIOLATION','COMPLEX_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (18,'SECURITY_INCIDENT','COMPLEX_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (19,'CONFIGURATION_CHANGE','COMPLEX_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (20,'DECISION','COMPLEX_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (21,'DEVICE_POLICY_SENT','COMPLEX_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (22,'CLUE_DETECTED','COMPLEX_EVENT');
INSERT INTO `event_type` (`event_type_id`,`event_type_key`,`event_level`) VALUES (23,'CONTEXT_SENSOR_APP','SIMPLE_EVENT');
/*!40000 ALTER TABLE `event_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `legal_aspects`
--

DROP TABLE IF EXISTS `legal_aspects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `legal_aspects` (
  `description` varchar(50) NOT NULL,
  `KRS_hard_limit` int(10) unsigned NOT NULL DEFAULT '180' COMMENT 'Duration of data in days for the Knowledge Refinement System. Default=6 months',
  `RT2AE_hard_limit` int(10) unsigned NOT NULL DEFAULT '180' COMMENT 'Duration of data in days for the RT2AE. Default=6 months',
  `EP_hard_limit` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'Duration of data in days for the Event Processor. Default=6 months',
  `data_complete_erasure` binary(1) NOT NULL DEFAULT '1' COMMENT 'If ''1'' (TRUE) data will be completely removed from the database once the duration has expired.',
  PRIMARY KEY (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table containing data related with user''s privacy and legality in the system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `legal_aspects`
--

LOCK TABLES `legal_aspects` WRITE;
/*!40000 ALTER TABLE `legal_aspects` DISABLE KEYS */;
INSERT INTO `legal_aspects` VALUES ('15',20,1,2,'1');
/*!40000 ALTER TABLE `legal_aspects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `muses_config`
--

DROP TABLE IF EXISTS `muses_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `muses_config` (
  `config_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `config_name` varchar(30) NOT NULL COMMENT 'Name of the configuration',
  `access_attempts_before_blocking` int(10) unsigned NOT NULL DEFAULT '5',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='MUSES Server configuration parameters';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `muses_config`
--

LOCK TABLES `muses_config` WRITE;
/*!40000 ALTER TABLE `muses_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `muses_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outcome`
--

DROP TABLE IF EXISTS `outcome`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outcome` (
  `outcome_id` bigint(11) NOT NULL AUTO_INCREMENT,
  `description` longtext,
  `costbenefit` double DEFAULT NULL,
  `threat_id` bigint(20) NOT NULL,
  PRIMARY KEY (`outcome_id`),
  KEY `threat_outcome_link` (`threat_id`),
  CONSTRAINT `outcome_ibfk_1` FOREIGN KEY (`threat_id`) REFERENCES `threat` (`threat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=977 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outcome`
--

LOCK TABLES `outcome` WRITE;
/*!40000 ALTER TABLE `outcome` DISABLE KEYS */;
INSERT INTO `outcome` VALUES (1,'test',0,2),(2,'test',0,2),(5,'test',0,2),(6,'test',0,2),(7,'test',0,2),(8,'test',0,2),(9,'test',0,2),(10,'4134102403044',0,2),(11,'3430013324002',0,2),(12,'outcome',0,19),(13,'outcome',0,20),(14,'outcome',0,21),(15,'outcome',0,22),(16,'Compromised Asset',-1000000,23),(17,'outcome',0,2),(18,'outcome',0,2),(19,'outcome',0,24),(20,'Compromised Asset',-1000000,25),(21,'outcome',0,2),(22,'outcome',0,26),(23,'outcome',0,26),(24,'outcome',0,26),(25,'outcome',0,26),(26,'outcome',0,26),(27,'outcome',0,26),(28,'outcome',0,26),(29,'outcome',0,26),(30,'outcome',0,26),(31,'Compromised Asset',0,27),(32,'Compromised Asset',0,28),(33,'Compromised Asset',0,29),(34,'outcome',0,26),(35,'Compromised Asset',0,30),(36,'Compromised Asset',0,31),(37,'Compromised Asset',0,32),(38,'Compromised Asset',0,33),(39,'Compromised Asset',0,34),(40,'Compromised Asset',0,35),(41,'Compromised Asset',0,36),(42,'Compromised Asset',0,37),(43,'Compromised Asset',0,38),(44,'Compromised Asset',0,39),(45,'Compromised Asset',0,40),(46,'Compromised Asset',0,41),(47,'Compromised Asset',0,42),(48,'outcome',0,26),(49,'Compromised Asset',0,43),(50,'Compromised Asset',0,44),(51,'Compromised Asset',0,45),(52,'Compromised Asset',0,46),(53,'Compromised Asset',0,47),(54,'Compromised Asset',0,48),(55,'Compromised Asset',0,49),(56,'Compromised Asset',0,50),(57,'Compromised Asset',0,51),(58,'Compromised Asset',0,52),(59,'Compromised Asset',0,53),(60,'Compromised Asset',0,54),(61,'Compromised Asset',0,55),(62,'Compromised Asset',0,56),(63,'Compromised Asset',0,57),(64,'Compromised Asset',0,58),(65,'Compromised Asset',0,59),(66,'Compromised Asset',0,60),(67,'Compromised Asset',0,61),(68,'Compromised Asset',0,62),(69,'Compromised Asset',0,63),(70,'Compromised Asset',0,64),(71,'Compromised Asset',0,65),(72,'Compromised Asset',0,66),(73,'Compromised Asset',0,67),(74,'Compromised Asset',0,68),(75,'Compromised Asset',0,69),(76,'Compromised Asset',0,70),(77,'Compromised Asset',0,71),(78,'Compromised Asset',0,72),(79,'Compromised Asset',0,73),(80,'Compromised Asset',0,74),(81,'Compromised Asset',0,75),(82,'Compromised Asset',0,76),(83,'Compromised Asset',0,77),(84,'Compromised Asset',0,78),(85,'Compromised Asset',0,79),(86,'Compromised Asset',0,80),(87,'Compromised Asset',0,81),(88,'Compromised Asset',0,82),(89,'Compromised Asset',0,83),(90,'Compromised Asset',0,84),(91,'Compromised Asset',0,85),(92,'Compromised Asset',0,86),(93,'Compromised Asset',0,87),(94,'Compromised Asset',0,88),(95,'Compromised Asset',0,89),(96,'Compromised Asset',0,90),(97,'Compromised Asset',0,91),(98,'Compromised Asset',0,92),(99,'Compromised Asset',0,93),(100,'Compromised Asset',0,94),(101,'Compromised Asset',0,95),(102,'Compromised Asset',0,96),(103,'Compromised Asset',0,97),(104,'Compromised Asset',0,98),(105,'Compromised Asset',0,99),(106,'Compromised Asset',0,100),(107,'Compromised Asset',0,101),(108,'Compromised Asset',0,102),(109,'Compromised Asset',0,103),(110,'Compromised Asset',0,104),(111,'Compromised Asset',0,105),(112,'Compromised Asset',0,106),(113,'Compromised Asset',0,107),(114,'Compromised Asset',0,108),(115,'Compromised Asset',0,109),(116,'Compromised Asset',0,110),(117,'Compromised Asset',0,111),(118,'Compromised Asset',0,112),(119,'Compromised Asset',0,113),(120,'Compromised Asset',0,114),(121,'Compromised Asset',0,115),(122,'Compromised Asset',0,116),(123,'Compromised Asset',0,117),(124,'Compromised Asset',0,118),(125,'Compromised Asset',0,119),(126,'Compromised Asset',0,120),(127,'Compromised Asset',0,121),(128,'Compromised Asset',0,122),(129,'Compromised Asset',0,123),(130,'Compromised Asset',0,124),(131,'Compromised Asset',0,125),(132,'Compromised Asset',0,126),(133,'Compromised Asset',0,127),(134,'Compromised Asset',0,128),(135,'Compromised Asset',0,129),(136,'Compromised Asset',0,130),(137,'Compromised Asset',0,131),(138,'Compromised Asset',0,132),(139,'Compromised Asset',0,133),(140,'Compromised Asset',0,134),(141,'Compromised Asset',0,135),(142,'Compromised Asset',0,136),(143,'Compromised Asset',0,137),(144,'Compromised Asset',0,138),(145,'Compromised Asset',0,139),(146,'Compromised Asset',0,140),(147,'Compromised Asset',0,141),(148,'Compromised Asset',0,142),(149,'Compromised Asset',0,143),(150,'Compromised Asset',0,144),(151,'Compromised Asset',0,145),(152,'Compromised Asset',0,146),(153,'Compromised Asset',0,147),(154,'Compromised Asset',0,148),(155,'Compromised Asset',0,149),(156,'Compromised Asset',0,150),(157,'Compromised Asset',0,151),(158,'Compromised Asset',0,152),(159,'Compromised Asset',0,153),(160,'Compromised Asset',0,154),(161,'Compromised Asset',0,155),(162,'Compromised Asset',0,156),(163,'Compromised Asset',0,157),(164,'outcome',0,26),(165,'Compromised Asset',0,158),(166,'Compromised Asset',0,159),(167,'Compromised Asset',0,160),(168,'Compromised Asset',0,161),(169,'Compromised Asset',0,162),(170,'Compromised Asset',0,163),(171,'Compromised Asset',0,164),(172,'Compromised Asset',0,165),(173,'Compromised Asset',0,166),(174,'Compromised Asset',0,167),(175,'Compromised Asset',0,168),(176,'Compromised Asset',0,169),(177,'Compromised Asset',0,170),(178,'Compromised Asset',0,171),(179,'Compromised Asset',0,172),(180,'Compromised Asset',0,173),(181,'Compromised Asset',0,174),(182,'Compromised Asset',0,175),(183,'Compromised Asset',0,176),(184,'Compromised Asset',0,177),(185,'Compromised Asset',0,178),(186,'Compromised Asset',0,179),(187,'Compromised Asset',0,180),(188,'Compromised Asset',0,181),(189,'Compromised Asset',0,182),(190,'Compromised Asset',0,183),(191,'Compromised Asset',0,184),(192,'Compromised Asset',0,185),(193,'Compromised Asset',0,186),(194,'Compromised Asset',0,187),(195,'Compromised Asset',0,188),(196,'Compromised Asset',0,189),(197,'Compromised Asset',0,190),(198,'Compromised Asset',0,191),(199,'Compromised Asset',0,192),(200,'Compromised Asset',0,193),(201,'Compromised Asset',0,194),(202,'Compromised Asset',0,195),(203,'Compromised Asset',0,196),(204,'Compromised Asset',0,197),(205,'Compromised Asset',0,198),(206,'Compromised Asset',0,199),(207,'Compromised Asset',0,200),(208,'Compromised Asset',0,201),(209,'Compromised Asset',0,202),(210,'Compromised Asset',0,203),(211,'Compromised Asset',0,204),(212,'Compromised Asset',0,205),(213,'Compromised Asset',0,206),(214,'Compromised Asset',0,207),(215,'Compromised Asset',0,208),(216,'Compromised Asset',0,209),(217,'Compromised Asset',0,210),(218,'Compromised Asset',0,211),(219,'Compromised Asset',0,212),(220,'Compromised Asset',0,213),(221,'Compromised Asset',0,214),(222,'Compromised Asset',0,215),(223,'Compromised Asset',0,216),(224,'Compromised Asset',0,217),(225,'Compromised Asset',0,218),(226,'Compromised Asset',0,219),(227,'Compromised Asset',0,220),(228,'Compromised Asset',0,221),(229,'Compromised Asset',0,222),(230,'Compromised Asset',0,223),(231,'Compromised Asset',0,224),(232,'Compromised Asset',0,225),(233,'Compromised Asset',0,226),(234,'Compromised Asset',0,227),(235,'Compromised Asset',0,228),(236,'Compromised Asset',0,229),(237,'Compromised Asset',0,230),(238,'Compromised Asset',0,231),(239,'Compromised Asset',0,232),(240,'Compromised Asset',0,233),(241,'Compromised Asset',0,234),(242,'Compromised Asset',0,235),(243,'Compromised Asset',0,236),(244,'Compromised Asset',0,237),(245,'Compromised Asset',0,238),(246,'Compromised Asset',0,239),(247,'Compromised Asset',0,240),(248,'Compromised Asset',0,241),(249,'Compromised Asset',0,242),(250,'Compromised Asset',0,243),(251,'Compromised Asset',0,244),(252,'Compromised Asset',0,245),(253,'Compromised Asset',0,246),(254,'Compromised Asset',0,247),(255,'Compromised Asset',0,248),(256,'Compromised Asset',0,249),(257,'Compromised Asset',0,250),(258,'Compromised Asset',0,251),(259,'Compromised Asset',0,252),(260,'Compromised Asset',0,253),(261,'Compromised Asset',0,254),(262,'Compromised Asset',0,255),(263,'Compromised Asset',0,256),(264,'Compromised Asset',0,257),(265,'Compromised Asset',0,258),(266,'Compromised Asset',0,259),(267,'Compromised Asset',0,260),(268,'Compromised Asset',0,261),(269,'Compromised Asset',0,262),(270,'Compromised Asset',0,263),(271,'Compromised Asset',0,264),(272,'Compromised Asset',0,265),(273,'Compromised Asset',0,266),(274,'Compromised Asset',0,267),(275,'Compromised Asset',0,268),(276,'Compromised Asset',0,269),(277,'Compromised Asset',0,270),(278,'Compromised Asset',0,271),(279,'Compromised Asset',0,272),(280,'Compromised Asset',0,273),(281,'Compromised Asset',0,274),(282,'Compromised Asset',0,275),(283,'Compromised Asset',0,276),(284,'Compromised Asset',0,277),(285,'Compromised Asset',0,278),(286,'Compromised Asset',0,279),(287,'Compromised Asset',0,280),(288,'Compromised Asset',0,281),(289,'Compromised Asset',0,282),(290,'Compromised Asset',0,283),(291,'Compromised Asset',0,284),(292,'Compromised Asset',0,285),(293,'Compromised Asset',0,286),(294,'Compromised Asset',0,287),(295,'Compromised Asset',0,288),(296,'Compromised Asset',0,289),(297,'Compromised Asset',0,290),(298,'Compromised Asset',0,291),(299,'Compromised Asset',0,292),(300,'Compromised Asset',0,293),(301,'Compromised Asset',0,294),(302,'Compromised Asset',0,295),(303,'Compromised Asset',0,296),(304,'Compromised Asset',0,297),(305,'Compromised Asset',0,298),(306,'Compromised Asset',0,299),(307,'Compromised Asset',0,300),(308,'Compromised Asset',0,301),(309,'Compromised Asset',0,302),(310,'Compromised Asset',0,303),(311,'Compromised Asset',0,304),(312,'Compromised Asset',0,305),(313,'Compromised Asset',0,306),(314,'Compromised Asset',0,307),(315,'Compromised Asset',0,308),(316,'Compromised Asset',0,309),(317,'Compromised Asset',0,310),(318,'Compromised Asset',0,311),(319,'Compromised Asset',0,312),(320,'Compromised Asset',0,313),(321,'Compromised Asset',0,314),(322,'Compromised Asset',0,315),(323,'Compromised Asset',0,316),(324,'Compromised Asset',0,317),(325,'Compromised Asset',0,318),(326,'Compromised Asset',0,319),(327,'Compromised Asset',0,320),(328,'Compromised Asset',0,321),(329,'Compromised Asset',0,322),(330,'Compromised Asset',0,323),(331,'Compromised Asset',0,324),(332,'Compromised Asset',0,325),(333,'Compromised Asset',0,326),(334,'Compromised Asset',0,327),(335,'Compromised Asset',0,328),(336,'Compromised Asset',0,329),(337,'Compromised Asset',0,330),(338,'Compromised Asset',0,331),(339,'Compromised Asset',0,332),(340,'Compromised Asset',0,333),(341,'Compromised Asset',0,334),(342,'Compromised Asset',0,335),(343,'Compromised Asset',0,336),(344,'Compromised Asset',0,337),(345,'Compromised Asset',0,338),(346,'Compromised Asset',0,339),(347,'Compromised Asset',0,340),(348,'Compromised Asset',0,341),(349,'Compromised Asset',0,342),(350,'Compromised Asset',0,343),(351,'Compromised Asset',0,344),(352,'Compromised Asset',0,345),(353,'Compromised Asset',0,346),(354,'Compromised Asset',0,347),(355,'Compromised Asset',0,348),(356,'Compromised Asset',0,349),(357,'Compromised Asset',0,350),(358,'Compromised Asset',0,351),(359,'Compromised Asset',0,352),(360,'Compromised Asset',0,353),(361,'Compromised Asset',0,354),(362,'Compromised Asset',0,355),(363,'Compromised Asset',0,356),(364,'Compromised Asset',0,357),(365,'Compromised Asset',0,358),(366,'Compromised Asset',0,359),(367,'Compromised Asset',0,360),(368,'Compromised Asset',0,361),(369,'Compromised Asset',0,362),(370,'Compromised Asset',0,363),(371,'Compromised Asset',0,364),(372,'Compromised Asset',0,365),(373,'Compromised Asset',0,366),(374,'Compromised Asset',0,367),(375,'Compromised Asset',0,368),(376,'Compromised Asset',0,369),(377,'Compromised Asset',0,370),(378,'Compromised Asset',0,371),(379,'Compromised Asset',0,372),(380,'outcome',0,26),(381,'Compromised Asset',0,373),(382,'Compromised Asset',0,374),(383,'Compromised Asset',0,375),(384,'Compromised Asset',0,376),(385,'Compromised Asset',0,377),(386,'Compromised Asset',0,378),(387,'Compromised Asset',0,379),(388,'Compromised Asset',0,380),(389,'Compromised Asset',0,381),(390,'Compromised Asset',0,382),(391,'Compromised Asset',0,383),(392,'Compromised Asset',0,384),(393,'Compromised Asset',0,385),(394,'Compromised Asset',0,386),(395,'Compromised Asset',0,387),(396,'Compromised Asset',0,388),(397,'Compromised Asset',0,389),(398,'Compromised Asset',0,390),(399,'Compromised Asset',0,391),(400,'Compromised Asset',0,392),(401,'Compromised Asset',0,393),(402,'Compromised Asset',0,394),(403,'outcome',0,26),(404,'Compromised Asset',0,395),(405,'Compromised Asset',0,396),(406,'Compromised Asset',0,397),(407,'Compromised Asset',0,398),(408,'Compromised Asset',0,399),(409,'Compromised Asset',0,400),(410,'Compromised Asset',0,401),(411,'Compromised Asset',0,402),(412,'Compromised Asset',0,403),(413,'Compromised Asset',0,404),(414,'Compromised Asset',0,405),(415,'Compromised Asset',0,406),(416,'Compromised Asset',0,407),(417,'Compromised Asset',0,408),(418,'Compromised Asset',0,409),(419,'Compromised Asset',0,410),(420,'Compromised Asset',0,411),(421,'Compromised Asset',0,412),(422,'Compromised Asset',0,413),(423,'Compromised Asset',0,414),(424,'Compromised Asset',0,415),(425,'Compromised Asset',0,416),(426,'Compromised Asset',0,417),(427,'Compromised Asset',0,418),(428,'Compromised Asset',0,419),(429,'Compromised Asset',0,420),(430,'Compromised Asset',0,421),(431,'Compromised Asset',0,422),(432,'Compromised Asset',0,423),(433,'Compromised Asset',0,424),(434,'Compromised Asset',0,425),(435,'Compromised Asset',0,426),(436,'Compromised Asset',0,427),(437,'Compromised Asset',0,428),(438,'Compromised Asset',0,429),(439,'Compromised Asset',0,430),(440,'Compromised Asset',0,431),(441,'Compromised Asset',0,432),(442,'Compromised Asset',0,433),(443,'Compromised Asset',0,434),(444,'Compromised Asset',0,435),(445,'Compromised Asset',0,436),(446,'Compromised Asset',0,437),(447,'Compromised Asset',0,438),(448,'Compromised Asset',0,439),(449,'Compromised Asset',0,440),(450,'Compromised Asset',0,441),(451,'Compromised Asset',0,442),(452,'Compromised Asset',0,443),(453,'Compromised Asset',0,444),(454,'Compromised Asset',0,445),(455,'outcome',0,26),(456,'Compromised Asset',0,446),(457,'Compromised Asset',0,447),(458,'Compromised Asset',0,448),(459,'Compromised Asset',0,449),(460,'Compromised Asset',0,450),(461,'Compromised Asset',0,451),(462,'Compromised Asset',0,452),(463,'Compromised Asset',0,453),(464,'Compromised Asset',0,454),(465,'Compromised Asset',0,455),(466,'Compromised Asset',0,456),(467,'Compromised Asset',0,457),(468,'Compromised Asset',0,458),(469,'Compromised Asset',0,459),(470,'Compromised Asset',0,460),(471,'Compromised Asset',0,461),(472,'Compromised Asset',0,462),(473,'Compromised Asset',0,463),(474,'Compromised Asset',0,464),(475,'Compromised Asset',0,465),(476,'Compromised Asset',0,466),(477,'Compromised Asset',0,467),(478,'Compromised Asset',0,468),(479,'Compromised Asset',0,469),(480,'Compromised Asset',0,470),(481,'Compromised Asset',0,471),(482,'Compromised Asset',0,472),(483,'Compromised Asset',0,473),(484,'Compromised Asset',0,474),(485,'Compromised Asset',0,475),(486,'Compromised Asset',0,476),(487,'Compromised Asset',0,477),(488,'Compromised Asset',0,478),(489,'Compromised Asset',0,479),(490,'Compromised Asset',0,480),(491,'Compromised Asset',0,481),(492,'Compromised Asset',0,482),(493,'Compromised Asset',0,483),(494,'Compromised Asset',0,484),(495,'Compromised Asset',0,485),(496,'Compromised Asset',0,486),(497,'Compromised Asset',0,487),(498,'Compromised Asset',0,488),(499,'Compromised Asset',0,489),(500,'Compromised Asset',0,490),(501,'Compromised Asset',0,491),(502,'Compromised Asset',0,492),(503,'Compromised Asset',0,493),(504,'Compromised Asset',0,494),(505,'Compromised Asset',0,495),(506,'Compromised Asset',0,496),(507,'outcome',0,26),(508,'Compromised Asset',0,497),(509,'Compromised Asset',0,498),(510,'Compromised Asset',0,499),(511,'Compromised Asset',0,500),(512,'Compromised Asset',0,501),(513,'Compromised Asset',0,502),(514,'Compromised Asset',0,503),(515,'Compromised Asset',0,504),(516,'Compromised Asset',0,505),(517,'Compromised Asset',0,506),(518,'Compromised Asset',0,507),(519,'Compromised Asset',0,508),(520,'Compromised Asset',0,509),(521,'Compromised Asset',0,510),(522,'Compromised Asset',0,511),(523,'Compromised Asset',0,512),(524,'Compromised Asset',0,513),(525,'outcome',0,26),(526,'Compromised Asset',0,514),(527,'Compromised Asset',0,515),(528,'Compromised Asset',0,516),(529,'Compromised Asset',0,517),(530,'Compromised Asset',0,518),(531,'Compromised Asset',0,519),(532,'Compromised Asset',0,520),(533,'Compromised Asset',0,521),(534,'Compromised Asset',0,522),(535,'Compromised Asset',0,523),(536,'Compromised Asset',0,524),(537,'Compromised Asset',0,525),(538,'Compromised Asset',0,526),(539,'Compromised Asset',0,527),(540,'Compromised Asset',0,528),(541,'Compromised Asset',0,529),(542,'Compromised Asset',0,530),(543,'Compromised Asset',0,531),(544,'Compromised Asset',0,532),(545,'Compromised Asset',0,533),(546,'Compromised Asset',0,534),(547,'Compromised Asset',0,535),(548,'Compromised Asset',0,536),(549,'Compromised Asset',0,537),(550,'Compromised Asset',0,538),(551,'Compromised Asset',0,539),(552,'Compromised Asset',0,540),(553,'Compromised Asset',0,541),(554,'Compromised Asset',0,542),(555,'Compromised Asset',0,543),(556,'Compromised Asset',0,544),(557,'Compromised Asset',0,545),(558,'Compromised Asset',0,546),(559,'Compromised Asset',0,547),(560,'Compromised Asset',0,548),(561,'Compromised Asset',0,549),(562,'Compromised Asset',0,550),(563,'Compromised Asset',0,551),(564,'Compromised Asset',0,552),(565,'Compromised Asset',0,553),(566,'Compromised Asset',0,554),(567,'Compromised Asset',0,555),(568,'Compromised Asset',0,556),(569,'Compromised Asset',0,557),(570,'Compromised Asset',0,558),(571,'Compromised Asset',0,559),(572,'Compromised Asset',0,560),(573,'Compromised Asset',0,561),(574,'Compromised Asset',0,562),(575,'Compromised Asset',0,563),(576,'Compromised Asset',0,564),(577,'Compromised Asset',0,565),(578,'Compromised Asset',0,566),(579,'Compromised Asset',0,567),(580,'Compromised Asset',0,568),(581,'Compromised Asset',0,569),(582,'Compromised Asset',0,570),(583,'Compromised Asset',0,571),(584,'Compromised Asset',0,572),(585,'Compromised Asset',0,573),(586,'Compromised Asset',0,574),(587,'Compromised Asset',0,575),(588,'Compromised Asset',0,576),(589,'Compromised Asset',0,577),(590,'Compromised Asset',0,578),(591,'Compromised Asset',0,579),(592,'Compromised Asset',0,580),(593,'Compromised Asset',0,581),(594,'Compromised Asset',0,582),(595,'Compromised Asset',0,583),(596,'Compromised Asset',0,584),(597,'Compromised Asset',0,585),(598,'outcome',0,26),(599,'Compromised Asset',0,586),(600,'Compromised Asset',0,587),(601,'Compromised Asset',0,588),(602,'Compromised Asset',0,589),(603,'Compromised Asset',0,590),(604,'Compromised Asset',0,591),(605,'Compromised Asset',0,592),(606,'Compromised Asset',0,593),(607,'Compromised Asset',0,594),(608,'Compromised Asset',0,595),(609,'Compromised Asset',0,596),(610,'Compromised Asset',0,597),(611,'outcome',0,26),(612,'Compromised Asset',0,598),(613,'Compromised Asset',0,599),(614,'Compromised Asset',0,600),(615,'Compromised Asset',0,601),(616,'Compromised Asset',0,602),(617,'Compromised Asset',0,603),(618,'Compromised Asset',0,604),(619,'Compromised Asset',0,605),(620,'Compromised Asset',0,606),(621,'Compromised Asset',0,607),(622,'Compromised Asset',0,608),(623,'Compromised Asset',0,609),(624,'Compromised Asset',0,610),(625,'Compromised Asset',0,611),(626,'Compromised Asset',0,612),(627,'outcome',0,26),(628,'Compromised Asset',0,613),(629,'Compromised Asset',0,614),(630,'Compromised Asset',0,615),(631,'Compromised Asset',0,616),(632,'Compromised Asset',0,617),(633,'Compromised Asset',0,618),(634,'Compromised Asset',0,619),(635,'Compromised Asset',0,620),(636,'Compromised Asset',0,621),(637,'Compromised Asset',0,622),(638,'Compromised Asset',0,623),(639,'Compromised Asset',0,624),(640,'Compromised Asset',0,625),(641,'Compromised Asset',0,626),(642,'Compromised Asset',0,627),(643,'Compromised Asset',0,628),(644,'Compromised Asset',0,629),(645,'Compromised Asset',0,630),(646,'Compromised Asset',0,631),(647,'Compromised Asset',0,632),(648,'Compromised Asset',0,633),(649,'Compromised Asset',0,634),(650,'Compromised Asset',0,635),(651,'Compromised Asset',0,636),(652,'Compromised Asset',0,637),(653,'Compromised Asset',0,638),(654,'Compromised Asset',0,639),(655,'outcome',0,26),(656,'Compromised Asset',0,640),(657,'Compromised Asset',0,641),(658,'Compromised Asset',0,642),(659,'Compromised Asset',0,643),(660,'Compromised Asset',0,644),(661,'Compromised Asset',0,645),(662,'outcome',0,26),(663,'Compromised Asset',0,646),(664,'Compromised Asset',0,647),(665,'Compromised Asset',0,648),(666,'Compromised Asset',0,649),(667,'Compromised Asset',0,650),(668,'Compromised Asset',0,651),(669,'Compromised Asset',0,652),(670,'Compromised Asset',0,653),(671,'Compromised Asset',0,654),(672,'Compromised Asset',0,655),(673,'Compromised Asset',0,656),(674,'Compromised Asset',0,657),(675,'Compromised Asset',0,658),(676,'Compromised Asset',0,659),(677,'Compromised Asset',0,660),(678,'outcome',0,26),(679,'Compromised Asset',0,661),(680,'Compromised Asset',0,662),(681,'Compromised Asset',0,663),(682,'Compromised Asset',0,664),(683,'Compromised Asset',0,665),(684,'Compromised Asset',0,666),(685,'Compromised Asset',0,667),(686,'Compromised Asset',0,668),(687,'Compromised Asset',0,669),(688,'Compromised Asset',0,670),(689,'Compromised Asset',0,671),(690,'Compromised Asset',0,672),(691,'Compromised Asset',0,673),(692,'outcome',0,26),(693,'Compromised Asset',0,674),(694,'Compromised Asset',0,675),(695,'Compromised Asset',0,676),(696,'Compromised Asset',0,677),(697,'Compromised Asset',0,678),(698,'Compromised Asset',0,679),(699,'Compromised Asset',0,680),(700,'Compromised Asset',0,681),(701,'Compromised Asset',0,682),(702,'Compromised Asset',0,683),(703,'Compromised Asset',0,684),(704,'Compromised Asset',0,685),(705,'outcome',0,26),(706,'Compromised Asset',0,686),(707,'Compromised Asset',0,687),(708,'Compromised Asset',0,688),(709,'Compromised Asset',0,689),(710,'Compromised Asset',0,690),(711,'Compromised Asset',0,691),(712,'outcome',0,26),(713,'Compromised Asset',0,692),(714,'Compromised Asset',0,693),(715,'Compromised Asset',0,694),(716,'Compromised Asset',0,695),(717,'Compromised Asset',0,696),(718,'Compromised Asset',0,697),(719,'Compromised Asset',0,698),(720,'Compromised Asset',0,699),(721,'Compromised Asset',0,700),(722,'Compromised Asset',0,701),(723,'Compromised Asset',0,702),(724,'Compromised Asset',0,703),(725,'Compromised Asset',0,704),(726,'Compromised Asset',0,705),(727,'Compromised Asset',0,706),(728,'Compromised Asset',0,707),(729,'Compromised Asset',0,708),(730,'Compromised Asset',0,709),(731,'Compromised Asset',0,710),(732,'Compromised Asset',0,711),(733,'Compromised Asset',0,712),(734,'Compromised Asset',0,713),(735,'Compromised Asset',0,714),(736,'Compromised Asset',0,715),(737,'Compromised Asset',0,716),(738,'Compromised Asset',0,717),(739,'Compromised Asset',0,718),(740,'Compromised Asset',0,719),(741,'Compromised Asset',0,720),(742,'Compromised Asset',0,721),(743,'Compromised Asset',0,722),(744,'Compromised Asset',0,723),(745,'Compromised Asset',0,724),(746,'Compromised Asset',0,725),(747,'Compromised Asset',0,726),(748,'Compromised Asset',0,727),(749,'Compromised Asset',0,728),(750,'Compromised Asset',0,729),(751,'Compromised Asset',0,730),(752,'Compromised Asset',0,731),(753,'Compromised Asset',0,732),(754,'Compromised Asset',0,733),(755,'Compromised Asset',0,734),(756,'Compromised Asset',0,735),(757,'Compromised Asset',0,736),(758,'Compromised Asset',0,737),(759,'Compromised Asset',0,738),(760,'Compromised Asset',0,739),(761,'Compromised Asset',0,740),(762,'Compromised Asset',0,741),(763,'Compromised Asset',0,742),(764,'Compromised Asset',0,743),(765,'Compromised Asset',0,744),(766,'Compromised Asset',0,745),(767,'Compromised Asset',0,746),(768,'Compromised Asset',0,747),(769,'Compromised Asset',0,748),(770,'Compromised Asset',0,749),(771,'Compromised Asset',0,750),(772,'Compromised Asset',0,751),(773,'Compromised Asset',0,752),(774,'Compromised Asset',0,753),(775,'Compromised Asset',0,754),(776,'Compromised Asset',0,755),(777,'Compromised Asset',0,756),(778,'Compromised Asset',0,757),(779,'Compromised Asset',0,758),(780,'Compromised Asset',0,759),(781,'Compromised Asset',0,760),(782,'Compromised Asset',0,761),(783,'Compromised Asset',0,762),(784,'Compromised Asset',0,763),(785,'Compromised Asset',0,764),(786,'Compromised Asset',0,765),(787,'Compromised Asset',0,766),(788,'Compromised Asset',0,767),(789,'Compromised Asset',0,768),(790,'Compromised Asset',0,769),(791,'Compromised Asset',0,770),(792,'Compromised Asset',0,771),(793,'Compromised Asset',0,772),(794,'Compromised Asset',0,773),(795,'Compromised Asset',0,774),(796,'Compromised Asset',0,775),(797,'Compromised Asset',0,776),(798,'Compromised Asset',0,777),(799,'Compromised Asset',0,778),(800,'Compromised Asset',0,779),(801,'Compromised Asset',0,780),(802,'Compromised Asset',0,781),(803,'Compromised Asset',0,782),(804,'Compromised Asset',0,783),(805,'Compromised Asset',0,784),(806,'Compromised Asset',0,785),(807,'Compromised Asset',0,786),(808,'Compromised Asset',0,787),(809,'Compromised Asset',0,788),(810,'Compromised Asset',0,789),(811,'Compromised Asset',0,790),(812,'Compromised Asset',0,791),(813,'Compromised Asset',0,792),(814,'Compromised Asset',0,793),(815,'Compromised Asset',0,794),(816,'Compromised Asset',0,795),(817,'Compromised Asset',0,796),(818,'Compromised Asset',0,797),(819,'Compromised Asset',0,798),(820,'Compromised Asset',0,799),(821,'Compromised Asset',0,800),(822,'Compromised Asset',0,801),(823,'Compromised Asset',0,802),(824,'Compromised Asset',0,803),(825,'Compromised Asset',0,804),(826,'Compromised Asset',0,805),(827,'Compromised Asset',0,806),(828,'Compromised Asset',0,807),(829,'Compromised Asset',0,808),(830,'Compromised Asset',0,809),(831,'Compromised Asset',0,810),(832,'Compromised Asset',0,811),(833,'Compromised Asset',0,812),(834,'Compromised Asset',0,813),(835,'Compromised Asset',0,814),(836,'Compromised Asset',0,815),(837,'Compromised Asset',0,816),(838,'Compromised Asset',0,817),(839,'Compromised Asset',0,818),(840,'Compromised Asset',0,819),(841,'Compromised Asset',0,820),(842,'Compromised Asset',0,821),(843,'Compromised Asset',0,822),(844,'Compromised Asset',0,823),(845,'Compromised Asset',0,824),(846,'Compromised Asset',0,825),(847,'Compromised Asset',0,826),(848,'Compromised Asset',0,827),(849,'Compromised Asset',0,828),(850,'Compromised Asset',0,829),(851,'Compromised Asset',0,830),(852,'Compromised Asset',0,831),(853,'Compromised Asset',0,832),(854,'Compromised Asset',0,833),(855,'Compromised Asset',0,834),(856,'Compromised Asset',0,835),(857,'Compromised Asset',0,836),(858,'Compromised Asset',0,837),(859,'Compromised Asset',0,838),(860,'Compromised Asset',0,839),(861,'Compromised Asset',0,840),(862,'Compromised Asset',0,841),(863,'Compromised Asset',0,842),(864,'Compromised Asset',0,843),(865,'Compromised Asset',0,844),(866,'Compromised Asset',0,845),(867,'Compromised Asset',0,846),(868,'Compromised Asset',0,847),(869,'Compromised Asset',0,848),(870,'Compromised Asset',0,849),(871,'Compromised Asset',0,850),(872,'Compromised Asset',0,851),(873,'Compromised Asset',0,852),(874,'Compromised Asset',0,853),(875,'Compromised Asset',0,854),(876,'Compromised Asset',0,855),(877,'Compromised Asset',0,856),(878,'Compromised Asset',0,857),(879,'Compromised Asset',0,858),(880,'Compromised Asset',0,859),(881,'Compromised Asset',0,860),(882,'Compromised Asset',0,861),(883,'Compromised Asset',0,862),(884,'Compromised Asset',0,863),(885,'Compromised Asset',0,864),(886,'Compromised Asset',0,865),(887,'Compromised Asset',0,866),(888,'Compromised Asset',0,867),(889,'Compromised Asset',0,868),(890,'Compromised Asset',0,869),(891,'Compromised Asset',0,870),(892,'Compromised Asset',0,871),(893,'Compromised Asset',0,872),(894,'Compromised Asset',0,873),(895,'Compromised Asset',0,874),(896,'Compromised Asset',0,875),(897,'Compromised Asset',0,876),(898,'Compromised Asset',0,877),(899,'Compromised Asset',0,878),(900,'Compromised Asset',0,879),(901,'Compromised Asset',0,880),(902,'Compromised Asset',0,881),(903,'Compromised Asset',0,882),(904,'Compromised Asset',0,883),(905,'Compromised Asset',0,884),(906,'Compromised Asset',0,885),(907,'Compromised Asset',0,886),(908,'Compromised Asset',0,887),(909,'Compromised Asset',0,888),(910,'Compromised Asset',0,889),(911,'Compromised Asset',0,890),(912,'Compromised Asset',0,891),(913,'Compromised Asset',0,892),(914,'Compromised Asset',0,893),(915,'Compromised Asset',0,894),(916,'Compromised Asset',0,895),(917,'Compromised Asset',0,896),(918,'Compromised Asset',0,897),(919,'Compromised Asset',0,898),(920,'Compromised Asset',0,899),(921,'Compromised Asset',0,900),(922,'Compromised Asset',0,901),(923,'Compromised Asset',0,902),(924,'Compromised Asset',0,903),(925,'Compromised Asset',0,904),(926,'Compromised Asset',0,905),(927,'Compromised Asset',0,906),(928,'Compromised Asset',0,907),(929,'Compromised Asset',0,908),(930,'Compromised Asset',0,909),(931,'Compromised Asset',0,910),(932,'outcome',0,26),(933,'Compromised Asset',0,911),(934,'Compromised Asset',0,912),(935,'Compromised Asset',0,913),(936,'Compromised Asset',0,914),(937,'Compromised Asset',0,915),(938,'Compromised Asset',0,916),(939,'Compromised Asset',0,917),(940,'Compromised Asset',0,918),(941,'Compromised Asset',0,919),(942,'Compromised Asset',0,920),(943,'Compromised Asset',0,921),(944,'Compromised Asset',0,922),(945,'Compromised Asset',0,923),(946,'outcome',0,26),(947,'Compromised Asset',0,924),(948,'Compromised Asset',0,925),(949,'Compromised Asset',0,926),(950,'Compromised Asset',0,927),(951,'Compromised Asset',0,928),(952,'Compromised Asset',0,929),(953,'outcome',0,26),(954,'Compromised Asset',0,930),(955,'Compromised Asset',0,931),(956,'Compromised Asset',0,932),(957,'Compromised Asset',0,933),(958,'Compromised Asset',0,934),(959,'Compromised Asset',0,935),(960,'Compromised Asset',0,936),(961,'Compromised Asset',0,937),(962,'Compromised Asset',0,938),(963,'Compromised Asset',0,939),(964,'Compromised Asset',0,940),(965,'Compromised Asset',0,941),(966,'outcome',0,26),(967,'Compromised Asset',0,942),(968,'Compromised Asset',0,943),(969,'Compromised Asset',0,944),(970,'Compromised Asset',0,945),(971,'Compromised Asset',0,946),(972,'Compromised Asset',0,947),(973,'outcome',0,26),(974,'Compromised Asset',0,948),(975,'Compromised Asset',0,949),(976,'Compromised Asset',0,950);
/*!40000 ALTER TABLE `outcome` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refined_security_rules`
--

DROP TABLE IF EXISTS `refined_security_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refined_security_rules` (
  `refined_security_rules_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `original_security_rule_id` bigint(20) unsigned NOT NULL COMMENT 'Initial security rule which was refined. If it has been inferred this field will be empty.',
  `name` varchar(2000) NOT NULL COMMENT 'If it is a refinement, the name will be the original name + "REFINED"',
  `file` blob COMMENT 'File in DRL format, containing the rule''s code, to make it machine readable',
  `status` enum('PROPOSED','VALIDATED','EXPIRED') NOT NULL COMMENT 'Current status of the rule. VALIDATED means that the CSO has approved this rule, so it can be inserted into the SECURITY_RULES table',
  `modification` datetime NOT NULL COMMENT 'Date of creation/modification of the rule',
  PRIMARY KEY (`refined_security_rules_id`),
  KEY `refined_security_rules-security_rules:security_rule_id_idx` (`original_security_rule_id`),
  CONSTRAINT `refined_security_rules-security_rules:security_rule_id` FOREIGN KEY (`original_security_rule_id`) REFERENCES `security_rules` (`security_rule_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Table which contains the potential set of security rules improved or inferred by the KRS.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refined_security_rules`
--

LOCK TABLES `refined_security_rules` WRITE;
/*!40000 ALTER TABLE `refined_security_rules` DISABLE KEYS */;
INSERT INTO `refined_security_rules` VALUES (1,800,'name',NULL,'VALIDATED','2014-05-15 00:00:00');
/*!40000 ALTER TABLE `refined_security_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_communication`
--

DROP TABLE IF EXISTS `risk_communication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risk_communication` (
  `risk_communication_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL COMMENT 'Textual description of the risk communication',
  PRIMARY KEY (`risk_communication_id`)
) ENGINE=InnoDB AUTO_INCREMENT=901 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_communication`
--

LOCK TABLES `risk_communication` WRITE;
/*!40000 ALTER TABLE `risk_communication` DISABLE KEYS */;
INSERT INTO `risk_communication` VALUES (900,'desc');
/*!40000 ALTER TABLE `risk_communication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_information`
--

DROP TABLE IF EXISTS `risk_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risk_information` (
  `risk_information_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `threat_type` int(11) unsigned NOT NULL COMMENT 'FK to table THREAT_TYPE(threat_type_id)',
  `asset_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table ASSET(asset_id)',
  `probability` double unsigned NOT NULL COMMENT 'Probability of the threat',
  `event_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table EVENTS(event_id)',
  PRIMARY KEY (`risk_information_id`),
  KEY `threat_type_id_idx` (`threat_type`),
  KEY `risk_information-simple_events_idx` (`event_id`),
  KEY `risk_information-assets_idx` (`asset_id`),
  CONSTRAINT `risk_information-assets` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `risk_information-simple_events` FOREIGN KEY (`event_id`) REFERENCES `simple_events` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `risk_information-threat_type:threat_type_id` FOREIGN KEY (`threat_type`) REFERENCES `threat_type` (`threat_type_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='It will store all data about risk meaning about threat. All fields are defined in the table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_information`
--

LOCK TABLES `risk_information` WRITE;
/*!40000 ALTER TABLE `risk_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `risk_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_policy`
--

DROP TABLE IF EXISTS `risk_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risk_policy` (
  `risk_policy_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `riskvalue` double NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`risk_policy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_policy`
--

LOCK TABLES `risk_policy` WRITE;
/*!40000 ALTER TABLE `risk_policy` DISABLE KEYS */;
INSERT INTO `risk_policy` VALUES (1,0,'myrsikpolicy'),(2,0,'myrsikpolicy'),(3,0,'myrsikpolicy'),(4,0,'myrsikpolicy'),(5,0,'myrsikpolicy'),(6,0,'myrsikpolicy'),(7,0,'myrsikpolicy'),(8,0,'myrsikpolicy'),(9,0,'myrsikpolicy'),(10,0,'myrsikpolicy'),(11,0,'myrsikpolicy'),(12,0,'myrsikpolicy'),(13,0,'myrsikpolicy'),(14,0,'myrsikpolicy'),(15,0,'myrsikpolicy'),(16,0,'myrsikpolicy'),(17,0,'myrsikpolicy'),(18,0,'myrsikpolicy'),(19,0,'myrsikpolicy'),(20,0,'myrsikpolicy'),(21,0,'myrsikpolicy'),(22,0,'myrsikpolicy'),(23,0,'myrsikpolicy'),(24,0,'myrsikpolicy'),(25,0,'myrsikpolicy'),(26,0,'myrsikpolicy'),(27,0,'myrsikpolicy'),(28,0,'myrsikpolicy'),(29,0,'myrsikpolicy'),(30,0,'myrsikpolicy'),(31,0,'myrsikpolicy'),(32,0,'myrsikpolicy'),(33,0,'myrsikpolicy'),(34,0,'myrsikpolicy'),(35,0,'myrsikpolicy'),(36,0,'myrsikpolicy'),(37,0,'myrsikpolicy'),(38,0,'myrsikpolicy'),(39,0,'myrsikpolicy'),(40,0,'myrsikpolicy'),(41,0,'myrsikpolicy'),(42,0,'myrsikpolicy'),(43,0,'myrsikpolicy'),(44,0,'myrsikpolicy'),(45,0,'myrsikpolicy'),(46,0,'myrsikpolicy'),(47,0,'myrsikpolicy'),(48,0,'myrsikpolicy'),(49,0,'myrsikpolicy'),(50,0,'myrsikpolicy'),(51,0,'myrsikpolicy'),(52,0,'myrsikpolicy'),(53,0,'myrsikpolicy'),(54,0,'myrsikpolicy'),(55,0,'myrsikpolicy'),(56,0,'myrsikpolicy'),(57,0,'myrsikpolicy'),(58,0,'myrsikpolicy'),(59,0,'myrsikpolicy'),(60,0,'myrsikpolicy'),(61,0,'myrsikpolicy'),(62,0,'myrsikpolicy'),(63,0,'myrsikpolicy'),(64,0,'myrsikpolicy'),(65,0,'myrsikpolicy'),(66,0,'myrsikpolicy'),(67,0,'myrsikpolicy'),(68,0,'myrsikpolicy'),(69,0,'myrsikpolicy'),(70,0,'myrsikpolicy'),(71,0,'myrsikpolicy'),(72,0,'myrsikpolicy'),(73,0,'myrsikpolicy');
/*!40000 ALTER TABLE `risk_policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_treatment`
--

DROP TABLE IF EXISTS `risk_treatment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risk_treatment` (
  `risk_treatment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL COMMENT 'Description of risk treatment',
  `risk_communication_id` int(10) unsigned NOT NULL COMMENT 'FK to table RISK_COMMUNICATION(risk_communication_id)',
  PRIMARY KEY (`risk_treatment_id`),
  KEY `risk_treatment-risk_communication:risk_communication_id_idx` (`risk_communication_id`),
  CONSTRAINT `risk_treatment-risk_communication:risk_communication_id` FOREIGN KEY (`risk_communication_id`) REFERENCES `risk_communication` (`risk_communication_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table will store all risk treatment computed by the RT2AE. All fields are defined in the table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_treatment`
--

LOCK TABLES `risk_treatment` WRITE;
/*!40000 ALTER TABLE `risk_treatment` DISABLE KEYS */;
/*!40000 ALTER TABLE `risk_treatment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL COMMENT 'Role description',
  `security_level` smallint(6) DEFAULT NULL COMMENT 'Associated security level',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8 COMMENT='Table which describes the role of the users inside the company, for example, if he is the CSO, the CTO, an accountant, a developer...';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (145,'role','desc',1);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_incident`
--

DROP TABLE IF EXISTS `security_incident`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `security_incident` (
  `security_incident_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'Description of the security incident',
  `decision_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table DECISION(decision_id)',
  `event_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table EVENTS(event_id)',
  `device_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table DEVICES(device_id)',
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table USERS(user_id)',
  `modification` datetime DEFAULT NULL COMMENT 'Time of detection of the additional protection',
  PRIMARY KEY (`security_incident_id`),
  KEY `security_incident-simple_events:event_id_idx` (`event_id`),
  KEY `security_incident-devices:device_id_idx` (`device_id`),
  KEY `security_incident-users:user_id_idx` (`user_id`),
  KEY `security_incident-decision:decision_id_idx` (`decision_id`),
  CONSTRAINT `security_incident-decision:decision_id` FOREIGN KEY (`decision_id`) REFERENCES `decision` (`decision_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `security_incident-devices:device_id` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `security_incident-simple_events:event_id` FOREIGN KEY (`event_id`) REFERENCES `simple_events` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `security_incident-users:user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table which includes any security incident detected by the Event Processor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_incident`
--

LOCK TABLES `security_incident` WRITE;
/*!40000 ALTER TABLE `security_incident` DISABLE KEYS */;
/*!40000 ALTER TABLE `security_incident` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_rules`
--

DROP TABLE IF EXISTS `security_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `security_rules` (
  `security_rule_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(2000) NOT NULL COMMENT 'Name of the security rule',
  `description` varchar(2000) NOT NULL COMMENT 'Textual description of the security rule',
  `file` blob COMMENT 'File in DRL format, containing the rule''s code, to make it machine readable',
  `status` enum('VALIDATED','DRAFT','EXPIRED') NOT NULL COMMENT 'Current status of the rule. Only validated rules will be inserted into the production working memory of the Event Processor.',
  `refined` binary(1) NOT NULL DEFAULT '0' COMMENT 'If TRUE (1), the rule has been inferred by the KRS. ',
  `source_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table SOURCES(source_id) Identification of the component owner, in other words, the originator of the last version of the rule (e.g. Event Processor if it is manual or based on expert knowledge or Knowledge Refinement System if the current version is the outcome of knowledge refinement)',
  `modification` datetime NOT NULL COMMENT 'Date of creation of the rule',
  PRIMARY KEY (`security_rule_id`),
  KEY `security_rules-sources:source_id_idx` (`source_id`),
  CONSTRAINT `security_rules-sources:source_id` FOREIGN KEY (`source_id`) REFERENCES `sources` (`source_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=801 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_rules`
--

LOCK TABLES `security_rules` WRITE;
/*!40000 ALTER TABLE `security_rules` DISABLE KEYS */;
INSERT INTO `security_rules` VALUES (800,'sec','des',NULL,'VALIDATED','0',15,'2014-11-15 00:00:00');
/*!40000 ALTER TABLE `security_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensitivity`
--

DROP TABLE IF EXISTS `sensitivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensitivity` (
  `sensitivity_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `level` smallint(6) NOT NULL COMMENT 'Associated numeric value corresponding to different levels of sensitivity from 1 for Strictly confidential, to 3 for public',
  PRIMARY KEY (`sensitivity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='Table for listing all the possible values representing sensitivity of corporate data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensitivity`
--

LOCK TABLES `sensitivity` WRITE;
/*!40000 ALTER TABLE `sensitivity` DISABLE KEYS */;
INSERT INTO `sensitivity` VALUES (25,'sensitivity',1);
/*!40000 ALTER TABLE `sensitivity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `simple_events`
--

DROP TABLE IF EXISTS `simple_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `simple_events` (
  `event_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_type_id` int(10) unsigned NOT NULL COMMENT 'Type of the event. This is a reference to the EVENT_TYPES table, whose possible values are: {USER_ACTION,SENSOR_CONTEXT,USER_FEEDBACK} as simple events',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table USERS(user_id)',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table DEVICES(device_id)',
  `app_id` bigint(20) unsigned COMMENT 'FK to table APPLICATIONS(app_id)',
  `asset_id` bigint(20) unsigned COMMENT 'FK to table ASSETS(asset_id)',
  `data` varchar(50000) NOT NULL COMMENT 'Raw event content (this is the content of the whole event in JSON format)',
  `date` date NOT NULL COMMENT 'Date when the event happens',
  `time` time NOT NULL COMMENT 'Time at when the event happens',
  `duration` int(11) DEFAULT '0' COMMENT 'Duration in milliseconds',
  `source_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table SOURCES(source_id)',
  `EP_can_access` int(11) DEFAULT '1' COMMENT 'If TRUE (1) the Event Processor can access these data',
  `RT2AE_can_access` int(11) DEFAULT '1' COMMENT 'If TRUE (1) the RT2AE can access these data',
  `KRS_can_access` int(11) DEFAULT '1' COMMENT 'If TRUE (1) the Knowledge Refinement System can access these data',
  PRIMARY KEY (`event_id`),
  KEY `event_type_id_idx` (`event_type_id`),
  KEY `device_id_idx` (`device_id`),
  KEY `app_id_idx` (`app_id`),
  KEY `asset_id_idx` (`asset_id`),
  KEY `source_id_idx` (`source_id`),
  KEY `users_id_idx` (`user_id`),
  CONSTRAINT `simple_events-applications:app_id` FOREIGN KEY (`app_id`) REFERENCES `applications` (`app_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `simple_events-assets:asset_id` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `simple_events-devices:device_id` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `simple_events-event_type_event:type_id` FOREIGN KEY (`event_type_id`) REFERENCES `event_type` (`event_type_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `simple_events-sources:source_id` FOREIGN KEY (`source_id`) REFERENCES `sources` (`source_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `simple_events-users:user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT=' Table which describes the set of simple or primitive events in the MUSES system. Each event is paired with:';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `simple_events`
--

LOCK TABLES `simple_events` WRITE;
/*!40000 ALTER TABLE `simple_events` DISABLE KEYS */;
INSERT INTO `simple_events` VALUES (2,13,201,202,118,1516,'Some more','2014-08-10','16:59:48',5,16,0,0,1);
/*!40000 ALTER TABLE `simple_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sources`
--

DROP TABLE IF EXISTS `sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sources` (
  `source_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'Name of the source component that originates actions, events,...',
  PRIMARY KEY (`source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sources`
--

LOCK TABLES `sources` WRITE;
/*!40000 ALTER TABLE `sources` DISABLE KEYS */;
INSERT INTO `sources` VALUES (1,'EP'),(2,'RT2AE'),(3,'KRS');
/*!40000 ALTER TABLE `sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_log_krs`
--

DROP TABLE IF EXISTS `system_log_krs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_log_krs` (
  `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `previous_event_id` bigint(20) unsigned NOT NULL COMMENT 'Previous event. FK to EVENTS(event_id)',
  `current_event_id` bigint(20) unsigned NOT NULL COMMENT 'Current event. FK to EVENTS(event_id)',
  `decision_id` bigint(20) unsigned NOT NULL COMMENT 'Corresponding decision to that event. FK to DECISION(decision_id)',
  `user_behaviour_id` bigint(20) unsigned NOT NULL COMMENT 'Corresponding user''s behaviour for the event. FK to USER_BEHAVIOUR(user_behaviour_id)',
  `security_incident_id` bigint(20) unsigned NOT NULL COMMENT 'Corresponding security incident for the event. FK to SECURITY_INCIDENT(security_incident_id)',
  `device_security_state` bigint(20) unsigned NOT NULL COMMENT 'Corresponding device security state for the event. FK to DEVICE_SECURITY_STATE(device_security_state_id)',
  `risk_treatment` int(10) unsigned NOT NULL COMMENT 'Corresponding risk treatment for the event. FK to RISK_TREATMENT(risk_treatment_id)',
  `start_time` datetime NOT NULL COMMENT 'When the sequence started',
  `finish_time` datetime NOT NULL COMMENT 'When the sequence finished',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table containing the useful information in the form of a log of the system working, in order to further being able to simulate that system workflow in an evaluation process for new (inferred or refined) rules.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_log_krs`
--

LOCK TABLES `system_log_krs` WRITE;
/*!40000 ALTER TABLE `system_log_krs` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_log_krs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `term_values`
--

DROP TABLE IF EXISTS `term_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `term_values` (
  `value_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL COMMENT 'FK to the term which takes this value: table DICTIONARY(term_id)',
  `value` varchar(50) NOT NULL COMMENT 'Value of the term',
  `description` varchar(100) DEFAULT NULL COMMENT 'Description of the value',
  PRIMARY KEY (`value_id`),
  KEY `term_values-dictionary:term_id_idx` (`term_id`),
  CONSTRAINT `term_values-dictionary:term_id` FOREIGN KEY (`term_id`) REFERENCES `dictionary` (`term_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table containing all the possible values for every term. These values will be extracted from other tables as in the DICTIONARY';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `term_values`
--

LOCK TABLES `term_values` WRITE;
/*!40000 ALTER TABLE `term_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `term_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat`
--

DROP TABLE IF EXISTS `threat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threat` (
  `threat_id` bigint(11) NOT NULL AUTO_INCREMENT,
  `description` longtext NOT NULL,
  `probability` double NOT NULL,
  `occurences` int(11) DEFAULT '0',
  `badOutcomeCount` int(11) DEFAULT '0',
  `ttl` int(11) DEFAULT '0',
  PRIMARY KEY (`threat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=985 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat`
--

LOCK TABLES `threat` WRITE;
/*!40000 ALTER TABLE `threat` DISABLE KEYS */;
INSERT INTO `threat` VALUES (1,'threat',0,0,0,0),(2,'test',0,0,0,0),(3,'test',0,0,0,0),(4,'test',0,0,0,0),(5,'test',0,0,0,0),(6,'test',0,0,0,0),(7,'test',0,0,0,0),(8,'test',0,0,0,0),(9,'test',0,0,0,0),(10,'test',0,0,0,0),(11,'test',0,0,0,0),(12,'test',0,0,0,0),(13,'test',0,0,0,0),(14,'test',0,0,0,0),(15,'test',0,0,0,0),(16,'test',0,0,0,0),(17,'test',0,0,0,0),(18,'1210303434300',0,0,0,0),(19,'413331332120',0,0,0,0),(20,'1431442133311',0,0,0,0),(21,'3404001341020',0,0,0,0),(22,'3314213242300',0,0,0,0),(23,'Threateu.musesproject.server.risktrust.User@c225219null',0.5,1,0,0),(24,'test1',0,0,0,0),(25,'Threateu.musesproject.server.risktrust.User@1c2ba649null',0.5,1,0,0),(26,'test2',0,0,0,0),(27,'Threateu.musesproject.server.risktrust.User@344f40f9null',0.5,1,0,0),(28,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@688a9d9enull',0.5,1,0,0),(29,'Threateu.musesproject.server.risktrust.User@3579732cnull',0.5,1,0,0),(30,'Threateu.musesproject.server.risktrust.User@1d1b8446null',0.5,1,0,0),(31,'Threateu.musesproject.server.risktrust.User@209493bdnull',0.5,1,0,0),(32,'Threateu.musesproject.server.risktrust.User@47ab34afnull',0.5,1,0,0),(33,'Threateu.musesproject.server.risktrust.User@4e0a6a6enull',0.5,1,0,0),(34,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@1c4c829cnull',0.5,1,0,0),(35,'Threateu.musesproject.server.risktrust.User@64dc15b6null',0.5,1,0,0),(36,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@48b2f1fnull',0.5,1,0,0),(37,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@6cf1ed61null',0.5,1,0,0),(38,'Threateu.musesproject.server.risktrust.User@4240fc6null',0.5,1,0,0),(39,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@281c9b9enull',0.5,1,0,0),(40,'Threateu.musesproject.server.risktrust.User@17356b4anull',0.5,1,0,0),(41,'Threateu.musesproject.server.risktrust.User@5c49a1a3null',0.5,1,0,0),(42,'ThreatBluetooth enabled might turn into data leakage problemsEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@438f8c3anull',0.5,1,0,0),(43,'Threateu.musesproject.server.risktrust.User@419c5949null',0.5,1,0,0),(44,'Threateu.musesproject.server.risktrust.User@390ff1ebnull',0.5,1,0,0),(45,'ThreatBluetooth enabled might turn into data leakage problemsEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1054d0cnull',0.5,1,0,0),(46,'Threateu.musesproject.server.risktrust.User@638a3572null',0.5,1,0,0),(47,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@75f9a04anull',0.5,1,0,0),(48,'Threateu.musesproject.server.risktrust.User@7de96e85null',0.5,1,0,0),(49,'Threateu.musesproject.server.risktrust.User@2488436fnull',0.5,1,0,0),(50,'Threateu.musesproject.server.risktrust.User@6d49b617null',0.5,1,0,0),(51,'Threateu.musesproject.server.risktrust.User@33f0032fnull',0.5,1,0,0),(52,'Threateu.musesproject.server.risktrust.User@e56e1b1null',0.5,1,0,0),(53,'Threateu.musesproject.server.risktrust.User@5f10485anull',0.5,1,0,0),(54,'Threateu.musesproject.server.risktrust.User@16f4fc5null',0.5,1,0,0),(55,'Threateu.musesproject.server.risktrust.User@2db04c9anull',0.5,1,0,0),(56,'Threateu.musesproject.server.risktrust.User@1164003cnull',0.5,1,0,0),(57,'Threateu.musesproject.server.risktrust.User@57f9dbebnull',0.5,1,0,0),(58,'Threateu.musesproject.server.risktrust.User@6dba7252null',0.5,1,0,0),(59,'Threateu.musesproject.server.risktrust.User@4f7c19ebnull',0.5,1,0,0),(60,'Threateu.musesproject.server.risktrust.User@307ac038null',0.5,1,0,0),(61,'Threateu.musesproject.server.risktrust.User@3579d9bfnull',0.5,1,0,0),(62,'Threateu.musesproject.server.risktrust.User@61cee510null',0.5,1,0,0),(63,'Threateu.musesproject.server.risktrust.User@351e420anull',0.5,1,0,0),(64,'Threateu.musesproject.server.risktrust.User@3bb8898bnull',0.5,1,0,0),(65,'Threateu.musesproject.server.risktrust.User@35715235null',0.5,1,0,0),(66,'Threateu.musesproject.server.risktrust.User@311dc34null',0.5,1,0,0),(67,'Threateu.musesproject.server.risktrust.User@70b8d0f7null',0.5,2,0,0),(68,'Threateu.musesproject.server.risktrust.User@4a25b1e5null',0.5,1,0,0),(69,'Threateu.musesproject.server.risktrust.User@5c44f3e9null',0.5,1,0,0),(70,'Threateu.musesproject.server.risktrust.User@72a2242enull',0.5,1,0,0),(71,'Threateu.musesproject.server.risktrust.User@35ad4bf3null',0.5,1,0,0),(72,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@ec89301null',0.5,1,0,0),(73,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@46d75cc0null',0.5,1,0,0),(74,'Threateu.musesproject.server.risktrust.User@3e57e2d5null',0.5,1,0,0),(75,'Threateu.musesproject.server.risktrust.User@47318d69null',0.5,1,0,0),(76,'Threateu.musesproject.server.risktrust.User@7554effbnull',0.5,1,0,0),(77,'Threateu.musesproject.server.risktrust.User@6a940e5fnull',0.5,1,0,0),(78,'ThreatEncryption without WPA2 protocol might be unsecureEncryption without WPA2 protocol might be unsecureEncryption without WPA2 protocol might be unsecureEncryption without WPA2 protocol might be unsecureEncryption without WPA2 protocol might be unsecureEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@76a60d1dnull',0.5,1,0,0),(79,'Threateu.musesproject.server.risktrust.User@23ecaabbnull',0.5,1,0,0),(80,'Threateu.musesproject.server.risktrust.User@58f1f0cfnull',0.5,1,0,0),(81,'Threateu.musesproject.server.risktrust.User@63773908null',0.5,1,0,0),(82,'Threateu.musesproject.server.risktrust.User@14f74c89null',0.5,1,0,0),(83,'Threateu.musesproject.server.risktrust.User@1f29aebdnull',0.5,1,0,0),(84,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@e98ba0bnull',0.5,1,0,0),(85,'Threateu.musesproject.server.risktrust.User@64e8fbf6null',0.5,1,0,0),(86,'Threateu.musesproject.server.risktrust.User@4945dd26null',0.5,1,0,0),(87,'Threateu.musesproject.server.risktrust.User@f6d8d77null',0.5,1,0,0),(88,'Threateu.musesproject.server.risktrust.User@3f8b5cb9null',0.5,1,0,0),(89,'Threateu.musesproject.server.risktrust.User@1b18054bnull',0.5,1,0,0),(90,'Threateu.musesproject.server.risktrust.User@638f04b0null',0.5,1,0,0),(91,'Threateu.musesproject.server.risktrust.User@539ba418null',0.5,1,0,0),(92,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5551a0a9null',0.5,1,0,0),(93,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@4c165de8null',0.5,1,0,0),(94,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1b00ca67null',0.5,1,0,0),(95,'Threateu.musesproject.server.risktrust.User@168de95enull',0.5,1,0,0),(96,'Threateu.musesproject.server.risktrust.User@6f43df98null',0.5,1,0,0),(97,'Threateu.musesproject.server.risktrust.User@5447472anull',0.5,1,0,0),(98,'Threateu.musesproject.server.risktrust.User@714c4b26null',0.5,1,0,0),(99,'Threateu.musesproject.server.risktrust.User@52f64843null',0.5,1,0,0),(100,'Threateu.musesproject.server.risktrust.User@58d21f3anull',0.5,1,0,0),(101,'Threateu.musesproject.server.risktrust.User@7e1894aenull',0.5,1,0,0),(102,'Threateu.musesproject.server.risktrust.User@33d9a9b7null',0.5,1,0,0),(103,'Threateu.musesproject.server.risktrust.User@197eb418null',0.5,1,0,0),(104,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5d985fffnull',0.5,1,0,0),(105,'Threateu.musesproject.server.risktrust.User@26e20882null',0.5,1,0,0),(106,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@71a62da8null',0.5,1,0,0),(107,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@735139d2null',0.5,1,0,0),(108,'Threateu.musesproject.server.risktrust.User@54834e3fnull',0.5,1,0,0),(109,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@f02c627null',0.5,1,0,0),(110,'Threateu.musesproject.server.risktrust.User@44604dd5null',0.5,1,0,0),(111,'Threateu.musesproject.server.risktrust.User@24bed2d9null',0.5,1,0,0),(112,'Threateu.musesproject.server.risktrust.User@55996133null',0.5,1,0,0),(113,'Threateu.musesproject.server.risktrust.User@19d3a88fnull',0.5,1,0,0),(114,'Threateu.musesproject.server.risktrust.User@4f1a21ecnull',0.5,1,0,0),(115,'Threateu.musesproject.server.risktrust.User@699946anull',0.5,1,0,0),(116,'Threateu.musesproject.server.risktrust.User@b4e1a83null',0.5,1,0,0),(117,'Threateu.musesproject.server.risktrust.User@59854c4anull',0.5,1,0,0),(118,'Threateu.musesproject.server.risktrust.User@35fc7d3fnull',0.5,1,0,0),(119,'Threateu.musesproject.server.risktrust.User@505c380enull',0.5,1,0,0),(120,'Threateu.musesproject.server.risktrust.User@199a2044null',0.5,1,0,0),(121,'Threateu.musesproject.server.risktrust.User@26ce1f59null',0.5,1,0,0),(122,'Threateu.musesproject.server.risktrust.User@1d9ff8e2null',0.5,1,0,0),(123,'Threateu.musesproject.server.risktrust.User@3a577053null',0.5,1,0,0),(124,'Threateu.musesproject.server.risktrust.User@2731b16dnull',0.5,1,0,0),(125,'Threateu.musesproject.server.risktrust.User@182df450null',0.5,1,0,0),(126,'Threateu.musesproject.server.risktrust.User@732504b8null',0.5,1,0,0),(127,'Threateu.musesproject.server.risktrust.User@3d3f95b0null',0.5,1,0,0),(128,'Threateu.musesproject.server.risktrust.User@4c1c5a5bnull',0.5,1,0,0),(129,'Threateu.musesproject.server.risktrust.User@7a74d2f0null',0.5,1,0,0),(130,'Threateu.musesproject.server.risktrust.User@7c8e7c47null',0.5,1,0,0),(131,'Threateu.musesproject.server.risktrust.User@1799af51null',0.5,1,0,0),(132,'Threateu.musesproject.server.risktrust.User@54287575null',0.5,1,0,0),(133,'Threateu.musesproject.server.risktrust.User@52c43ec1null',0.5,1,0,0),(134,'Threateu.musesproject.server.risktrust.User@4440627bnull',0.5,1,0,0),(135,'Threateu.musesproject.server.risktrust.User@61f548d9null',0.5,1,0,0),(136,'Threateu.musesproject.server.risktrust.User@608b2ecfnull',0.5,1,0,0),(137,'Threateu.musesproject.server.risktrust.User@6325c683null',0.5,1,0,0),(138,'Threateu.musesproject.server.risktrust.User@786edd7null',0.5,1,0,0),(139,'Threateu.musesproject.server.risktrust.User@16f95bbcnull',0.5,1,0,0),(140,'Threateu.musesproject.server.risktrust.User@5ea5ffcfnull',0.5,1,0,0),(141,'Threateu.musesproject.server.risktrust.User@49c170fanull',0.5,1,0,0),(142,'Threateu.musesproject.server.risktrust.User@32f42947null',0.5,1,0,0),(143,'Threateu.musesproject.server.risktrust.User@17188dfdnull',0.5,1,0,0),(144,'Threateu.musesproject.server.risktrust.User@18520fdbnull',0.5,1,0,0),(145,'Threateu.musesproject.server.risktrust.User@29de7896null',0.5,1,0,0),(146,'Threateu.musesproject.server.risktrust.User@697d7acenull',0.5,1,0,0),(147,'Threateu.musesproject.server.risktrust.User@63ff8316null',0.5,1,0,0),(148,'Threateu.musesproject.server.risktrust.User@3694c6anull',0.5,1,0,0),(149,'Threateu.musesproject.server.risktrust.User@5abe7f8dnull',0.5,1,0,0),(150,'Threateu.musesproject.server.risktrust.User@22717null',0.5,1,0,0),(151,'Threateu.musesproject.server.risktrust.User@4e2f8922null',0.5,1,0,0),(152,'Threateu.musesproject.server.risktrust.User@632b7fe6null',0.5,1,0,0),(153,'Threateu.musesproject.server.risktrust.User@23706400null',0.5,1,0,0),(154,'Threateu.musesproject.server.risktrust.User@4c6314efnull',0.5,1,0,0),(155,'Threateu.musesproject.server.risktrust.User@21e019ccnull',0.5,1,0,0),(156,'Threateu.musesproject.server.risktrust.User@6336679anull',0.5,1,0,0),(157,'Threateu.musesproject.server.risktrust.User@1923f086null',0.5,1,0,0),(158,'Threateu.musesproject.server.risktrust.User@57b715b6null',0.5,1,0,0),(159,'Threateu.musesproject.server.risktrust.User@46d4074bnull',0.5,1,0,0),(160,'Threateu.musesproject.server.risktrust.User@5670cce2null',0.5,1,0,0),(161,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@163f1e3dnull',0.5,1,0,0),(162,'Threateu.musesproject.server.risktrust.User@1275c77bnull',0.5,1,0,0),(163,'ThreatEncryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@60573326null',0.5,1,0,0),(164,'Threateu.musesproject.server.risktrust.User@74dcf364null',0.5,1,0,0),(165,'Threateu.musesproject.server.risktrust.User@17e45641null',0.5,1,0,0),(166,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@5b01522cnull',0.5,1,0,0),(167,'Threateu.musesproject.server.risktrust.User@471164efnull',0.5,1,0,0),(168,'Threateu.musesproject.server.risktrust.User@377da43bnull',0.5,1,0,0),(169,'Threateu.musesproject.server.risktrust.User@61655bf4null',0.5,1,0,0),(170,'Threateu.musesproject.server.risktrust.User@28ee245null',0.5,1,0,0),(171,'Threateu.musesproject.server.risktrust.User@4de1ed4null',0.5,1,0,0),(172,'Threateu.musesproject.server.risktrust.User@788362eenull',0.5,1,0,0),(173,'Threateu.musesproject.server.risktrust.User@4ae7b721null',0.5,1,0,0),(174,'Threateu.musesproject.server.risktrust.User@5d0132f4null',0.5,1,0,0),(175,'Threateu.musesproject.server.risktrust.User@7fbade5bnull',0.5,1,0,0),(176,'Threateu.musesproject.server.risktrust.User@66e2d7c7null',0.5,1,0,0),(177,'Threateu.musesproject.server.risktrust.User@2031e9b8null',0.5,1,0,0),(178,'Threateu.musesproject.server.risktrust.User@309e1550null',0.5,1,0,0),(179,'Threateu.musesproject.server.risktrust.User@124640danull',0.5,1,0,0),(180,'Threateu.musesproject.server.risktrust.User@7d4cb749null',0.5,1,0,0),(181,'Threateu.musesproject.server.risktrust.User@794702f1null',0.5,1,0,0),(182,'Threateu.musesproject.server.risktrust.User@3cf900d2null',0.5,1,0,0),(183,'Threateu.musesproject.server.risktrust.User@41b2enull',0.5,1,0,0),(184,'Threateu.musesproject.server.risktrust.User@5504aa27null',0.5,1,0,0),(185,'Threateu.musesproject.server.risktrust.User@36e73badnull',0.5,1,0,0),(186,'Threateu.musesproject.server.risktrust.User@c3b2548null',0.5,1,0,0),(187,'Threateu.musesproject.server.risktrust.User@6fa59f7enull',0.5,1,0,0),(188,'Threateu.musesproject.server.risktrust.User@30d4812enull',0.5,1,0,0),(189,'Threateu.musesproject.server.risktrust.User@56f310f3null',0.5,1,0,0),(190,'Threateu.musesproject.server.risktrust.User@4ac7b97fnull',0.5,1,0,0),(191,'Threateu.musesproject.server.risktrust.User@70aec58cnull',0.5,1,0,0),(192,'Threateu.musesproject.server.risktrust.User@30666959null',0.5,1,0,0),(193,'Threateu.musesproject.server.risktrust.User@45386adbnull',0.5,1,0,0),(194,'Threateu.musesproject.server.risktrust.User@4fe859e9null',0.5,1,0,0),(195,'Threateu.musesproject.server.risktrust.User@25e5b315null',0.5,1,0,0),(196,'Threateu.musesproject.server.risktrust.User@1be410ffnull',0.5,1,0,0),(197,'Threateu.musesproject.server.risktrust.User@20342216null',0.5,1,0,0),(198,'Threateu.musesproject.server.risktrust.User@1a0f45ednull',0.5,1,0,0),(199,'Threateu.musesproject.server.risktrust.User@7b231f55null',0.5,1,0,0),(200,'Threateu.musesproject.server.risktrust.User@3aad8c77null',0.5,1,0,0),(201,'Threateu.musesproject.server.risktrust.User@459ce74fnull',0.5,1,0,0),(202,'Threateu.musesproject.server.risktrust.User@2ff94051null',0.5,1,0,0),(203,'Threateu.musesproject.server.risktrust.User@4f2d9840null',0.5,1,0,0),(204,'Threateu.musesproject.server.risktrust.User@256cc70bnull',0.5,1,0,0),(205,'Threateu.musesproject.server.risktrust.User@2e00e942null',0.5,1,0,0),(206,'Threateu.musesproject.server.risktrust.User@51432634null',0.5,1,0,0),(207,'Threateu.musesproject.server.risktrust.User@53241a7fnull',0.5,1,0,0),(208,'Threateu.musesproject.server.risktrust.User@28dafdc0null',0.5,1,0,0),(209,'Threateu.musesproject.server.risktrust.User@567762c1null',0.5,1,0,0),(210,'Threateu.musesproject.server.risktrust.User@2cbfaa31null',0.5,1,0,0),(211,'Threateu.musesproject.server.risktrust.User@2e181d43null',0.5,1,0,0),(212,'Threateu.musesproject.server.risktrust.User@3117e6c0null',0.5,1,0,0),(213,'Threateu.musesproject.server.risktrust.User@51d540canull',0.5,1,0,0),(214,'Threateu.musesproject.server.risktrust.User@79ee2a72null',0.5,1,0,0),(215,'Threateu.musesproject.server.risktrust.User@558df359null',0.5,1,0,0),(216,'Threateu.musesproject.server.risktrust.User@7d360236null',0.5,1,0,0),(217,'Threateu.musesproject.server.risktrust.User@748427c2null',0.5,1,0,0),(218,'Threateu.musesproject.server.risktrust.User@34664360null',0.5,1,0,0),(219,'Threateu.musesproject.server.risktrust.User@907a831null',0.5,1,0,0),(220,'Threateu.musesproject.server.risktrust.User@52097d88null',0.5,1,0,0),(221,'Threateu.musesproject.server.risktrust.User@4564a6fanull',0.5,1,0,0),(222,'Threateu.musesproject.server.risktrust.User@31a75540null',0.5,1,0,0),(223,'Threateu.musesproject.server.risktrust.User@7f231b23null',0.5,1,0,0),(224,'Threateu.musesproject.server.risktrust.User@4868e15fnull',0.5,1,0,0),(225,'Threateu.musesproject.server.risktrust.User@598dcbdanull',0.5,1,0,0),(226,'Threateu.musesproject.server.risktrust.User@5bfb384cnull',0.5,1,0,0),(227,'Threateu.musesproject.server.risktrust.User@273a0ba1null',0.5,1,0,0),(228,'Threateu.musesproject.server.risktrust.User@5112f632null',0.5,1,0,0),(229,'Threateu.musesproject.server.risktrust.User@3e4cd208null',0.5,1,0,0),(230,'Threateu.musesproject.server.risktrust.User@c217624null',0.5,1,0,0),(231,'Threateu.musesproject.server.risktrust.User@2cff2612null',0.5,1,0,0),(232,'Threateu.musesproject.server.risktrust.User@3f5f6d5cnull',0.5,1,0,0),(233,'Threateu.musesproject.server.risktrust.User@26f07d20null',0.5,1,0,0),(234,'Threateu.musesproject.server.risktrust.User@2a9f0193null',0.5,1,0,0),(235,'Threateu.musesproject.server.risktrust.User@75ed0292null',0.5,1,0,0),(236,'Threateu.musesproject.server.risktrust.User@50cd49cbnull',0.5,1,0,0),(237,'Threateu.musesproject.server.risktrust.User@754f44f9null',0.5,1,0,0),(238,'Threateu.musesproject.server.risktrust.User@69c40447null',0.5,1,0,0),(239,'Threateu.musesproject.server.risktrust.User@c4be018null',0.5,1,0,0),(240,'Threateu.musesproject.server.risktrust.User@1190f9cnull',0.5,1,0,0),(241,'Threateu.musesproject.server.risktrust.User@33207c2fnull',0.5,1,0,0),(242,'Threateu.musesproject.server.risktrust.User@1c5d796cnull',0.5,1,0,0),(243,'Threateu.musesproject.server.risktrust.User@77ebf7d7null',0.5,1,0,0),(244,'Threateu.musesproject.server.risktrust.User@3637e7aanull',0.5,1,0,0),(245,'Threateu.musesproject.server.risktrust.User@4738803bnull',0.5,1,0,0),(246,'Threateu.musesproject.server.risktrust.User@3d1d8358null',0.5,1,0,0),(247,'Threateu.musesproject.server.risktrust.User@1958ca04null',0.5,1,0,0),(248,'Threateu.musesproject.server.risktrust.User@1f552a90null',0.5,1,0,0),(249,'Threateu.musesproject.server.risktrust.User@582880b4null',0.5,1,0,0),(250,'Threateu.musesproject.server.risktrust.User@315e67d6null',0.5,1,0,0),(251,'Threateu.musesproject.server.risktrust.User@3c5a71a5null',0.5,1,0,0),(252,'Threateu.musesproject.server.risktrust.User@79388548null',0.5,1,0,0),(253,'Threateu.musesproject.server.risktrust.User@73057eb5null',0.5,1,0,0),(254,'Threateu.musesproject.server.risktrust.User@5dd870c6null',0.5,1,0,0),(255,'Threateu.musesproject.server.risktrust.User@5f519637null',0.5,1,0,0),(256,'Threateu.musesproject.server.risktrust.User@616adafanull',0.5,1,0,0),(257,'Threateu.musesproject.server.risktrust.User@76d912dbnull',0.5,1,0,0),(258,'Threateu.musesproject.server.risktrust.User@5c68a49bnull',0.5,1,0,0),(259,'Threateu.musesproject.server.risktrust.User@3429352fnull',0.5,1,0,0),(260,'Threateu.musesproject.server.risktrust.User@6f633d25null',0.5,1,0,0),(261,'Threateu.musesproject.server.risktrust.User@35db5e23null',0.5,1,0,0),(262,'Threateu.musesproject.server.risktrust.User@52ade616null',0.5,1,0,0),(263,'Threateu.musesproject.server.risktrust.User@6670a443null',0.5,1,0,0),(264,'Threateu.musesproject.server.risktrust.User@47bb8a31null',0.5,1,0,0),(265,'Threateu.musesproject.server.risktrust.User@101f04benull',0.5,1,0,0),(266,'Threateu.musesproject.server.risktrust.User@10e4c9b1null',0.5,1,0,0),(267,'Threateu.musesproject.server.risktrust.User@235fd480null',0.5,1,0,0),(268,'Threateu.musesproject.server.risktrust.User@67903d88null',0.5,1,0,0),(269,'Threateu.musesproject.server.risktrust.User@75d8fd5bnull',0.5,1,0,0),(270,'Threateu.musesproject.server.risktrust.User@616b093fnull',0.5,1,0,0),(271,'Threateu.musesproject.server.risktrust.User@3ad76446null',0.5,1,0,0),(272,'Threateu.musesproject.server.risktrust.User@2f5c4937null',0.5,1,0,0),(273,'Threateu.musesproject.server.risktrust.User@55e7005anull',0.5,1,0,0),(274,'Threateu.musesproject.server.risktrust.User@6a6b5e9dnull',0.5,1,0,0),(275,'Threateu.musesproject.server.risktrust.User@7df898d7null',0.5,1,0,0),(276,'Threateu.musesproject.server.risktrust.User@b3a27b9null',0.5,1,0,0),(277,'Threateu.musesproject.server.risktrust.User@5a423278null',0.5,1,0,0),(278,'Threateu.musesproject.server.risktrust.User@9a4f715null',0.5,1,0,0),(279,'Threateu.musesproject.server.risktrust.User@10fdcf3anull',0.5,1,0,0),(280,'Threateu.musesproject.server.risktrust.User@389dfe8enull',0.5,1,0,0),(281,'Threateu.musesproject.server.risktrust.User@16831f1enull',0.5,1,0,0),(282,'Threateu.musesproject.server.risktrust.User@7bc39b60null',0.5,1,0,0),(283,'Threateu.musesproject.server.risktrust.User@71a37b2bnull',0.5,1,0,0),(284,'Threateu.musesproject.server.risktrust.User@1d292a4cnull',0.5,1,0,0),(285,'Threateu.musesproject.server.risktrust.User@1e599fe1null',0.5,1,0,0),(286,'Threateu.musesproject.server.risktrust.User@6657b7eenull',0.5,1,0,0),(287,'Threateu.musesproject.server.risktrust.User@5cc6f5f3null',0.5,1,0,0),(288,'Threateu.musesproject.server.risktrust.User@da645fenull',0.5,1,0,0),(289,'Threateu.musesproject.server.risktrust.User@4089f35bnull',0.5,1,0,0),(290,'Threateu.musesproject.server.risktrust.User@66aab7dfnull',0.5,1,0,0),(291,'Threateu.musesproject.server.risktrust.User@597d9745null',0.5,1,0,0),(292,'Threateu.musesproject.server.risktrust.User@7dd26c39null',0.5,1,0,0),(293,'Threateu.musesproject.server.risktrust.User@48913885null',0.5,1,0,0),(294,'Threateu.musesproject.server.risktrust.User@67210ba7null',0.5,1,0,0),(295,'Threateu.musesproject.server.risktrust.User@5732f5anull',0.5,1,0,0),(296,'Threateu.musesproject.server.risktrust.User@32e2660anull',0.5,1,0,0),(297,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@46e142e0null',0.5,1,0,0),(298,'Threateu.musesproject.server.risktrust.User@306e8128null',0.5,1,0,0),(299,'Threateu.musesproject.server.risktrust.User@788d12d0null',0.5,1,0,0),(300,'Threateu.musesproject.server.risktrust.User@fce34null',0.5,1,0,0),(301,'Threateu.musesproject.server.risktrust.User@68943510null',0.5,1,0,0),(302,'Threateu.musesproject.server.risktrust.User@60db6493null',0.5,1,0,0),(303,'Threateu.musesproject.server.risktrust.User@4e1ad9b2null',0.5,1,0,0),(304,'Threateu.musesproject.server.risktrust.User@6d5d2109null',0.5,1,0,0),(305,'Threateu.musesproject.server.risktrust.User@465a033anull',0.5,1,0,0),(306,'Threateu.musesproject.server.risktrust.User@31e8e473null',0.5,1,0,0),(307,'Threateu.musesproject.server.risktrust.User@8abcb44null',0.5,1,0,0),(308,'Threateu.musesproject.server.risktrust.User@68de2689null',0.5,1,0,0),(309,'Threateu.musesproject.server.risktrust.User@6d24f7b8null',0.5,1,0,0),(310,'Threateu.musesproject.server.risktrust.User@545ac7d8null',0.5,1,0,0),(311,'Threateu.musesproject.server.risktrust.User@65340bf8null',0.5,2,0,0),(312,'Threateu.musesproject.server.risktrust.User@16a96e4null',0.5,1,0,0),(313,'Threateu.musesproject.server.risktrust.User@2dd48c75null',0.5,1,0,0),(314,'Threateu.musesproject.server.risktrust.User@248ae55cnull',0.5,1,0,0),(315,'Threateu.musesproject.server.risktrust.User@52a2a1fenull',0.5,1,0,0),(316,'Threateu.musesproject.server.risktrust.User@57d7e3a8null',0.5,1,0,0),(317,'Threateu.musesproject.server.risktrust.User@2e5091d8null',0.5,1,0,0),(318,'Threateu.musesproject.server.risktrust.User@f5e328enull',0.5,1,0,0),(319,'Threateu.musesproject.server.risktrust.User@5d17e64enull',0.5,1,0,0),(320,'Threateu.musesproject.server.risktrust.User@6782461fnull',0.5,1,0,0),(321,'Threateu.musesproject.server.risktrust.User@48265deenull',0.5,1,0,0),(322,'Threateu.musesproject.server.risktrust.User@61060e4dnull',0.5,1,0,0),(323,'Threateu.musesproject.server.risktrust.User@520003c4null',0.5,1,0,0),(324,'Threateu.musesproject.server.risktrust.User@30149b4cnull',0.5,1,0,0),(325,'Threateu.musesproject.server.risktrust.User@2a999464null',0.5,1,0,0),(326,'Threateu.musesproject.server.risktrust.User@7f89f4d4null',0.5,1,0,0),(327,'Threateu.musesproject.server.risktrust.User@472a040null',0.5,1,0,0),(328,'Threateu.musesproject.server.risktrust.User@294e4931null',0.5,1,0,0),(329,'Threateu.musesproject.server.risktrust.User@3696d8e6null',0.5,1,0,0),(330,'Threateu.musesproject.server.risktrust.User@16016189null',0.5,1,0,0),(331,'Threateu.musesproject.server.risktrust.User@2f407689null',0.5,1,0,0),(332,'Threateu.musesproject.server.risktrust.User@a97f4f9null',0.5,1,0,0),(333,'Threateu.musesproject.server.risktrust.User@204df76cnull',0.5,1,0,0),(334,'Threateu.musesproject.server.risktrust.User@179032b8null',0.5,1,0,0),(335,'Threateu.musesproject.server.risktrust.User@3f2629d2null',0.5,1,0,0),(336,'Threateu.musesproject.server.risktrust.User@1ef2f6d8null',0.5,1,0,0),(337,'Threateu.musesproject.server.risktrust.User@9d980a9null',0.5,1,0,0),(338,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5e9353abnull',0.5,1,0,0),(339,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@70421880null',0.5,1,0,0),(340,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@48f7df8null',0.5,1,0,0),(341,'Threateu.musesproject.server.risktrust.User@6f219597null',0.5,1,0,0),(342,'Threateu.musesproject.server.risktrust.User@56be8fcfnull',0.5,1,0,0),(343,'Threateu.musesproject.server.risktrust.User@3bbad0fenull',0.5,1,0,0),(344,'Threateu.musesproject.server.risktrust.User@273f7bfdnull',0.5,1,0,0),(345,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@6a1ac40anull',0.5,1,0,0),(346,'Threateu.musesproject.server.risktrust.User@27fce914null',0.5,1,0,0),(347,'Threateu.musesproject.server.risktrust.User@71a6d788null',0.5,1,0,0),(348,'Threateu.musesproject.server.risktrust.User@59b9bc5null',0.5,1,0,0),(349,'Threateu.musesproject.server.risktrust.User@4dc58bbanull',0.5,1,0,0),(350,'Threateu.musesproject.server.risktrust.User@347770e3null',0.5,1,0,0),(351,'Threateu.musesproject.server.risktrust.User@4b984566null',0.5,1,0,0),(352,'Threateu.musesproject.server.risktrust.User@571cbacdnull',0.5,1,0,0),(353,'Threateu.musesproject.server.risktrust.User@7844b5e0null',0.5,1,0,0),(354,'Threateu.musesproject.server.risktrust.User@5a613807null',0.5,1,0,0),(355,'Threateu.musesproject.server.risktrust.User@394d3a5dnull',0.5,1,0,0),(356,'Threateu.musesproject.server.risktrust.User@17740180null',0.5,1,0,0),(357,'Threateu.musesproject.server.risktrust.User@3a3ae87null',0.5,1,0,0),(358,'Threateu.musesproject.server.risktrust.User@30c35589null',0.5,1,0,0),(359,'Threateu.musesproject.server.risktrust.User@68b059dcnull',0.5,1,0,0),(360,'Threateu.musesproject.server.risktrust.User@76f8f54cnull',0.5,1,0,0),(361,'Threateu.musesproject.server.risktrust.User@84ced91null',0.5,1,0,0),(362,'Threateu.musesproject.server.risktrust.User@26aa31ddnull',0.5,1,0,0),(363,'Threateu.musesproject.server.risktrust.User@5e8f520cnull',0.5,1,0,0),(364,'Threateu.musesproject.server.risktrust.User@4d40ffa5null',0.5,1,0,0),(365,'Threateu.musesproject.server.risktrust.User@3b6a4cdfnull',0.5,1,0,0),(366,'Threateu.musesproject.server.risktrust.User@7b893667null',0.5,1,0,0),(367,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@27d6a321null',0.5,1,0,0),(368,'Threateu.musesproject.server.risktrust.User@1a70bc1null',0.5,1,0,0),(369,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@77bd9773null',0.5,1,0,0),(370,'Threateu.musesproject.server.risktrust.User@499a9440null',0.5,1,0,0),(371,'Threateu.musesproject.server.risktrust.User@36c41ba3null',0.5,1,0,0),(372,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@772aa805null',0.5,1,0,0),(373,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@69352dbfnull',0.5,1,0,0),(374,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@437a7526null',0.5,1,0,0),(375,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@4e543d94null',0.5,1,0,0),(376,'Threateu.musesproject.server.risktrust.User@2d50bbcbnull',0.5,1,0,0),(377,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5ce715aenull',0.5,1,0,0),(378,'Threateu.musesproject.server.risktrust.User@c693b3fnull',0.5,1,0,0),(379,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@7c4bfc77null',0.5,1,0,0),(380,'Threateu.musesproject.server.risktrust.User@2bcaa95null',0.5,2,0,0),(381,'Threateu.musesproject.server.risktrust.User@ae3590enull',0.5,1,0,0),(382,'Threateu.musesproject.server.risktrust.User@2944b1cfnull',0.5,1,0,0),(383,'Threateu.musesproject.server.risktrust.User@5e6e7fe9null',0.5,1,0,0),(384,'Threateu.musesproject.server.risktrust.User@603e6f42null',0.5,1,0,0),(385,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@390bb400null',0.5,1,0,0),(386,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@12cc1d1dnull',0.5,1,0,0),(387,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@29a829c4null',0.5,1,0,0),(388,'Threateu.musesproject.server.risktrust.User@72ffa695null',0.5,1,0,0),(389,'Threateu.musesproject.server.risktrust.User@19fb54ccnull',0.5,1,0,0),(390,'Threateu.musesproject.server.risktrust.User@4901c52dnull',0.5,1,0,0),(391,'Threateu.musesproject.server.risktrust.User@4b51da2null',0.5,1,0,0),(392,'Threateu.musesproject.server.risktrust.User@3d741183null',0.5,1,0,0),(393,'Threateu.musesproject.server.risktrust.User@22ea26c0null',0.5,1,0,0),(394,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@680af85enull',0.5,1,0,0),(395,'Threateu.musesproject.server.risktrust.User@670db838null',0.5,1,0,0),(396,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@6f40edbbnull',0.5,1,0,0),(397,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@b523a2fnull',0.5,1,0,0),(398,'Threateu.musesproject.server.risktrust.User@1516121enull',0.5,1,0,0),(399,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@7aee6052null',0.5,1,0,0),(400,'Threateu.musesproject.server.risktrust.User@36e646fdnull',0.5,1,0,0),(401,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@e0abb8dnull',0.5,1,0,0),(402,'Threateu.musesproject.server.risktrust.User@30c6f2e3null',0.5,1,0,0),(403,'Threateu.musesproject.server.risktrust.User@2e187388null',0.5,1,0,0),(404,'Threateu.musesproject.server.risktrust.User@5628e38fnull',0.5,1,0,0),(405,'Threateu.musesproject.server.risktrust.User@43257194null',0.5,1,0,0),(406,'Threateu.musesproject.server.risktrust.User@28c1215anull',0.5,1,0,0),(407,'Threateu.musesproject.server.risktrust.User@644e191dnull',0.5,1,0,0),(408,'Threateu.musesproject.server.risktrust.User@6fe5f677null',0.5,1,0,0),(409,'Threateu.musesproject.server.risktrust.User@7aea5a4bnull',0.5,1,0,0),(410,'Threateu.musesproject.server.risktrust.User@4bd8ccafnull',0.5,1,0,0),(411,'Threateu.musesproject.server.risktrust.User@2bb8a1d8null',0.5,1,0,0),(412,'Threateu.musesproject.server.risktrust.User@4cf411cenull',0.5,1,0,0),(413,'Threateu.musesproject.server.risktrust.User@58f3500enull',0.5,1,0,0),(414,'Threateu.musesproject.server.risktrust.User@59b1f231null',0.5,1,0,0),(415,'Threateu.musesproject.server.risktrust.User@5ce3956cnull',0.5,1,0,0),(416,'Threateu.musesproject.server.risktrust.User@3fdfa5fbnull',0.5,1,0,0),(417,'Threateu.musesproject.server.risktrust.User@1235c076null',0.5,1,0,0),(418,'Threateu.musesproject.server.risktrust.User@172d8922null',0.5,1,0,0),(419,'Threateu.musesproject.server.risktrust.User@1fe4391cnull',0.5,1,0,0),(420,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@53916687null',0.5,1,0,0),(421,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@6ea30689null',0.5,1,0,0),(422,'Threateu.musesproject.server.risktrust.User@6c7a04b4null',0.5,1,0,0),(423,'Threateu.musesproject.server.risktrust.User@2350acd5null',0.5,1,0,0),(424,'Threateu.musesproject.server.risktrust.User@fa62233null',0.5,1,0,0),(425,'Threateu.musesproject.server.risktrust.User@737e798cnull',0.5,1,0,0),(426,'Threateu.musesproject.server.risktrust.User@21819a6anull',0.5,1,0,0),(427,'Threateu.musesproject.server.risktrust.User@553f0e71null',0.5,1,0,0),(428,'Threateu.musesproject.server.risktrust.User@53f40d52null',0.5,1,0,0),(429,'Threateu.musesproject.server.risktrust.User@140182danull',0.5,1,0,0),(430,'Threateu.musesproject.server.risktrust.User@511605e5null',0.5,1,0,0),(431,'Threateu.musesproject.server.risktrust.User@8e67805null',0.5,1,0,0),(432,'Threateu.musesproject.server.risktrust.User@3b4d6f40null',0.5,1,0,0),(433,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@37f60d74null',0.5,1,0,0),(434,'Threateu.musesproject.server.risktrust.User@41cf08a8null',0.5,1,0,0),(435,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1bf49c15null',0.5,1,0,0),(436,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@20bfa521null',0.5,1,0,0),(437,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5c77639bnull',0.5,1,0,0),(438,'Threateu.musesproject.server.risktrust.User@3d4f8fc1null',0.5,1,0,0),(439,'Threateu.musesproject.server.risktrust.User@63dbc465null',0.5,1,0,0),(440,'Threateu.musesproject.server.risktrust.User@6ca19af9null',0.5,1,0,0),(441,'Threateu.musesproject.server.risktrust.User@554d319null',0.5,1,0,0),(442,'Threateu.musesproject.server.risktrust.User@38c6b989null',0.5,1,0,0),(443,'Threateu.musesproject.server.risktrust.User@9542befnull',0.5,1,0,0),(444,'Threateu.musesproject.server.risktrust.User@3932998fnull',0.5,1,0,0),(445,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@767c7388null',0.5,1,0,0),(446,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1a27cb52null',0.5,1,0,0),(447,'Threateu.musesproject.server.risktrust.User@55dc85c4null',0.5,1,0,0),(448,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@2ee55b42null',0.5,1,0,0),(449,'Threateu.musesproject.server.risktrust.User@4563f26null',0.5,1,0,0),(450,'Threateu.musesproject.server.risktrust.User@3a5a1476null',0.5,1,0,0),(451,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1adba92cnull',0.5,1,0,0),(452,'Threateu.musesproject.server.risktrust.User@36077618null',0.5,1,0,0),(453,'Threateu.musesproject.server.risktrust.User@4e7c839enull',0.5,1,0,0),(454,'Threateu.musesproject.server.risktrust.User@548cba81null',0.5,1,0,0),(455,'Threateu.musesproject.server.risktrust.User@6eece807null',0.5,1,0,0),(456,'Threateu.musesproject.server.risktrust.User@16f48ee2null',0.5,1,0,0),(457,'Threateu.musesproject.server.risktrust.User@37771ee5null',0.5,1,0,0),(458,'Threateu.musesproject.server.risktrust.User@5a654025null',0.5,1,0,0),(459,'Threateu.musesproject.server.risktrust.User@f6dff0fnull',0.5,1,0,0),(460,'Threateu.musesproject.server.risktrust.User@3216ac52null',0.5,1,0,0),(461,'Threateu.musesproject.server.risktrust.User@2abd7b85null',0.5,1,0,0),(462,'Threateu.musesproject.server.risktrust.User@4eac90e7null',0.5,1,0,0),(463,'Threateu.musesproject.server.risktrust.User@843b6f8null',0.5,1,0,0),(464,'Threateu.musesproject.server.risktrust.User@7588b36cnull',0.5,1,0,0),(465,'Threateu.musesproject.server.risktrust.User@ffe7416null',0.5,1,0,0),(466,'Threateu.musesproject.server.risktrust.User@1ae8064cnull',0.5,1,0,0),(467,'Threateu.musesproject.server.risktrust.User@1c59691enull',0.5,1,0,0),(468,'Threateu.musesproject.server.risktrust.User@3f4a4b25null',0.5,1,0,0),(469,'Threateu.musesproject.server.risktrust.User@71d504ddnull',0.5,1,0,0),(470,'Threateu.musesproject.server.risktrust.User@60e14474null',0.5,1,0,0),(471,'Threateu.musesproject.server.risktrust.User@731b21a0null',0.5,1,0,0),(472,'Threateu.musesproject.server.risktrust.User@6f1a820enull',0.5,1,0,0),(473,'Threateu.musesproject.server.risktrust.User@601eed43null',0.5,1,0,0),(474,'Threateu.musesproject.server.risktrust.User@1e29afa5null',0.5,1,0,0),(475,'Threateu.musesproject.server.risktrust.User@1b700942null',0.5,1,0,0),(476,'Threateu.musesproject.server.risktrust.User@6def3e22null',0.5,1,0,0),(477,'Threateu.musesproject.server.risktrust.User@5037fa9dnull',0.5,1,0,0),(478,'Threateu.musesproject.server.risktrust.User@6c8e65c4null',0.5,1,0,0),(479,'Threateu.musesproject.server.risktrust.User@53c8d39enull',0.5,1,0,0),(480,'Threateu.musesproject.server.risktrust.User@61a54565null',0.5,1,0,0),(481,'Threateu.musesproject.server.risktrust.User@7040640anull',0.5,1,0,0),(482,'Threateu.musesproject.server.risktrust.User@7694ee96null',0.5,1,0,0),(483,'Threateu.musesproject.server.risktrust.User@3d644b65null',0.5,1,0,0),(484,'Threateu.musesproject.server.risktrust.User@14ff455enull',0.5,1,0,0),(485,'Threateu.musesproject.server.risktrust.User@389b23afnull',0.5,1,0,0),(486,'Threateu.musesproject.server.risktrust.User@1900fe73null',0.5,1,0,0),(487,'Threateu.musesproject.server.risktrust.User@78212b8cnull',0.5,1,0,0),(488,'Threateu.musesproject.server.risktrust.User@6dbd39fenull',0.5,1,0,0),(489,'Threateu.musesproject.server.risktrust.User@3c880e24null',0.5,1,0,0),(490,'Threateu.musesproject.server.risktrust.User@78ad69c2null',0.5,1,0,0),(491,'Threateu.musesproject.server.risktrust.User@614c1f93null',0.5,1,0,0),(492,'Threateu.musesproject.server.risktrust.User@55d60d20null',0.5,1,0,0),(493,'Threateu.musesproject.server.risktrust.User@19a75ab6null',0.5,1,0,0),(494,'Threateu.musesproject.server.risktrust.User@16abf741null',0.5,1,0,0),(495,'Threateu.musesproject.server.risktrust.User@153f1403null',0.5,1,0,0),(496,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@4c33cb6null',0.5,1,0,0),(497,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@14db5449null',0.5,1,0,0),(498,'Threateu.musesproject.server.risktrust.User@3b53c833null',0.5,1,0,0),(499,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@4588bf7fnull',0.5,1,0,0),(500,'Threateu.musesproject.server.risktrust.User@780467fanull',0.5,1,0,0),(501,'Threateu.musesproject.server.risktrust.User@13dc1413null',0.5,1,0,0),(502,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@b898d18null',0.5,1,0,0),(503,'Threateu.musesproject.server.risktrust.User@5d894120null',0.5,1,0,0),(504,'Threateu.musesproject.server.risktrust.User@31647321null',0.5,1,0,0),(505,'Threateu.musesproject.server.risktrust.User@37e5dbb9null',0.5,1,0,0),(506,'Threateu.musesproject.server.risktrust.User@3c3cf07null',0.5,1,0,0),(507,'Threateu.musesproject.server.risktrust.User@65ba39aenull',0.5,1,0,0),(508,'Threateu.musesproject.server.risktrust.User@688c7936null',0.5,1,0,0),(509,'Threateu.musesproject.server.risktrust.User@33dfdc69null',0.5,1,0,0),(510,'Threateu.musesproject.server.risktrust.User@61306936null',0.5,1,0,0),(511,'Threateu.musesproject.server.risktrust.User@3aae7ed7null',0.5,1,0,0),(512,'Threateu.musesproject.server.risktrust.User@65fe1135null',0.5,1,0,0),(513,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@17e5d4c1null',0.5,1,0,0),(514,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@7a28228bnull',0.5,1,0,0),(515,'Threateu.musesproject.server.risktrust.User@29da7eadnull',0.5,1,0,0),(516,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@18c07e25null',0.5,1,0,0),(517,'Threateu.musesproject.server.risktrust.User@701d431dnull',0.5,1,0,0),(518,'Threateu.musesproject.server.risktrust.User@1624dcd6null',0.5,1,0,0),(519,'Threateu.musesproject.server.risktrust.User@79241294null',0.5,1,0,0),(520,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@22e52c47null',0.5,1,0,0),(521,'Threateu.musesproject.server.risktrust.User@6df1e2d9null',0.5,1,0,0),(522,'Threateu.musesproject.server.risktrust.User@34695748null',0.5,1,0,0),(523,'Threateu.musesproject.server.risktrust.User@1156022bnull',0.5,1,0,0),(524,'Threateu.musesproject.server.risktrust.User@68ec5a3anull',0.5,1,0,0),(525,'Threateu.musesproject.server.risktrust.User@46e2bb2anull',0.5,1,0,0),(526,'Threateu.musesproject.server.risktrust.User@75cdc71null',0.5,1,0,0),(527,'Threateu.musesproject.server.risktrust.User@4d226c0cnull',0.5,1,0,0),(528,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@24a4ca4bnull',0.5,1,0,0),(529,'Threateu.musesproject.server.risktrust.User@698159b0null',0.5,1,0,0),(530,'Threateu.musesproject.server.risktrust.User@2efc4f75null',0.5,1,0,0),(531,'Threateu.musesproject.server.risktrust.User@57483791null',0.5,1,0,0),(532,'Threateu.musesproject.server.risktrust.User@404c8dbbnull',0.5,1,0,0),(533,'Threateu.musesproject.server.risktrust.User@5ccd4f98null',0.5,1,0,0),(534,'Threateu.musesproject.server.risktrust.User@59cda058null',0.5,1,0,0),(535,'Threateu.musesproject.server.risktrust.User@787883a4null',0.5,1,0,0),(536,'Threateu.musesproject.server.risktrust.User@4ee7533dnull',0.5,1,0,0),(537,'Threateu.musesproject.server.risktrust.User@3cd48e9null',0.5,1,0,0),(538,'Threateu.musesproject.server.risktrust.User@535f83b0null',0.5,1,0,0),(539,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@17bd2afdnull',0.5,1,0,0),(540,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@18cd0ef4null',0.5,1,0,0),(541,'Threateu.musesproject.server.risktrust.User@524dd664null',0.5,1,0,0),(542,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@3a94d1eanull',0.5,1,0,0),(543,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5310d4d6null',0.5,1,0,0),(544,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@4500003null',0.5,1,0,0),(545,'Threateu.musesproject.server.risktrust.User@2d85af06null',0.5,1,0,0),(546,'Threateu.musesproject.server.risktrust.User@32065df1null',0.5,1,0,0),(547,'Threateu.musesproject.server.risktrust.User@49dfe6a7null',0.5,1,0,0),(548,'Threateu.musesproject.server.risktrust.User@14dd9ae3null',0.5,1,0,0),(549,'Threateu.musesproject.server.risktrust.User@46327741null',0.5,1,0,0),(550,'Threateu.musesproject.server.risktrust.User@6b8e2c08null',0.5,1,0,0),(551,'Threateu.musesproject.server.risktrust.User@1ad8a45cnull',0.5,1,0,0),(552,'Threateu.musesproject.server.risktrust.User@4e4db558null',0.5,1,0,0),(553,'Threateu.musesproject.server.risktrust.User@4aa3db37null',0.5,1,0,0),(554,'Threateu.musesproject.server.risktrust.User@2fb1ad60null',0.5,1,0,0),(555,'Threateu.musesproject.server.risktrust.User@5d4db477null',0.5,1,0,0),(556,'Threateu.musesproject.server.risktrust.User@2b4ace6fnull',0.5,1,0,0),(557,'Threateu.musesproject.server.risktrust.User@3cfbe93null',0.5,1,0,0),(558,'Threateu.musesproject.server.risktrust.User@334feaf9null',0.5,1,0,0),(559,'Threateu.musesproject.server.risktrust.User@3055faf7null',0.5,1,0,0),(560,'Threateu.musesproject.server.risktrust.User@4e3319b0null',0.5,1,0,0),(561,'Threateu.musesproject.server.risktrust.User@25b9cb77null',0.5,1,0,0),(562,'Threateu.musesproject.server.risktrust.User@77cc7256null',0.5,1,0,0),(563,'Threateu.musesproject.server.risktrust.User@3937432dnull',0.5,1,0,0),(564,'Threateu.musesproject.server.risktrust.User@3cb5e6c2null',0.5,1,0,0),(565,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1ac0dc9dnull',0.5,1,0,0),(566,'Threateu.musesproject.server.risktrust.User@72183765null',0.5,1,0,0),(567,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@235f876null',0.5,1,0,0),(568,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@55e912fenull',0.5,1,0,0),(569,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@17f0620cnull',0.5,1,0,0),(570,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@2ac0eacbnull',0.5,1,0,0),(571,'Threateu.musesproject.server.risktrust.User@a755b3dnull',0.5,1,0,0),(572,'Threateu.musesproject.server.risktrust.User@18445b9dnull',0.5,1,0,0),(573,'Threateu.musesproject.server.risktrust.User@7791209bnull',0.5,1,0,0),(574,'Threateu.musesproject.server.risktrust.User@54e059efnull',0.5,1,0,0),(575,'Threateu.musesproject.server.risktrust.User@60236206null',0.5,1,0,0),(576,'Threateu.musesproject.server.risktrust.User@29f6845enull',0.5,1,0,0),(577,'Threateu.musesproject.server.risktrust.User@70c23d7dnull',0.5,1,0,0),(578,'Threateu.musesproject.server.risktrust.User@4776af4cnull',0.5,1,0,0),(579,'Threateu.musesproject.server.risktrust.User@b2022a2null',0.5,1,0,0),(580,'Threateu.musesproject.server.risktrust.User@55016774null',0.5,1,0,0),(581,'Threateu.musesproject.server.risktrust.User@21ed434null',0.5,1,0,0),(582,'Threateu.musesproject.server.risktrust.User@1f9edc03null',0.5,1,0,0),(583,'Threateu.musesproject.server.risktrust.User@48129807null',0.5,1,0,0),(584,'Threateu.musesproject.server.risktrust.User@4e571efdnull',0.5,1,0,0),(585,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@7add5d94null',0.5,1,0,0),(586,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@49e2f3c2null',0.5,1,0,0),(587,'Threateu.musesproject.server.risktrust.User@47b259abnull',0.5,1,0,0),(588,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@28c2c59bnull',0.5,1,0,0),(589,'Threateu.musesproject.server.risktrust.User@6e2233d8null',0.5,1,0,0),(590,'Threateu.musesproject.server.risktrust.User@3bf5b9c4null',0.5,1,0,0),(591,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@503fb7dcnull',0.5,1,0,0),(592,'Threateu.musesproject.server.risktrust.User@421eb33null',0.5,1,0,0),(593,'Threateu.musesproject.server.risktrust.User@523f076anull',0.5,1,0,0),(594,'Threateu.musesproject.server.risktrust.User@570d8a4cnull',0.5,1,0,0),(595,'Threateu.musesproject.server.risktrust.User@2d59c648null',0.5,1,0,0),(596,'Threateu.musesproject.server.risktrust.User@7b5965ffnull',0.5,1,0,0),(597,'Threateu.musesproject.server.risktrust.User@2dd2f39enull',0.5,1,0,0),(598,'Threateu.musesproject.server.risktrust.User@13437c7cnull',0.5,1,0,0),(599,'Threateu.musesproject.server.risktrust.User@57e6b374null',0.5,1,0,0),(600,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@40e8377dnull',0.5,1,0,0),(601,'Threateu.musesproject.server.risktrust.User@7347e91bnull',0.5,1,0,0),(602,'Threateu.musesproject.server.risktrust.User@60f4aa11null',0.5,1,0,0),(603,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5bfb9d3enull',0.5,1,0,0),(604,'Threateu.musesproject.server.risktrust.User@5ad962dcnull',0.5,1,0,0),(605,'Threateu.musesproject.server.risktrust.User@67621868null',0.5,1,0,0),(606,'Threateu.musesproject.server.risktrust.User@387ce19cnull',0.5,1,0,0),(607,'Threateu.musesproject.server.risktrust.User@7ce9a760null',0.5,1,0,0),(608,'Threateu.musesproject.server.risktrust.User@5685bd35null',0.5,1,0,0),(609,'Threateu.musesproject.server.risktrust.User@1d9da9b1null',0.5,1,0,0),(610,'Threateu.musesproject.server.risktrust.User@1403326fnull',0.5,1,0,0),(611,'Threateu.musesproject.server.risktrust.User@5eedf162null',0.5,1,0,0),(612,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@18a95254null',0.5,1,0,0),(613,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@65f9cb06null',0.5,1,0,0),(614,'Threateu.musesproject.server.risktrust.User@11a670b5null',0.5,1,0,0),(615,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@39074289null',0.5,1,0,0),(616,'Threateu.musesproject.server.risktrust.User@2bcc7fa1null',0.5,1,0,0),(617,'Threateu.musesproject.server.risktrust.User@6adc321fnull',0.5,1,0,0),(618,'Threateu.musesproject.server.risktrust.User@7a0c5fb2null',0.5,1,0,0),(619,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@27c4bf43null',0.5,1,0,0),(620,'Threateu.musesproject.server.risktrust.User@42dc341cnull',0.5,1,0,0),(621,'Threateu.musesproject.server.risktrust.User@522be599null',0.5,1,0,0),(622,'Threateu.musesproject.server.risktrust.User@5b031eecnull',0.5,1,0,0),(623,'Threateu.musesproject.server.risktrust.User@2ecda86fnull',0.5,1,0,0),(624,'Threateu.musesproject.server.risktrust.User@6d51df0cnull',0.5,1,0,0),(625,'Threateu.musesproject.server.risktrust.User@7d68e6f1null',0.5,1,0,0),(626,'Threateu.musesproject.server.risktrust.User@36d11bd0null',0.5,1,0,0),(627,'Threateu.musesproject.server.risktrust.User@554181f4null',0.5,1,0,0),(628,'Threateu.musesproject.server.risktrust.User@7f7fc990null',0.5,1,0,0),(629,'Threateu.musesproject.server.risktrust.User@3d5dfd8bnull',0.5,1,0,0),(630,'Threateu.musesproject.server.risktrust.User@60c34e0enull',0.5,1,0,0),(631,'Threateu.musesproject.server.risktrust.User@140ccb58null',0.5,1,0,0),(632,'Threateu.musesproject.server.risktrust.User@1ba45daenull',0.5,1,0,0),(633,'Threateu.musesproject.server.risktrust.User@42fb89dcnull',0.5,1,0,0),(634,'Threateu.musesproject.server.risktrust.User@14b9faacnull',0.5,1,0,0),(635,'Threateu.musesproject.server.risktrust.User@2a5fa889null',0.5,1,0,0),(636,'Threateu.musesproject.server.risktrust.User@28e95767null',0.5,1,0,0),(637,'Threateu.musesproject.server.risktrust.User@6fa18a76null',0.5,1,0,0),(638,'Threateu.musesproject.server.risktrust.User@19490668null',0.5,1,0,0),(639,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@687fa170null',0.5,1,0,0),(640,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@3d26f404null',0.5,1,0,0),(641,'Threateu.musesproject.server.risktrust.User@20fe724null',0.5,1,0,0),(642,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@3e5489b7null',0.5,1,0,0),(643,'Threateu.musesproject.server.risktrust.User@4d3c1c8anull',0.5,1,0,0),(644,'Threateu.musesproject.server.risktrust.User@433c482null',0.5,1,0,0),(645,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@7547d853null',0.5,1,0,0),(646,'Threateu.musesproject.server.risktrust.User@3ca18740null',0.5,1,0,0),(647,'Threateu.musesproject.server.risktrust.User@6cf612b1null',0.5,1,0,0),(648,'Threateu.musesproject.server.risktrust.User@3b9e605enull',0.5,1,0,0),(649,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@47205d5dnull',0.5,1,0,0),(650,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@77cf4a9dnull',0.5,1,0,0),(651,'Threateu.musesproject.server.risktrust.User@25feabd6null',0.5,1,0,0),(652,'Threateu.musesproject.server.risktrust.User@54ad1724null',0.5,1,0,0),(653,'Threateu.musesproject.server.risktrust.User@4bb19676null',0.5,1,0,0),(654,'Threateu.musesproject.server.risktrust.User@3a47685null',0.5,1,0,0),(655,'Threateu.musesproject.server.risktrust.User@40462f41null',0.5,1,0,0),(656,'Threateu.musesproject.server.risktrust.User@53881882null',0.5,1,0,0),(657,'Threateu.musesproject.server.risktrust.User@3392b2b8null',0.5,1,0,0),(658,'Threateu.musesproject.server.risktrust.User@6b5d980fnull',0.5,1,0,0),(659,'Threateu.musesproject.server.risktrust.User@14d5c211null',0.5,1,0,0),(660,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@13f7c0eenull',0.5,1,0,0),(661,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@55932a51null',0.5,1,0,0),(662,'Threateu.musesproject.server.risktrust.User@13eb5aabnull',0.5,1,0,0),(663,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@419a5fcdnull',0.5,1,0,0),(664,'Threateu.musesproject.server.risktrust.User@4b3a2c60null',0.5,1,0,0),(665,'Threateu.musesproject.server.risktrust.User@503c93efnull',0.5,1,0,0),(666,'Threateu.musesproject.server.risktrust.User@3c75f45fnull',0.5,1,0,0),(667,'Threateu.musesproject.server.risktrust.User@1415ffb7null',0.5,1,0,0),(668,'Threateu.musesproject.server.risktrust.User@af7e0f2null',0.5,1,0,0),(669,'Threateu.musesproject.server.risktrust.User@2b879eeanull',0.5,1,0,0),(670,'Threateu.musesproject.server.risktrust.User@614b11canull',0.5,1,0,0),(671,'Threateu.musesproject.server.risktrust.User@1d1092e9null',0.5,1,0,0),(672,'Threateu.musesproject.server.risktrust.User@7fc70a8cnull',0.5,1,0,0),(673,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@7d2904e9null',0.5,1,0,0),(674,'Threateu.musesproject.server.risktrust.User@6af405e2null',0.5,1,0,0),(675,'Threateu.musesproject.server.risktrust.User@7431fd76null',0.5,1,0,0),(676,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@7ca0fe08null',0.5,1,0,0),(677,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@37386667null',0.5,1,0,0),(678,'Threateu.musesproject.server.risktrust.User@72d368d0null',0.5,1,0,0),(679,'Threateu.musesproject.server.risktrust.User@219dc5eenull',0.5,1,0,0),(680,'Threateu.musesproject.server.risktrust.User@39893662null',0.5,1,0,0),(681,'Threateu.musesproject.server.risktrust.User@34af54fanull',0.5,1,0,0),(682,'Threateu.musesproject.server.risktrust.User@5ef1448bnull',0.5,1,0,0),(683,'Threateu.musesproject.server.risktrust.User@57202fdnull',0.5,1,0,0),(684,'Threateu.musesproject.server.risktrust.User@287f3f38null',0.5,1,0,0),(685,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@48929a0anull',0.5,1,0,0),(686,'Threateu.musesproject.server.risktrust.User@9b94c0null',0.5,1,0,0),(687,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@72a92152null',0.5,1,0,0),(688,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@7a917df1null',0.5,1,0,0),(689,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@1a77b9d4null',0.5,1,0,0),(690,'Threateu.musesproject.server.risktrust.User@6fa392d2null',0.5,1,0,0),(691,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@47487fd9null',0.5,1,0,0),(692,'Threateu.musesproject.server.risktrust.User@2c04993bnull',0.5,1,0,0),(693,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@6a7d147anull',0.5,1,0,0),(694,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@69f71c75null',0.5,1,0,0),(695,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@5252682null',0.5,1,0,0),(696,'Threateu.musesproject.server.risktrust.User@76972489null',0.5,1,0,0),(697,'Threateu.musesproject.server.risktrust.User@1ba5ec88null',0.5,1,0,0),(698,'Threateu.musesproject.server.risktrust.User@5dbf0973null',0.5,1,0,0),(699,'Threateu.musesproject.server.risktrust.User@780e6010null',0.5,1,0,0),(700,'Threateu.musesproject.server.risktrust.User@502cc704null',0.5,1,0,0),(701,'Threateu.musesproject.server.risktrust.User@41d499ecnull',0.5,1,0,0),(702,'Threateu.musesproject.server.risktrust.User@3097b6b2null',0.5,1,0,0),(703,'Threateu.musesproject.server.risktrust.User@aadcdb5null',0.5,1,0,0),(704,'Threateu.musesproject.server.risktrust.User@56cd4c15null',0.5,1,0,0),(705,'Threateu.musesproject.server.risktrust.User@195c0357null',0.5,1,0,0),(706,'Threateu.musesproject.server.risktrust.User@40c1b7f0null',0.5,1,0,0),(707,'Threateu.musesproject.server.risktrust.User@7a389bdfnull',0.5,1,0,0),(708,'Threateu.musesproject.server.risktrust.User@6b2cfa00null',0.5,1,0,0),(709,'Threateu.musesproject.server.risktrust.User@428af44anull',0.5,1,0,0),(710,'Threateu.musesproject.server.risktrust.User@556e7c01null',0.5,1,0,0),(711,'Threateu.musesproject.server.risktrust.User@1b1df7fanull',0.5,1,0,0),(712,'Threateu.musesproject.server.risktrust.User@7ef197b6null',0.5,1,0,0),(713,'Threateu.musesproject.server.risktrust.User@2fbcd2cdnull',0.5,1,0,0),(714,'Threateu.musesproject.server.risktrust.User@4a300296null',0.5,1,0,0),(715,'Threateu.musesproject.server.risktrust.User@6df6daadnull',0.5,1,0,0),(716,'Threateu.musesproject.server.risktrust.User@42ae7b1fnull',0.5,1,0,0),(717,'Threateu.musesproject.server.risktrust.User@3a97d6ddnull',0.5,1,0,0),(718,'Threateu.musesproject.server.risktrust.User@4ccacfe6null',0.5,1,0,0),(719,'Threateu.musesproject.server.risktrust.User@2f26a8bfnull',0.5,1,0,0),(720,'Threateu.musesproject.server.risktrust.User@1a4612e3null',0.5,1,0,0),(721,'Threateu.musesproject.server.risktrust.User@1284b956null',0.5,1,0,0),(722,'Threateu.musesproject.server.risktrust.User@6eec2832null',0.5,1,0,0),(723,'Threateu.musesproject.server.risktrust.User@1548f4bbnull',0.5,1,0,0),(724,'Threateu.musesproject.server.risktrust.User@54785a2bnull',0.5,1,0,0),(725,'Threateu.musesproject.server.risktrust.User@2ce138enull',0.5,1,0,0),(726,'Threateu.musesproject.server.risktrust.User@1568008dnull',0.5,1,0,0),(727,'Threateu.musesproject.server.risktrust.User@21d3ee01null',0.5,1,0,0),(728,'Threateu.musesproject.server.risktrust.User@411f95ebnull',0.5,1,0,0),(729,'Threateu.musesproject.server.risktrust.User@1820b54null',0.5,1,0,0),(730,'Threateu.musesproject.server.risktrust.User@72f38ebenull',0.5,1,0,0),(731,'Threateu.musesproject.server.risktrust.User@22c499b4null',0.5,1,0,0),(732,'Threateu.musesproject.server.risktrust.User@6e028a6anull',0.5,1,0,0),(733,'Threateu.musesproject.server.risktrust.User@1a63a190null',0.5,1,0,0),(734,'Threateu.musesproject.server.risktrust.User@4900569cnull',0.5,1,0,0),(735,'Threateu.musesproject.server.risktrust.User@8dcaadfnull',0.5,1,0,0),(736,'Threateu.musesproject.server.risktrust.User@3245485dnull',0.5,1,0,0),(737,'Threateu.musesproject.server.risktrust.User@44668e2anull',0.5,1,0,0),(738,'Threateu.musesproject.server.risktrust.User@66d17bc1null',0.5,1,0,0),(739,'Threateu.musesproject.server.risktrust.User@220a1f1null',0.5,1,0,0),(740,'Threateu.musesproject.server.risktrust.User@9e55d12null',0.5,1,0,0),(741,'Threateu.musesproject.server.risktrust.User@4f0275d8null',0.5,1,0,0),(742,'Threateu.musesproject.server.risktrust.User@400e3d83null',0.5,1,0,0),(743,'Threateu.musesproject.server.risktrust.User@2e456ebbnull',0.5,1,0,0),(744,'Threateu.musesproject.server.risktrust.User@1c328efnull',0.5,1,0,0),(745,'Threateu.musesproject.server.risktrust.User@6fa92851null',0.5,1,0,0),(746,'Threateu.musesproject.server.risktrust.User@509a5fc2null',0.5,1,0,0),(747,'Threateu.musesproject.server.risktrust.User@7cfecb59null',0.5,1,0,0),(748,'Threateu.musesproject.server.risktrust.User@7ceb3314null',0.5,1,0,0),(749,'Threateu.musesproject.server.risktrust.User@fb24b99null',0.5,1,0,0),(750,'Threateu.musesproject.server.risktrust.User@3a38048bnull',0.5,1,0,0),(751,'Threateu.musesproject.server.risktrust.User@673ad5b3null',0.5,1,0,0),(752,'Threateu.musesproject.server.risktrust.User@1ca3fc3bnull',0.5,1,0,0),(753,'Threateu.musesproject.server.risktrust.User@5c71bb95null',0.5,1,0,0),(754,'Threateu.musesproject.server.risktrust.User@4230b753null',0.5,1,0,0),(755,'Threateu.musesproject.server.risktrust.User@58ee841anull',0.5,1,0,0),(756,'Threateu.musesproject.server.risktrust.User@13c1b329null',0.5,1,0,0),(757,'Threateu.musesproject.server.risktrust.User@2538d657null',0.5,1,0,0),(758,'Threateu.musesproject.server.risktrust.User@18b6716fnull',0.5,1,0,0),(759,'Threateu.musesproject.server.risktrust.User@35dccbfnull',0.5,1,0,0),(760,'Threateu.musesproject.server.risktrust.User@7b38903dnull',0.5,1,0,0),(761,'Threateu.musesproject.server.risktrust.User@5e1ef030null',0.5,1,0,0),(762,'Threateu.musesproject.server.risktrust.User@c92c932null',0.5,1,0,0),(763,'Threateu.musesproject.server.risktrust.User@1d043b6enull',0.5,1,0,0),(764,'Threateu.musesproject.server.risktrust.User@26f6a76bnull',0.5,1,0,0),(765,'Threateu.musesproject.server.risktrust.User@3d93587enull',0.5,1,0,0),(766,'Threateu.musesproject.server.risktrust.User@4dbb009fnull',0.5,1,0,0),(767,'Threateu.musesproject.server.risktrust.User@26f92eeenull',0.5,1,0,0),(768,'Threateu.musesproject.server.risktrust.User@9c2f795null',0.5,1,0,0),(769,'Threateu.musesproject.server.risktrust.User@20f913ebnull',0.5,1,0,0),(770,'Threateu.musesproject.server.risktrust.User@1a424d42null',0.5,1,0,0),(771,'Threateu.musesproject.server.risktrust.User@38695ee1null',0.5,1,0,0),(772,'Threateu.musesproject.server.risktrust.User@3c3f6cd1null',0.5,1,0,0),(773,'Threateu.musesproject.server.risktrust.User@72e68c01null',0.5,1,0,0),(774,'Threateu.musesproject.server.risktrust.User@186df550null',0.5,1,0,0),(775,'Threateu.musesproject.server.risktrust.User@3e1dc202null',0.5,1,0,0),(776,'Threateu.musesproject.server.risktrust.User@3b3426d9null',0.5,1,0,0),(777,'Threateu.musesproject.server.risktrust.User@fc9e7bbnull',0.5,1,0,0),(778,'Threateu.musesproject.server.risktrust.User@2b3c7ffdnull',0.5,1,0,0),(779,'Threateu.musesproject.server.risktrust.User@71d54430null',0.5,1,0,0),(780,'Threateu.musesproject.server.risktrust.User@1129d6afnull',0.5,1,0,0),(781,'Threateu.musesproject.server.risktrust.User@7d033563null',0.5,1,0,0),(782,'Threateu.musesproject.server.risktrust.User@5ff145cenull',0.5,1,0,0),(783,'Threateu.musesproject.server.risktrust.User@12ff36benull',0.5,1,0,0),(784,'Threateu.musesproject.server.risktrust.User@4055b155null',0.5,1,0,0),(785,'Threateu.musesproject.server.risktrust.User@62d95611null',0.5,1,0,0),(786,'Threateu.musesproject.server.risktrust.User@18a7af2null',0.5,1,0,0),(787,'Threateu.musesproject.server.risktrust.User@474785b9null',0.5,1,0,0),(788,'Threateu.musesproject.server.risktrust.User@189c2b8dnull',0.5,1,0,0),(789,'Threateu.musesproject.server.risktrust.User@67b3dc92null',0.5,1,0,0),(790,'Threateu.musesproject.server.risktrust.User@5203327fnull',0.5,1,0,0),(791,'Threateu.musesproject.server.risktrust.User@593dcdf4null',0.5,1,0,0),(792,'Threateu.musesproject.server.risktrust.User@10a6dc0cnull',0.5,1,0,0),(793,'Threateu.musesproject.server.risktrust.User@6e49c36fnull',0.5,1,0,0),(794,'Threateu.musesproject.server.risktrust.User@401e55a7null',0.5,1,0,0),(795,'Threateu.musesproject.server.risktrust.User@488947c8null',0.5,1,0,0),(796,'Threateu.musesproject.server.risktrust.User@73e7031anull',0.5,1,0,0),(797,'Threateu.musesproject.server.risktrust.User@771982dcnull',0.5,1,0,0),(798,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@54fba597null',0.5,1,0,0),(799,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@6e7ebdf3null',0.5,1,0,0),(800,'ThreatAttempt to save a file in a monitored folderAttempt to save a file in a monitored folderAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@3b241193null',0.5,1,0,0),(801,'ThreatAttempt to save a file in a monitored folderAttempt to save a file in a monitored folderAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@28f18e1dnull',0.5,1,0,0),(802,'Threateu.musesproject.server.risktrust.User@4863a90dnull',0.5,1,0,0),(803,'Threateu.musesproject.server.risktrust.User@71f126ednull',0.5,1,0,0),(804,'Threateu.musesproject.server.risktrust.User@1321a5fbnull',0.5,1,0,0),(805,'Threateu.musesproject.server.risktrust.User@6f19c9f1null',0.5,1,0,0),(806,'Threateu.musesproject.server.risktrust.User@3b0901b0null',0.5,1,0,0),(807,'Threateu.musesproject.server.risktrust.User@3e575417null',0.5,1,0,0),(808,'Threateu.musesproject.server.risktrust.User@2320e97dnull',0.5,1,0,0),(809,'Threateu.musesproject.server.risktrust.User@14c41b6enull',0.5,1,0,0),(810,'Threateu.musesproject.server.risktrust.User@16eda2c7null',0.5,1,0,0),(811,'Threateu.musesproject.server.risktrust.User@386787b9null',0.5,1,0,0),(812,'Threateu.musesproject.server.risktrust.User@697efd25null',0.5,1,0,0),(813,'Threateu.musesproject.server.risktrust.User@2323e0c0null',0.5,1,0,0),(814,'Threateu.musesproject.server.risktrust.User@166abccenull',0.5,1,0,0),(815,'Threateu.musesproject.server.risktrust.User@7c9d2541null',0.5,1,0,0),(816,'Threateu.musesproject.server.risktrust.User@6c3c899anull',0.5,1,0,0),(817,'Threateu.musesproject.server.risktrust.User@26ab17e4null',0.5,1,0,0),(818,'Threateu.musesproject.server.risktrust.User@72e6fbb0null',0.5,1,0,0),(819,'Threateu.musesproject.server.risktrust.User@463bf65cnull',0.5,1,0,0),(820,'Threateu.musesproject.server.risktrust.User@6a1708bbnull',0.5,1,0,0),(821,'Threateu.musesproject.server.risktrust.User@60b45d5bnull',0.5,1,0,0),(822,'Threateu.musesproject.server.risktrust.User@4b3b1d19null',0.5,1,0,0),(823,'Threateu.musesproject.server.risktrust.User@7b0081c6null',0.5,1,0,0),(824,'Threateu.musesproject.server.risktrust.User@1972d1eenull',0.5,1,0,0),(825,'Threateu.musesproject.server.risktrust.User@46a4e62enull',0.5,1,0,0),(826,'Threateu.musesproject.server.risktrust.User@79dd9ee5null',0.5,1,0,0),(827,'Threateu.musesproject.server.risktrust.User@790f4ec3null',0.5,1,0,0),(828,'Threateu.musesproject.server.risktrust.User@32c5f0ddnull',0.5,1,0,0),(829,'Threateu.musesproject.server.risktrust.User@1af9dfenull',0.5,1,0,0),(830,'Threateu.musesproject.server.risktrust.User@1907596dnull',0.5,1,0,0),(831,'Threateu.musesproject.server.risktrust.User@1d8346benull',0.5,1,0,0),(832,'Threateu.musesproject.server.risktrust.User@615125e1null',0.5,1,0,0),(833,'Threateu.musesproject.server.risktrust.User@fd36d2cnull',0.5,1,0,0),(834,'Threateu.musesproject.server.risktrust.User@28621f71null',0.5,1,0,0),(835,'Threateu.musesproject.server.risktrust.User@26c09162null',0.5,1,0,0),(836,'Threateu.musesproject.server.risktrust.User@327e46bfnull',0.5,1,0,0),(837,'Threateu.musesproject.server.risktrust.User@13082c47null',0.5,1,0,0),(838,'Threateu.musesproject.server.risktrust.User@2113caednull',0.5,1,0,0),(839,'Threateu.musesproject.server.risktrust.User@37a19b43null',0.5,1,0,0),(840,'Threateu.musesproject.server.risktrust.User@bb09cf5null',0.5,1,0,0),(841,'Threateu.musesproject.server.risktrust.User@57393275null',0.5,1,0,0),(842,'Threateu.musesproject.server.risktrust.User@35258ad8null',0.5,1,0,0),(843,'Threateu.musesproject.server.risktrust.User@73a8a2e4null',0.5,1,0,0),(844,'Threateu.musesproject.server.risktrust.User@34fcceadnull',0.5,1,0,0),(845,'Threateu.musesproject.server.risktrust.User@4740456anull',0.5,1,0,0),(846,'Threateu.musesproject.server.risktrust.User@417a1607null',0.5,1,0,0),(847,'Threateu.musesproject.server.risktrust.User@70a59506null',0.5,1,0,0),(848,'Threateu.musesproject.server.risktrust.User@51e2828bnull',0.5,1,0,0),(849,'Threateu.musesproject.server.risktrust.User@6b8e3a6enull',0.5,1,0,0),(850,'Threateu.musesproject.server.risktrust.User@4c5b3eb6null',0.5,1,0,0),(851,'Threateu.musesproject.server.risktrust.User@235cf8cbnull',0.5,1,0,0),(852,'Threateu.musesproject.server.risktrust.User@4a67b7e9null',0.5,1,0,0),(853,'Threateu.musesproject.server.risktrust.User@792ef3fanull',0.5,1,0,0),(854,'Threateu.musesproject.server.risktrust.User@637ac89null',0.5,1,0,0),(855,'Threateu.musesproject.server.risktrust.User@82cd24anull',0.5,1,0,0),(856,'Threateu.musesproject.server.risktrust.User@4b615fd3null',0.5,1,0,0),(857,'Threateu.musesproject.server.risktrust.User@6fdc4389null',0.5,1,0,0),(858,'Threateu.musesproject.server.risktrust.User@1c77030anull',0.5,1,0,0),(859,'Threateu.musesproject.server.risktrust.User@313cc762null',0.5,1,0,0),(860,'Threateu.musesproject.server.risktrust.User@20b503bbnull',0.5,1,0,0),(861,'Threateu.musesproject.server.risktrust.User@20d072d3null',0.5,1,0,0),(862,'Threateu.musesproject.server.risktrust.User@7a446b2cnull',0.5,1,0,0),(863,'Threateu.musesproject.server.risktrust.User@48ecd39enull',0.5,1,0,0),(864,'Threateu.musesproject.server.risktrust.User@b7e0c9bnull',0.5,1,0,0),(865,'Threateu.musesproject.server.risktrust.User@5b2c6057null',0.5,1,0,0),(866,'Threateu.musesproject.server.risktrust.User@4e8034dbnull',0.5,1,0,0),(867,'Threateu.musesproject.server.risktrust.User@35c1444bnull',0.5,1,0,0),(868,'Threateu.musesproject.server.risktrust.User@346ef55dnull',0.5,1,0,0),(869,'Threateu.musesproject.server.risktrust.User@11d178c7null',0.5,1,0,0),(870,'Threateu.musesproject.server.risktrust.User@6bc3c233null',0.5,1,0,0),(871,'Threateu.musesproject.server.risktrust.User@7c5646cenull',0.5,1,0,0),(872,'Threateu.musesproject.server.risktrust.User@217ee201null',0.5,1,0,0),(873,'Threateu.musesproject.server.risktrust.User@45762201null',0.5,1,0,0),(874,'Threateu.musesproject.server.risktrust.User@7320cdeanull',0.5,1,0,0),(875,'Threateu.musesproject.server.risktrust.User@3493efbnull',0.5,1,0,0),(876,'Threateu.musesproject.server.risktrust.User@3210e873null',0.5,1,0,0),(877,'Threateu.musesproject.server.risktrust.User@559dd738null',0.5,1,0,0),(878,'Threateu.musesproject.server.risktrust.User@26d895c0null',0.5,1,0,0),(879,'Threateu.musesproject.server.risktrust.User@e1c7636null',0.5,1,0,0),(880,'Threateu.musesproject.server.risktrust.User@5278f98cnull',0.5,1,0,0),(881,'Threateu.musesproject.server.risktrust.User@2b916b9anull',0.5,1,0,0),(882,'Threateu.musesproject.server.risktrust.User@407278f2null',0.5,1,0,0),(883,'Threateu.musesproject.server.risktrust.User@61409e2enull',0.5,1,0,0),(884,'Threateu.musesproject.server.risktrust.User@2af1e871null',0.5,1,0,0),(885,'Threateu.musesproject.server.risktrust.User@1f481712null',0.5,1,0,0),(886,'Threateu.musesproject.server.risktrust.User@37167251null',0.5,1,0,0),(887,'Threateu.musesproject.server.risktrust.User@485be365null',0.5,1,0,0),(888,'Threateu.musesproject.server.risktrust.User@178bff2cnull',0.5,1,0,0),(889,'Threateu.musesproject.server.risktrust.User@71564fefnull',0.5,1,0,0),(890,'Threateu.musesproject.server.risktrust.User@42f2c87anull',0.5,1,0,0),(891,'Threateu.musesproject.server.risktrust.User@6fd61aa3null',0.5,1,0,0),(892,'Threateu.musesproject.server.risktrust.User@62fa9f99null',0.5,1,0,0),(893,'Threateu.musesproject.server.risktrust.User@60b7530enull',0.5,1,0,0),(894,'Threateu.musesproject.server.risktrust.User@781e06anull',0.5,1,0,0),(895,'Threateu.musesproject.server.risktrust.User@561d28bbnull',0.5,1,0,0),(896,'Threateu.musesproject.server.risktrust.User@47ab79b5null',0.5,1,0,0),(897,'Threateu.musesproject.server.risktrust.User@25348c2cnull',0.5,1,0,0),(898,'Threateu.musesproject.server.risktrust.User@5f71bf9dnull',0.5,1,0,0),(899,'Threateu.musesproject.server.risktrust.User@2e00b913null',0.5,1,0,0),(900,'Threateu.musesproject.server.risktrust.User@3391c704null',0.5,1,0,0),(901,'Threateu.musesproject.server.risktrust.User@14031d2cnull',0.5,1,0,0),(902,'Threateu.musesproject.server.risktrust.User@79b3df0anull',0.5,1,0,0),(903,'Threateu.musesproject.server.risktrust.User@26406926null',0.5,1,0,0),(904,'Threateu.musesproject.server.risktrust.User@359bab13null',0.5,1,0,0),(905,'Threateu.musesproject.server.risktrust.User@386c2cb5null',0.5,1,0,0),(906,'Threateu.musesproject.server.risktrust.User@1c888d16null',0.5,1,0,0),(907,'Threateu.musesproject.server.risktrust.User@52a79c0enull',0.5,1,0,0),(908,'Threateu.musesproject.server.risktrust.User@720a366bnull',0.5,1,0,0),(909,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1833a08dnull',0.5,1,0,0),(910,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@e575cf2null',0.5,1,0,0),(911,'Threateu.musesproject.server.risktrust.User@2532ca03null',0.5,1,0,0),(912,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@12f72ee4null',0.5,1,0,0),(913,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@3907254fnull',0.5,1,0,0),(914,'Threateu.musesproject.server.risktrust.User@79356271null',0.5,1,0,0),(915,'Threateu.musesproject.server.risktrust.User@1d4b9d04null',0.5,1,0,0),(916,'Threateu.musesproject.server.risktrust.User@5074018enull',0.5,1,0,0),(917,'Threateu.musesproject.server.risktrust.User@29f7a7f1null',0.5,1,0,0),(918,'Threateu.musesproject.server.risktrust.User@624c7517null',0.5,1,0,0),(919,'Threateu.musesproject.server.risktrust.User@469f5858null',0.5,1,0,0),(920,'Threateu.musesproject.server.risktrust.User@3fe5adaanull',0.5,1,0,0),(921,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@1c89a3ddnull',0.5,1,0,0),(922,'Threateu.musesproject.server.risktrust.User@33fe8685null',0.5,1,0,0),(923,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@64b17801null',0.5,1,0,0),(924,'Threateu.musesproject.server.risktrust.User@63d3e646null',0.5,1,0,0),(925,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@8fd294anull',0.5,1,0,0),(926,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@33b17d2cnull',0.5,1,0,0),(927,'Threateu.musesproject.server.risktrust.User@717a23b3null',0.5,1,0,0),(928,'Threateu.musesproject.server.risktrust.User@11f5707bnull',0.5,1,0,0),(929,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@63471445null',0.5,1,0,0),(930,'Threateu.musesproject.server.risktrust.User@40185222null',0.5,1,0,0),(931,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@337e9c58null',0.5,1,0,0),(932,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@283d1416null',0.5,1,0,0),(933,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@53bdd907null',0.5,1,0,0),(934,'Threateu.musesproject.server.risktrust.User@8593b8enull',0.5,1,0,0),(935,'Threateu.musesproject.server.risktrust.User@2c7b4ac9null',0.5,1,0,0),(936,'Threateu.musesproject.server.risktrust.User@2bd38c1fnull',0.5,1,0,0),(937,'Threateu.musesproject.server.risktrust.User@10bac37dnull',0.5,1,0,0),(938,'Threateu.musesproject.server.risktrust.User@4d9e5465null',0.5,1,0,0),(939,'Threateu.musesproject.server.risktrust.User@61fe38f3null',0.5,1,0,0),(940,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@885db7null',0.5,1,0,0),(941,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@3ea6f0f2null',0.5,1,0,0),(942,'Threateu.musesproject.server.risktrust.User@62783f99null',0.5,1,0,0),(943,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@5eea9d53null',0.5,1,0,0),(944,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@73ed9c00null',0.5,1,0,0),(945,'Threateu.musesproject.server.risktrust.User@ea6e1aenull',0.5,1,0,0),(946,'Threateu.musesproject.server.risktrust.User@35d37910null',0.5,1,0,0),(947,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5947a7aanull',0.5,1,0,0),(948,'Threateu.musesproject.server.risktrust.User@26996636null',0.5,1,0,0),(949,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@7353a077null',0.5,1,0,0),(950,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@110a9999null',0.5,1,0,0),(951,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@1051694anull',0.5,1,0,0),(952,'Threateu.musesproject.server.risktrust.User@6892401anull',0.5,1,0,0),(953,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@3bb4be09null',0.5,1,0,0),(954,'Threateu.musesproject.server.risktrust.User@69ad92cenull',0.5,1,0,0),(955,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@7c7def07null',0.5,1,0,0),(956,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@16bdcae1null',0.5,1,0,0),(957,'ThreatBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@2e25ae98null',0.5,1,0,0),(958,'Threateu.musesproject.server.risktrust.User@7d437b09null',0.5,1,0,0),(959,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@5a3341c0null',0.5,1,0,0),(960,'Threateu.musesproject.server.risktrust.User@1020a8eanull',0.5,1,0,0),(961,'ThreatBluetooth enabled might turn into data leakage problemsUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@7d44673enull',0.5,1,0,0),(962,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@a75b3e5null',0.5,1,0,0),(963,'Threateu.musesproject.server.risktrust.User@1e5c35ednull',0.5,1,0,0),(964,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@1d521927null',0.5,1,0,0),(965,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureeu.musesproject.server.risktrust.User@29bab336null',0.5,1,0,0),(966,'Threateu.musesproject.server.risktrust.User@14c918b8null',0.5,1,0,0),(967,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@39fd704dnull',0.5,1,0,0),(968,'Threateu.musesproject.server.risktrust.User@69602d64null',0.5,1,0,0),(969,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@1709fa5anull',0.5,1,0,0),(970,'Threateu.musesproject.server.risktrust.User@a264748null',0.5,1,0,0),(971,'Threateu.musesproject.server.risktrust.User@446f8a53null',0.5,1,0,0),(972,'Threateu.musesproject.server.risktrust.User@3b7c73b5null',0.5,1,0,0),(973,'Threateu.musesproject.server.risktrust.User@562b9edbnull',0.5,1,0,0),(974,'Threateu.musesproject.server.risktrust.User@58e7fe0bnull',0.5,1,0,0),(975,'Threateu.musesproject.server.risktrust.User@5ae6293dnull',0.5,1,0,0),(976,'Threateu.musesproject.server.risktrust.User@18b1afdbnull',0.5,1,0,0),(977,'Threateu.musesproject.server.risktrust.User@522e5bb8null',0.5,1,0,0),(978,'Threateu.musesproject.server.risktrust.User@76dc9cb2null',0.5,1,0,0),(979,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@1e998b4cnull',0.5,1,0,0),(980,'Threateu.musesproject.server.risktrust.User@1f7aedc7null',0.5,1,0,0),(981,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@59d41c9cnull',0.5,1,0,0),(982,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@504d9768null',0.5,1,0,0),(983,'ThreatUnsecureWifi:Encryption without WPA2 protocol might be unsecureBluetooth enabled might turn into data leakage problemseu.musesproject.server.risktrust.User@44f7fa56null',0.5,1,0,0),(984,'ThreatAttempt to save a file in a monitored foldereu.musesproject.server.risktrust.User@3c15c0fcnull',0.5,1,0,0);
/*!40000 ALTER TABLE `threat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat_clue`
--

DROP TABLE IF EXISTS `threat_clue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threat_clue` (
  `threat_clue_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `access_request_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table ACCESS_REQUEST(access_request_id)',
  `event_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table EVENTS(event_id)',
  `threat_type_id` int(11) unsigned NOT NULL COMMENT 'FK to table THREAT_TYPE(threat_type_id)',
  `asset_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table ASSETS(asset_id)',
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to table USERS(user_id)',
  `modification` datetime NOT NULL COMMENT 'Time of detection of the threat clue',
  PRIMARY KEY (`threat_clue_id`),
  KEY `threat_clue-acess_request:access_request_id_idx` (`access_request_id`),
  KEY `threat_clue-simple_events:event_id_idx` (`event_id`),
  KEY `threat_clue-assets:asset_id_idx` (`asset_id`),
  KEY `threat_clue-users:user_id_idx` (`user_id`),
  KEY `threat_clue-threat_type:threat_type_id_idx` (`threat_type_id`),
  CONSTRAINT `threat_clue-acess_request:access_request_id` FOREIGN KEY (`access_request_id`) REFERENCES `access_request` (`access_request_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `threat_clue-assets:asset_id` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `threat_clue-simple_events:event_id` FOREIGN KEY (`event_id`) REFERENCES `simple_events` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `threat_clue-threat_type:threat_type_id` FOREIGN KEY (`threat_type_id`) REFERENCES `threat_type` (`threat_type_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `threat_clue-users:user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table which include any threat clue detected by the Event Processor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_clue`
--

LOCK TABLES `threat_clue` WRITE;
/*!40000 ALTER TABLE `threat_clue` DISABLE KEYS */;
/*!40000 ALTER TABLE `threat_clue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat_type`
--

DROP TABLE IF EXISTS `threat_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threat_type` (
  `threat_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL COMMENT 'Types of threat, such as WI-FI_SNIFFING, UNSECURE_NETWORK,MALWARE,SPYWARE,..',
  `description` varchar(100) NOT NULL COMMENT 'Description of the threat',
  PRIMARY KEY (`threat_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table is directly related to the RISK_INFORMATION table, as it contains the information about the type of threat.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_type`
--

LOCK TABLES `threat_type` WRITE;
/*!40000 ALTER TABLE `threat_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `threat_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_authorization`
--

DROP TABLE IF EXISTS `user_authorization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_authorization` (
  `user_authorization_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table USERS(user_id)',
  `role_id` int(10) unsigned NOT NULL COMMENT 'FK to table ROLES(role_id)',
  PRIMARY KEY (`user_authorization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_authorization`
--

LOCK TABLES `user_authorization` WRITE;
/*!40000 ALTER TABLE `user_authorization` DISABLE KEYS */;
INSERT INTO `user_authorization` VALUES (89,200,145);
/*!40000 ALTER TABLE `user_authorization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_behaviour`
--

DROP TABLE IF EXISTS `user_behaviour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_behaviour` (
  `user_behaviour_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `device_id` bigint(20) unsigned NOT NULL,
  `action` varchar(50) NOT NULL COMMENT 'The action made by the user',
  `time` datetime NOT NULL COMMENT 'Date of the recording',
  `decision_id` bigint(20) unsigned NOT NULL COMMENT 'FK to table DECISION(decision_id)',
  `additional_info` varchar(50) DEFAULT NULL COMMENT 'Useful additional information',
  PRIMARY KEY (`user_behaviour_id`),
  KEY `user_behaviour-users:user_id_idx` (`user_id`),
  KEY `user_behaviour-devices:device_id_idx` (`device_id`),
  KEY `user_behaviour-decision:decision_id_idx` (`decision_id`),
  CONSTRAINT `user_behaviour-decision:decision_id` FOREIGN KEY (`decision_id`) REFERENCES `decision` (`decision_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `user_behaviour-devices:device_id` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `user_behaviour-users:user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table which will store all user behaviour data. All fields are defined in the table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_behaviour`
--

LOCK TABLES `user_behaviour` WRITE;
/*!40000 ALTER TABLE `user_behaviour` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_behaviour` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL COMMENT 'First and middle names',
  `surname` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL COMMENT 'user''s e-mail',
  `username` varchar(50) NOT NULL COMMENT 'The user name used to login',
  `password` varchar(50) NOT NULL COMMENT 'The user''s password',
  `enabled` int(11) NOT NULL DEFAULT '0' COMMENT 'Specify whether the user''s account is active (1) or not (0)',
  `trust_value` double unsigned DEFAULT NULL COMMENT 'The trust value of the user will be between 0 and 1',
  `role_id` int(10) unsigned NOT NULL COMMENT 'FK to table ROLE(role_id)',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  KEY `role_id_idx` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8 COMMENT='This table contains user information, similar to a profile. It has personal data (name, email) as well as company data (user''s role inside the company). Additionally, a trust value has been included for RT2AE calculation processes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin','admin@muses.com','muses','muses',1,200,100),(2,'swe tester 2','swe','swe@swe-con.se','swe-tester-2','swe_test',0,1,0),(3,'swe tester 3','swe','swe@swe-con.se','swe-tester-3','swe_test',0,1,0),(4,'swe tester 4','swe','swe@swe-con.se','swe-tester-4','swe_test',0,1,0),(5,'swe tester 5','swe','swe@swe-con.se','swe-tester-5','swe_test',0,1,0),(6,'swe tester 6','swe','swe@swe-con.se','swe-tester-6','swe_test',0,1,0),(7,'swe tester 7','swe','swe@swe-con.se','swe-tester-7','swe_test',0,1,0),(8,'swe tester 8','swe','swe@swe-con.se','swe-tester-8','swe_test',0,1,0),(9,'swe tester 9','swe','swe@swe-con.se','swe-tester-9','swe_test',0,1,0),(10,'swe tester 10','swe','swe@swe-con.se','swe-tester-10','swe_test',0,1,0),(11,'notfound','notfound','notfound@muses.com','notfound','56836458345673465',0,0,0),(200,'John','Doe','joe@email.com','joe','pass',1,200,100),(201,'Joe','david','david@email.com','david','pass',1,200,101),(206,'Pinkman','Jesse','jesse.pinkman@muses.eu','junior','walterwhite',0,0.9999,0),(207,'Pinkman','Jesse','jesse.pinkman@muses.eu','hank','walterwhite',0,0.9999,0),(209,'Pinkman','Jesse','jesse.pinkman@muses.eu','1032332241110','walterwhite',0,0.9999,0),(210,'Pinkman','Jesse','jesse.pinkman@muses.eu','130341233403','walterwhite',0,0.9999,0),(211,'Pinkman','Jesse','jesse.pinkman@muses.eu','1404023114313','walterwhite',0,0.9999,0),(212,'Pinkman','Jesse','jesse.pinkman@muses.eu','3241113212132','walterwhite',0,0.9999,0),(213,'Pinkman','Jesse','jesse.pinkman@muses.eu','2344114311100','walterwhite',0,0.9999,0),(214,'Pinkman','Jesse','jesse.pinkman@muses.eu','3403203020234','walterwhite',0,0.9999,0),(215,'Pinkman','Jesse','jesse.pinkman@muses.eu','1233411420410','walterwhite',0,0.9999,0),(216,'Pinkman','Jesse','jesse.pinkman@muses.eu','102023032313','walterwhite',0,0.9999,0),(217,'Pinkman','Jesse','jesse.pinkman@muses.eu','1113333143424','walterwhite',0,0.9999,0),(218,'Pinkman','Jesse','jesse.pinkman@muses.eu','212002322402','walterwhite',0,0.9999,0),(219,'Pinkman','Jesse','jesse.pinkman@muses.eu','314432010013','walterwhite',0,0.9999,0),(220,'Pinkman','Jesse','jesse.pinkman@muses.eu','2033310120144','walterwhite',0,0.9999,0),(221,'Pinkman','Jesse','jesse.pinkman@muses.eu','1332143110412','walterwhite',0,0.9999,0),(222,'Pinkman','Jesse','jesse.pinkman@muses.eu','1414442402432','walterwhite',0,0.9999,0),(223,'Pinkman','Jesse','jesse.pinkman@muses.eu','4102241231401','walterwhite',0,0.9999,0),(224,'Pinkman','Jesse','jesse.pinkman@muses.eu','242410024210','walterwhite',0,0.9999,0),(225,'Pinkman','Jesse','jesse.pinkman@muses.eu','342211231012','walterwhite',0,0.9999,0),(226,'Pinkman','Jesse','jesse.pinkman@muses.eu','2422123334033','walterwhite',0,0.9999,0),(227,'Pinkman','Jesse','jesse.pinkman@muses.eu','3124123131143','walterwhite',0,0.9999,0),(228,'Pinkman','Jesse','jesse.pinkman@muses.eu','3413223441224','walterwhite',0,0.9999,0),(229,'Pinkman','Jesse','jesse.pinkman@muses.eu','3302103221122','walterwhite',0,0.9999,0),(230,'Pinkman','Jesse','jesse.pinkman@muses.eu','3431221421233','walterwhite',0,0.9999,0),(231,'Pinkman','Jesse','jesse.pinkman@muses.eu','3011203122401','walterwhite',0,0.9999,0),(232,'Pinkman','Jesse','jesse.pinkman@muses.eu','2411434443200','walterwhite',0,0.9999,0),(233,'Pinkman','Jesse','jesse.pinkman@muses.eu','2343110331313','walterwhite',0,0.9999,0),(234,'Pinkman','Jesse','jesse.pinkman@muses.eu','1443043043434','walterwhite',0,0.9999,0),(235,'Pinkman','Jesse','jesse.pinkman@muses.eu','3201330131244','walterwhite',0,0.9999,0),(236,'Pinkman','Jesse','jesse.pinkman@muses.eu','114101302400','walterwhite',0,0.9999,0),(237,'Pinkman','Jesse','jesse.pinkman@muses.eu','420421344230','walterwhite',0,0.9999,0),(238,'Pinkman','Jesse','jesse.pinkman@muses.eu','21111100213','walterwhite',0,0.9999,0),(239,'Pinkman','Jesse','jesse.pinkman@muses.eu','220141404040','walterwhite',0,0.9999,0),(240,'Pinkman','Jesse','jesse.pinkman@muses.eu','400333314220','walterwhite',0,0.9999,0),(241,'Pinkman','Jesse','jesse.pinkman@muses.eu','2032114312002','walterwhite',0,0.9999,0),(242,'Pinkman','Jesse','jesse.pinkman@muses.eu','3204103441312','walterwhite',0,0.9999,0),(243,'Pinkman','Jesse','jesse.pinkman@muses.eu','1342132242101','walterwhite',0,0.9999,0),(244,'Pinkman','Jesse','jesse.pinkman@muses.eu','400022230120','walterwhite',0,0.9999,0),(245,'Pinkman','Jesse','jesse.pinkman@muses.eu','1133221343111','walterwhite',0,0.9999,0),(246,'Pinkman','Jesse','jesse.pinkman@muses.eu','3213134231013','walterwhite',0,0.9999,0),(247,'Pinkman','Jesse','jesse.pinkman@muses.eu','32012010012','walterwhite',0,0.9999,0),(248,'Pinkman','Jesse','jesse.pinkman@muses.eu','2421332301404','walterwhite',0,0.9999,0),(249,'Pinkman','Jesse','jesse.pinkman@muses.eu','431300343132','walterwhite',0,0.9999,0),(250,'Pinkman','Jesse','jesse.pinkman@muses.eu','2034411011221','walterwhite',0,0.9999,0),(251,'Pinkman','Jesse','jesse.pinkman@muses.eu','4134220331440','walterwhite',0,0.9999,0),(252,'Pinkman','Jesse','jesse.pinkman@muses.eu','420443141034','walterwhite',0,0.9999,0),(253,'Pinkman','Jesse','jesse.pinkman@muses.eu','2242203103231','walterwhite',0,0.9999,0),(254,'Pinkman','Jesse','jesse.pinkman@muses.eu','1104110131221','walterwhite',0,0.9999,0),(264,'Pinkman','Jesse','jesse.pinkman@muses.eu','313431320001','walterwhite',0,0.9999,0),(265,'Pinkman','Jesse','jesse.pinkman@muses.eu','2124201232102','walterwhite',0,0.9999,0),(266,'Pinkman','Jesse','jesse.pinkman@muses.eu','3200420421214','walterwhite',0,0.9999,0),(267,'Pinkman','Jesse','jesse.pinkman@muses.eu','3402224212202','walterwhite',0,0.9999,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-12 13:06:15
