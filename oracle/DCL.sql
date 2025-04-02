--1. Creamos un usuario (karlos) y contraseña karlos y obligado a cambiar la contraseña al conectarse la 1º vez
create user karlos identified by karlos password expire;
GRANT CONNECT to karlos;  -- permite conectarse a la BBDD

-- Modifica la contraseña del usuario karlos
ALTER USER karlos IDENTIFIED BY karlos;

DROP USER karlos;

--1.1 Es necesario darle privilegio para conectarse y para realizar operaciones (roles CONNECT, CREATE SESSION TO y RESOURCE)
GRANT CONNECT to karlos; -- permite conectarse a la BBDD rol predefinido de oracle que incluye el privilegio CREATE SESSION, antiguamente mas cosas
GRANT CREATE SESSION TO karlos; -- permite conectarse a la BBDD privilegio del sistema
GRANT RESOURCE to karlosvas; -- permite crear tablas, secuencias, etc. (no es necesario para el usuario 2 porque no lo vamos a usar)

-- 2 Bloqueamos el usuario y desbloqueamos el usuario
ALTER USER karlos ACCOUNT LOCK; 
ALTER USER karlos ACCOUNT UNLOCK;

-- 3 comprobar que esta bloqueado
ALTER USER karlos ACCOUNT LOCK; -- LOKED
SELECT * FROM DBA_USERS WHERE USERNAME IN ('KARLOS');
ALTER USER karlos ACCOUNT UNLOCK; -- OPEN
SELECT * FROM DBA_USERS WHERE USERNAME IN ('KARLOS');

-- 4 eliminar un usuario --> Para ello tienes que cerrar conexion
DROP user karlos; -- Elimina el usuario
DROP user karlos CASCADE; -- elimina el usuario y todos los objetos que tiene asociados

-- 5 creamos una tabla en karlos e intentamos borrar el usuario
CREATE table karlos.tabla_a(
    col1     integer,
    col2     varchar2(100)
);

-- Ahora como tiene una tabla no se puede hacer de forma 'normal' por lo que ay que poner CASCADE
DROP user karlos; -- No se pued e eliminar porque tiene objetos asociados
DROP user karlos cascade; -- Elimina el usuario y todos los objetos que tiene asociados

-----------Privilegios-------------
-- 6 Mapa que presenta todos los privilegios existentes
select * from SYSTEM_PRIVILEGE_MAP; 

-- Privilegio del sistema 
--- GRANT ->Dar privilegios a un roll || REVOKE -> quitar privilegios

-- 7 Trabajamos en la siguiente estructura de usuarios
-- DBA -->user1 --> user2
-->Creamos usuarios
CREATE USER user1 IDENTIFIED by user1;
CREATE USER user2 IDENTIFIED by user2;

-->Damos previlegios conexion
GRANT CONNECT to user1;
GRANT CONNECT to user2;

-->Compruebo como DBA que los usuaris an recibido esos privilegios del sistema
select * from DBA_SYS_PRIVS; -- Muestra los privilegios del sistema otorgados a los usuarios o roles
select * from DBA_ROLE_PRIVS; -- Muestra los roles otorgados a los usuarios o roles
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE IN ('USER1', 'USER2'); -- Ejemplo: ¿Puede el usuario USER1 crear tablas? Busca CREATE TABLE en esta vista.
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE IN ('USER1', 'USER2'); -- Ejemplo: ¿Tiene el usuario USER1 el rol CONNECT o RESOURCE?

--> asignar al usuario 1 privilegios para crear usuarios
GRANT CREATE USER TO user1;

-- 9. Provamos la opcion with amount objet
---> Otorgamos privilegios para poder crear tablas (con admin option) y secuencas 
GRANT CREATE TABLE TO user1 WITH ADMIN OPTION; -- Permite crear tablas y dar privilegios a otros usuarios
GRANT CREATE SEQUENCE TO user1; -- Permite crear secuencias
CREATE SEQUENCE my_sequence
START WITH 1       -- Valor inicial
INCREMENT BY 1     -- Incremento entre valores
MINVALUE 1         -- Valor mínimo
MAXVALUE 1000      -- Valor máximo
CYCLE              -- Reinicia la secuencia cuando alcanza el máximo
CACHE 10;          -- Almacena en caché 10 valores para mejorar el rendimiento

---- Revokar privilegios ----
create user user3 identified by user3;

-- Vemso si disponemos del privilegio revoke any privilege
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'SYS' and PRIVILEGE like '%REVOKE%'; -- Privilegio revoke any privilege
-- En Oracle, esta funcionalidad está implícita en los privilegios administrativos (SYSDBA, DBA) o en el uso de WITH ADMIN OPTION.

GRANT CREATE TABLE TO user1 WITH ADMIN OPTION;
GRANT CREATE TABLE TO user2;
REVOKE CREATE TABLE FROM user2; -- Esto es posible porque user1 tiene WITH ADMIN OPTION.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'USER1'; -- Ver los permisos de user1

-- En los revoke no hay cascade, por lo que si revocamos un privilegio a un usuario que tiene el privilegio con admin option, 
-- no se revoca el privilegio a los usuarios que lo han recibido de este usuario.
-- Si has asignado un privilegio con una opcion with admin option, y deseas eliminar esta posibilidad de transmision es necesario revocar el privilegio y asignarlo de nuevo sin la opción.

----------- Grant -----------
GRANT CREATE TABLE TO user1; -- Otorgar privilegio a user1 para crear tablas

-- Diferencias entre with grant option y with admin option
-- Con with grant option no permite revocar el privilegio, mientras que con with admin option si.
-- With grand option se utiliza para objetos como tablas, vistas, etc. y with admin option para privilegios de sistema (como crear tablas, secuencias, etc.)

-- GRANT CREATE TABLE TO user1 WITH GRANT OPTION; -- Error porque crear tablas no es un privilegio de sistema si no de objeto
GRANT SELECT ON clientes TO user1 WITH GRANT OPTION;

----------- Roles -------------
-- Para crear un rol es necesario tener el privilegio CREATE ROLE
grant create role to SYS; -- Otorgar privilegio para crear roles a SYS
CREATE ROLE rol1; -- Creamos un rol
-- En los roles no podemos utilizar with grand option, ya que no es un privilegio de sistema, si no un objeto
-- Si un privilegio se asigna a un rol y el rol al usuario, el privilegio se asigna directamente al usuario, revocar el privilegio del usuario no impedirá que pueda continuar ejerciéndolo (vía rol).
-- Si un privilegio se asigna a un rol y el rol al usuario, el privilegio se asigna directamente al usuario, revocar el privilegio del usuario no impedirá que pueda continuar ejerciéndolo (vía rol).
-- Los roles proporcionan una forma de agrupar privilegios y asignarlos a los usuarios de manera más eficiente.
drop role rol1; -- Eliminar el rol
-- Necesario with admin option para poder eliminar el rol, o drop any role
alter user user1 default role rol1; -- Asignar rol por defecto al usuario

----------- Vistas -------------
-- Vemos los tablespace por defecto y temporal de los usuarios de la BBDD
show con_name;
SELECT * FROM CDB_PDBS;
ALTER SESSION SET CONTAINER = ORCLPDB1; -- Cambiamos a la PDB

select * from USER_USERS; -- Informacion del usuario actual
select * from ALL_USERS; -- Informacion de todos los usuarios

-- Vemos el tablespace por defecto y temporal de los usuarios de la BBDD
SELECT * FROM DBA_USERS;

-- Vemos el perfil del usuario
SELECT * FROM DBA_profiles;

select * from SYSTEM_PRIVILEGE_MAP; -- Listado de todos los privilegios de sistema. 
select * from DBA_SYS_PRIVS; -- Privilegios de sistema asignados a los usuarios o a los roles. 
SELECT * from SESSION_PRIVS; -- privilegios de sistema actualmente activos en la sesión. 
SELECT * from USER_SYS_PRIVS; -- Privilegios de sistema asignados al usuario activo. 
SELECT * from DBA_TAB_PRIVS; -- Privilegios sobre objetos asignados a los usuarios o a los roles. 
SELECT * from DBA_COL_PRIVS; -- Privilegios sobre objetos asignados a los usuarios o a los roles sobre ciertas columnas del objeto. 
SELECT * from TABLA_PRIVILEGE_MAP; -- lista de todos los privilegios sobre objetos.
SELECT * from USER_TAB_PRIVS; -- Concesiones sobre objetos que son propiedad del usuario, concedidos o recibidos por éste. 
SELECT * from USER_TAB_PRIVS_MADE; -- Concesiones sobre objetos que son propiedad del usuario (asignadas).
SELECT * from USER_TAB_PRIVS_RECD; -- Concesiones sobre objetos que recibe el usuario.