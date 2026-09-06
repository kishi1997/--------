function printReport({ label, users, queryCount, elapsedMs }) {
  const postCount = users.reduce((sum, user) => sum + user.posts.length, 0);

  console.log(`\n${label}`);
  console.log(`SQL数: ${queryCount}`);
  console.log(`ユーザー数: ${users.length}`);
  console.log(`投稿数: ${postCount}`);
  console.log(`実行時間: ${elapsedMs.toFixed(2)} ms`);
  console.log("サンプル:", users.slice(0, 2));
}

module.exports = { printReport };
