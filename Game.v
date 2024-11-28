module Game (
    input enter,pause,up,down,left,right,state,level,playerHp,enemyHp,playerPosition,enemyPosition,playerBullet,enemyBullet,
    output next_state,next_level,next_playerHp,next_enemyHp,next_playerPosition,next_enemyPosition,next_playerBullet,next_enemyBullet
);
getState(
    .enter(enter),
    .pause(pause),
    .state(state),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    //以下是输出
    .next_state(next_state),
    .next_level(next_level)
);

getPlayerPosition(
    .state(state),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .playerPosition(playerPosition),
    //以下是输出
    .next_platerPosition(next_playerPosition)
);

getEnemyPosition(
    .state(state),
    .playerPosition(playerPosition),
    .playerBullet(playerBullet),//躲避玩家子弹？
    .enemyPosition(enemyPosition),
    //以下是输出
    .next_enemyPosition(next_enemyPosition)
);

getBulletPosition(//这个模块计算下一时刻的弹幕碰撞信息（从而生命值的变化情况）以及弹幕位置信息
    .state(state),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    ,enemyBullet(enemyBullet),
    //以下是输出
    .next_playerHp(next_playerHp),
    .next_enemyHp(next_enemyHp),
    .next_playerBullet(next_playerBullet),
    ,next_enemyBullet(next_enemyBullet),
);

endmodule