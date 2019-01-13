//トリガーテスト用
// Accountオブジェクトを挿入する前に、
// 該当トリガーを行うこと。
trigger MyFirstTrigger on Account (before insert) {
    if (Trigger.isInsert){
        System.debug('data is inserted...');
    }
}