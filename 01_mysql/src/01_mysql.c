#include "/usr/include/mysql/mysql.h"
#include <string.h>
#include <stdio.h>


#define DB_HOST "163.152.224.142"
#define DB_USER "jiap01"
#define DB_PASS "1234"
#define DB_NAME "sqldb"
#define CHOP(x) x[strlen(x) - 1] = ' '

int main(void)
{
    MYSQL       *connection=NULL, conn;
    MYSQL_RES   *sql_result;
    MYSQL_ROW   sql_row;
    int       query_stat;

    char id[20];
    char name[20];
    char birthYear[20];
    char addr[20];
    char mob1[20];
    char mob2[20];
    char query[255];

    mysql_init(&conn);

    connection = mysql_real_connect(&conn, DB_HOST,
                                    DB_USER, DB_PASS,
                                    DB_NAME, 3306,
                                    (char *)NULL, 0);

    if (connection == NULL)
    {
        fprintf(stderr, "Mysql connection error : %s", mysql_error(&conn));
        return 1;
    }

    query_stat = mysql_query(connection, "select * from usertbl");
    if (query_stat != 0)
    {
        fprintf(stderr, "Mysql query error : %s", mysql_error(&conn));
        return 1;
    }

    sql_result = mysql_store_result(connection);

    printf("%s\t%s\t%s\t%s\t%s\t\n", "ID", "이름", "출생년도", "지역", "전화번호");
    while ( (sql_row = mysql_fetch_row(sql_result)) != NULL )
    {
        printf("%s\t%s\t%s\t%s\t%s %s\t\n",
        		sql_row[0], sql_row[1], sql_row[2],
        		sql_row[3], sql_row[4], sql_row[5]);
    }

    mysql_free_result(sql_result);

    printf("ID :");
    fgets(id, 20, stdin);
    CHOP(id);
    //getchar();

    printf("이름 :");
	fgets(name, 20, stdin);
	CHOP(name);
	//getchar();

    printf("출생년도 :");
	fgets(birthYear, 20, stdin);
	CHOP(birthYear);
	//getchar();

	printf("지역 :");
	fgets(addr, 20, stdin);
	CHOP(addr);
	//getchar();

    printf("전화번호 앞 세자리 :");
    fgets(mob1, 20, stdin);
    CHOP(mob1);
    //getchar();

    printf("전화번호 여덟자리 :");
    fgets(mob2, 20, stdin);
    CHOP(mob2);
    //getchar();

    printf("('%s', '%s', '%s', '%s', '%s','%s'",
            id, name, birthYear, addr, mob1, mob2);

    sprintf(query, "insert into usertbl values "
                   "('%s', '%s', '%s', '%s', '%s','%s')",
                   id, name, birthYear, addr, mob1, mob2);

    query_stat = mysql_query(connection, query);
    if (query_stat != 0)
    {
        fprintf(stderr, "Mysql query error : %s", mysql_error(&conn));
        return 1;
    }

    mysql_close(connection);
}
