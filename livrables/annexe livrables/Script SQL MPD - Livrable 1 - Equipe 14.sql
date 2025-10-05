#------------------------------------------------------------
#        Script MySQL.
#------------------------------------------------------------


#------------------------------------------------------------
# Table: Date
#------------------------------------------------------------

CREATE TABLE Date(
        Code_Date Int  Auto_increment  NOT NULL ,
        Date      Date NOT NULL
	,CONSTRAINT Date_PK PRIMARY KEY (Code_Date)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Rapport
#------------------------------------------------------------

CREATE TABLE Rapport(
        Code_Rapport            Int  Auto_increment  NOT NULL ,
        Nom_Rapport             Varchar (50) NOT NULL ,
        Rapport_Complet_Fichier Text NOT NULL ,
        Code_Date               Int NOT NULL
	,CONSTRAINT Rapport_PK PRIMARY KEY (Code_Rapport)

	,CONSTRAINT Rapport_Date_FK FOREIGN KEY (Code_Date) REFERENCES Date(Code_Date)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Adresse
#------------------------------------------------------------

CREATE TABLE Adresse(
        Code_Adresse    Int  Auto_increment  NOT NULL ,
        Adresse_Postale Varchar (50) NOT NULL ,
        Rue             Varchar (50) NOT NULL COMMENT "La Rue est un VARCHAR car cela peut s'écrire 3 bis par exemple"  ,
        Numero_de_Rue   Varchar (50) NOT NULL ,
        Region          Varchar (50) NOT NULL ,
        Ville           Varchar (50) NOT NULL
	,CONSTRAINT Adresse_PK PRIMARY KEY (Code_Adresse)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Agence
#------------------------------------------------------------

CREATE TABLE Agence(
        Code_Agence        Int  Auto_increment  NOT NULL ,
        Chefs_Lieux_Agence Varchar (50) NOT NULL ,
        Code_Adresse       Int NOT NULL
	,CONSTRAINT Agence_PK PRIMARY KEY (Code_Agence)

	,CONSTRAINT Agence_Adresse_FK FOREIGN KEY (Code_Adresse) REFERENCES Adresse(Code_Adresse)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Gaz
#------------------------------------------------------------

CREATE TABLE Gaz(
        Code_Gaz    Int  Auto_increment  NOT NULL ,
        Nom_Gaz     Varchar (50) NOT NULL ,
        Type_de_Gaz Varchar (50) NOT NULL ,
        Sigle_GAz   Varchar (50) NOT NULL
	,CONSTRAINT Gaz_PK PRIMARY KEY (Code_Gaz)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Capteur
#------------------------------------------------------------

CREATE TABLE Capteur(
        Code_Capteur Int  Auto_increment  NOT NULL ,
        Lieu_Capteur Varchar (50) NOT NULL ,
        État_Capteur Bool NOT NULL ,
        Code_Agence  Int NOT NULL ,
        Code_Gaz     Int NOT NULL
	,CONSTRAINT Capteur_PK PRIMARY KEY (Code_Capteur)

	,CONSTRAINT Capteur_Agence_FK FOREIGN KEY (Code_Agence) REFERENCES Agence(Code_Agence)
	,CONSTRAINT Capteur_Gaz0_FK FOREIGN KEY (Code_Gaz) REFERENCES Gaz(Code_Gaz)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Mesure
#------------------------------------------------------------

CREATE TABLE Mesure(
        Code_Mesure   Int  Auto_increment  NOT NULL ,
        Valeur_Mesure Varchar (50) NOT NULL ,
        Code_Capteur  Int NOT NULL ,
        Code_Date     Int NOT NULL ,
        Code_Gaz      Int NOT NULL
	,CONSTRAINT Mesure_PK PRIMARY KEY (Code_Mesure)

	,CONSTRAINT Mesure_Capteur_FK FOREIGN KEY (Code_Capteur) REFERENCES Capteur(Code_Capteur)
	,CONSTRAINT Mesure_Date0_FK FOREIGN KEY (Code_Date) REFERENCES Date(Code_Date)
	,CONSTRAINT Mesure_Gaz1_FK FOREIGN KEY (Code_Gaz) REFERENCES Gaz(Code_Gaz)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Agent
#------------------------------------------------------------

CREATE TABLE Agent(
        Code_Agent             Int  Auto_increment  NOT NULL ,
        Nom_Agent              Varchar (50) NOT NULL ,
        Prenom_Agent           Varchar (50) NOT NULL ,
        Poste_Agent            Varchar (50) NOT NULL ,
        Role_Agent             Varchar (50) NOT NULL ,
        Dernier_Diplome_acquis Varchar (50) NOT NULL ,
        Code_Capteur           Int NOT NULL ,
        Code_Date              Int NOT NULL ,
        Code_Date_Debuter      Int NOT NULL ,
        Code_Adresse           Int NOT NULL ,
        Code_Agence            Int NOT NULL
	,CONSTRAINT Agent_PK PRIMARY KEY (Code_Agent)

	,CONSTRAINT Agent_Capteur_FK FOREIGN KEY (Code_Capteur) REFERENCES Capteur(Code_Capteur)
	,CONSTRAINT Agent_Date0_FK FOREIGN KEY (Code_Date) REFERENCES Date(Code_Date)
	,CONSTRAINT Agent_Date1_FK FOREIGN KEY (Code_Date_Debuter) REFERENCES Date(Code_Date)
	,CONSTRAINT Agent_Adresse2_FK FOREIGN KEY (Code_Adresse) REFERENCES Adresse(Code_Adresse)
	,CONSTRAINT Agent_Agence3_FK FOREIGN KEY (Code_Agence) REFERENCES Agence(Code_Agence)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Rédiger
#------------------------------------------------------------

CREATE TABLE Rediger(
        Code_Agent   Int NOT NULL ,
        Code_Rapport Int NOT NULL
	,CONSTRAINT Rediger_PK PRIMARY KEY (Code_Agent,Code_Rapport)

	,CONSTRAINT Rediger_Agent_FK FOREIGN KEY (Code_Agent) REFERENCES Agent(Code_Agent)
	,CONSTRAINT Rediger_Rapport0_FK FOREIGN KEY (Code_Rapport) REFERENCES Rapport(Code_Rapport)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Se lier
#------------------------------------------------------------

CREATE TABLE Se_lier(
        Code_Rapport Int NOT NULL ,
        Code_Mesure  Int NOT NULL
	,CONSTRAINT Se_lier_PK PRIMARY KEY (Code_Rapport,Code_Mesure)

	,CONSTRAINT Se_lier_Rapport_FK FOREIGN KEY (Code_Rapport) REFERENCES Rapport(Code_Rapport)
	,CONSTRAINT Se_lier_Mesure0_FK FOREIGN KEY (Code_Mesure) REFERENCES Mesure(Code_Mesure)
)ENGINE=InnoDB;

