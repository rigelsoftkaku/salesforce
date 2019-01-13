public without sharing class CaseInfoService {
		// 抽出対象となるフィールドリスト
	private static List<String> TARGET_FIELDS = new List<String>{
             'Id'
            ,'Name'
            ,'caseId__c'
            ,'caseSummary__c'
            ,'caseName__c'
            ,'workStartDate__c'
            ,'workEndDate__c'
            ,'workSpace__c'
            ,'workContent__c'
            ,'workerCount__c'
            ,'price__c'
            ,'LastModifiedDate'
        };

	/**
	*案件番号を基づいて、案件情報を取得する
	*/
    public CaseBaseInfo__c getCaseInfoById(String caseId){
        // 検索条件からSOQLを作成
        // List<String> param = new String[]{ getFieldList()};
        // String soqlQuery = String.format('SELECT {0} FROM CaseBaseInfo__c WHERE caseId__c=\'' + caseId + '\'', param);
        CaseBaseInfo__c caseBaseInfo = [SELECT caseId__c,caseName__c,caseSummary__c,workStartDate__c,workEndDate__c,workSpace__c,workContent__c,workerCount__c,price__c FROM CaseBaseInfo__c WHERE (caseId__c=:caseId) LIMIT 1];
        return caseBaseInfo;
    }

   	// SELECT対象フィールド
	private String getFieldList(){
		return String.join(TARGET_FIELDS, ',');
	}
}