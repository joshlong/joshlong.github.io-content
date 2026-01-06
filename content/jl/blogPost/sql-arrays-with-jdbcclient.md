title=SQL Arrays with Spring's amazing `JdbcClient`
date=2026-01-06
type=post
tags=blog
status=published
~~~~~~


Happy new year! I just wanted to write a quick post about how to solve a problem that vexxed me for hours and I know I'll need again at some point: how to use a SQL array with Spring Framework's `JdbcClient`. 

Imagine you want to write a query where you load all the records with an ID in a given range. In SQL, you have at least two ways to solve it. The first and most natural (to me, anyway) is: `SELECT a,b,c FROM foo WHERE id IN (1,2,3,4)`. This would select all of the records from the `foo` table where the `ID` column matches a value in the range given (1,2,3,4). So my question was: how do I do this using a JDBC `PreparedStatement`? Eg: `SELECT a,b,c FROM foo WHERE id IN (?)`. I could find no useful way to do so. For years, I went against common sense and just implemented the query by joining the IDs as a String in my Java program and concatenating the query, e.g.: 

```java
var sql = "SELECT a, b, c FROM foo WHERE id IN ("  + CollectionUtils.join(collectionOfNumberIds, ",") + ")";
var results = jdbc.sql(sql).query( fooRowMapper ).list();
for (var result : results) {
 // ... 
}
```

This is ugly! But at least it's not a SQL injection attack. It worked, but I don't like it. It also breaks one of the benefits of  good ol' `PreparedStatement`s: they can be precompiled/cached. I figured there's got to be some way to expres this using JDBC's (and SQL's) arrays. But I couldn't find it. So, with a little help from AI, I found the `ANY()` function, which takes a single parameter, of type SQL array. Alright so now I am halfway there! It's _possible_ to send in a single JDBC `Array` in conjunction with a `PreparedStatement`.

Here's how you'd do it in raw JDBC:

```java
// injected into the constructor ...
private final DataSource ds; 

record Customer(int id, String email) {
}

Collection<Customer> getCustomers() throws Exception {
    var customers = new ArrayList<Customer>();
    try (var connection = this.ds.getConnection()) {
        var sql = "select * from customer where ID in (?)";
        var stmt = connection.prepareStatement(sql);
        stmt.setArray(1, connection.createArrayOf("bigint", new Long[]{1L, 2L}));
        try (var rs = stmt.executeQuery();) {
            while (rs.next()) {
                customers.add(new Customer(rs.getInt("ID"), rs.getString("NAME")));
            }
        }
    }
    return customers;
}

```

That works! You ask the JDBC `Connection` to create  array of a given type, in this case an array of `bigint`, and then pass in the values and you're all set. However, it's super verbose. I'd never write this code on purpose. I have too little time and too much to do. I'd use Spring's `JdbcClient`. The problem is that you have no easy way to get the `Connection` from the `JdbcClient`. BUT, behind the scenes the `JdbcClient` is using ye 'ol `JdbcTemplate`, so it accepts parameters from Spring's JDBC _values_ hierarchy, like this:

```java
Collection<Customer> getCustomers() throws Exception {
    return jdbc.sql("select * from customer where ID in (?)")
            .params(new SqlArrayValue("bigint", 1L, 2L))
            .query((rs, _) -> new Customer(rs.getInt("ID"), rs.getString("EMAIL"))).list();
}
```

Nice!
