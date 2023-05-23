CREATE SCHEMA SM;

CREATE TABLE IF NOT EXISTS SM.ASSET_GROUP(
	assetGroupId		SERIAL PRIMARY KEY,
	--название группы актива(валюта/металл/тд)
	assetGroupName		VARCHAR(32) UNIQUE NOT NULL,
	/*Этот коэфф будет использоваться для подсчёта разницы
	цен внутри группы активов
	у валют свой, у металлов свой и т.д.
	он должен быть согласован с глобальным
	коэфф-ом, чтобы не случилось что сделав несколько
	 продаж по кругу, можно изнеоткуда взять активы*/
	assetGroupRatio		DOUBLE PRECISION NOT NULL,
	--описание(по надобности)
	assetGroupDescription	TEXT
);

CREATE TABLE IF NOT EXISTS SM.ASSET_TYPE(
	assetTypeId		SERIAL PRIMARY KEY,
	--название типа актива(рубль/золото/т.д.)
	assetTypeName		VARCHAR(64) UNIQUE NOT NULL,
	--группа типа актива(валюта/металл/тд)
	assetTypeGroup		INTEGER REFERENCES SM.ASSET_GROUP(assetGroupId) NOT NULL,	
	--локальный коэфф-т актива, определяет его 
	--стоимость относительно других типов акивов
	assetTypeLocalRatio	DOUBLE PRECISION NOT NULL,
	--описание типа актива(по надобности)
	assetTypeDescription	TEXT
);

CREATE TABLE IF NOT EXISTS SM.PERSON(
        personId                SERIAL PRIMARY KEY,
        --Персональные данные, должны заворачиваться в
        --SHA256 перед вставкой
        personFIO               BYTEA,
        userEmail               VARCHAR(254) UNIQUE NOT NULL,
	--нужно выставить проверку, что пароль - это хеш
	--вставку в ппароль следует производить с помощью
	--функции crypt: https://x-team.com/blog/storing-secure-passwords-with-postgresql/
	password		TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS SM.ASSET(
	assetId			SERIAL PRIMARY KEY,
	assetTypeId		INTEGER REFERENCES SM.ASSET_TYPE(assetTypeId) NOT NULL,
	--количество единиц в этом активе
	assetNumber		INTEGER NOT NULL
	CHECK (assetNumber >= 0),
	--владелец актива
	assetOwner		INTEGER REFERENCES SM.PERSON(personId) NOT NULL,
	--коэфф-т по которому покупался актив
	buyRatio		DOUBLE PRECISION NOT NULL,
	--конечная стоимость будет расчитываться на бэке
	--активен ли актив (продан/не продан/заморожен)
	isActive		BOOL NOT NULL
);


