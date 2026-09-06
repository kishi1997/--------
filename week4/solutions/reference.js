const assert = require("node:assert/strict");
const { performance } = require("node:perf_hooks");
const db = require("../lib/database");
const { printReport } = require("../lib/report");

const USERS_SQL = `
  select id, name, email
  from n1_users
  order by id
  limit 20
`;

async function measure(label, loader) {
  db.resetQueryCount();
  const startedAt = performance.now();
  const users = await loader();
  const report = {
    label,
    users,
    queryCount: db.getQueryCount(),
    elapsedMs: performance.now() - startedAt,
  };
  printReport(report);
  return report;
}

async function loadWithNPlusOne() {
  const { rows: users } = await db.query(USERS_SQL);
  for (const user of users) {
    const { rows: posts } = await db.query(
      `select id, user_id, title, published_at
       from n1_posts where user_id = $1 order by id`,
      [user.id],
    );
    user.posts = posts;
  }
  return users;
}

async function loadWithJoin() {
  const { rows } = await db.query(`
    with selected_users as (
      select id, name, email
      from n1_users
      order by id
      limit 20
    )
    select
      u.id as user_id,
      u.name as user_name,
      u.email as user_email,
      p.id as post_id,
      p.title as post_title,
      p.published_at
    from selected_users u
    left join n1_posts p on p.user_id = u.id
    order by u.id, p.id
  `);

  const users = new Map();
  for (const row of rows) {
    if (!users.has(row.user_id)) {
      users.set(row.user_id, {
        id: row.user_id,
        name: row.user_name,
        email: row.user_email,
        posts: [],
      });
    }
    if (row.post_id !== null) {
      users.get(row.user_id).posts.push({
        id: row.post_id,
        user_id: row.user_id,
        title: row.post_title,
        published_at: row.published_at,
      });
    }
  }
  return [...users.values()];
}

async function loadWithBatching() {
  const { rows: users } = await db.query(USERS_SQL);
  const userIds = users.map((user) => user.id);
  const { rows: posts } = await db.query(
    `select id, user_id, title, published_at
     from n1_posts
     where user_id = any($1::bigint[])
     order by user_id, id`,
    [userIds],
  );

  const postsByUserId = new Map();
  for (const post of posts) {
    const key = String(post.user_id);
    const group = postsByUserId.get(key) || [];
    group.push(post);
    postsByUserId.set(key, group);
  }
  for (const user of users) {
    user.posts = postsByUserId.get(String(user.id)) || [];
  }
  return users;
}

async function main() {
  const nPlusOne = await measure("N+1", loadWithNPlusOne);
  const join = await measure("JOIN", loadWithJoin);
  const batching = await measure("Batching", loadWithBatching);

  assert.equal(nPlusOne.queryCount, 21);
  assert.equal(join.queryCount, 1);
  assert.equal(batching.queryCount, 2);

  for (const result of [nPlusOne, join, batching]) {
    assert.equal(result.users.length, 20);
    assert.equal(
      result.users.reduce((sum, user) => sum + user.posts.length, 0),
      500,
    );
  }

  console.log("\nOK: 3パターンは同じデータを取得し、SQL数だけが異なります");
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => db.close());
